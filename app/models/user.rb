class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  # following配列の元はfollowed idの集合であるということをrailsに伝える
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :likes, dependent: :destroy
  # attr_accessorで明示することでremember_tokenがローカル変数ではないことを明示？
  attr_accessor :remember_token, :activation_token, :reset_token
  # ここのselfは現在のユーザーを指す。(saveされる前に現在のユーザーのアドレスが
  # 小文字に変換される)
  # before_saveコールバックはオブジェクトが生成される直前、保存される直前、更新される
  # 直前に呼び出される
  before_save :downcase_email
  # オブジェクト作成時にのみ呼び出される
  before_create :create_activation_digest
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  # 渡された文字列のハッシュを返す。（has_secure_passwordによるbcryptパスワードを
  # 生成する）
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続セッションのためのユーザーをデータベースに保存する
  def remember
    # remember_tokenという仮想の属性を作成
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # 渡されたトークンがダイジェストと一致したらtrueを返す
  # 引数のremember_tokenはローカル変数（:remember_tokenとは異なる）
  def authenticated?(attribute, remember_token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(remember_token)
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  
   # アカウントを有効にする
  def activate
    # user.とするとエラーになる。(self.なら可。でもモデル内では必須ではない)
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
   # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token),
                reset_sent_at: Time.zone.now)
  end
  
  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  # パスワード再設定の期限が切れている場合はtrueを返す(reset_sent_atの値が現在時刻
  # から数えて二時間よりも前の場合)
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
  # 試作feedの定義
  # 完全な実装は次章の「ユーザーをフォローする」を参照
  # user_id = ?があることでSQLクエリに代入される前にidがエスケープされる。
  # idはself.idと同義
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end
  
  # ユーザーをフォローする
  def follow(other_user)
    # following配列の最後の要素としてother_userを加える
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end
  
  def self.search(search)
    if search
      where(['name LIKE ?', "%#{search}%"]) #検索とnameの部分一致を表示。#User.は省略
    else
      all #全て表示
    end
  end
  
  private
    # メールアドレスを全て小文字にする
    def downcase_email
      self.email = self.email.downcase
    end
    
    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
