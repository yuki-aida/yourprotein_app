class Micropost < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :favorite_users, through: :likes, source: :user
  # デフォルトの順序を降順へ(新しい投稿から古い投稿の順序で並ぶ)
  default_scope -> { order(created_at: :desc) }     # ラムダ式という文法(すぐに理解しなくても良い)
  mount_uploader :picture, PictureUploader   # CarrierWaveに画像と関連付けたモデルを伝える
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 400 }
  validates :title, presence: true, length: { maximum: 40 }
  validates :category, presence: true
  # 独自のバリデーションなのでvalidateメソッドを使う
  validate :picture_size
  
  def self.search(search)
    if search
      where(['title LIKE ?', "%#{search}%"]) #検索とcontentの部分一致を表示
    else
      all #全て表示
    end
  end
  
  # マイクロポストをいいねする
  def favorite(user)
    likes.create(user_id: user.id)
  end

  # マイクロポストのいいねを解除する
  def unfavorite(user)
    likes.find_by(user_id: user.id).destroy
  end
  
  # 現在のユーザーがいいねしてたらtrueを返す
  def favorite?(user)
    # そのマイクロポストをいいねしている全てのユーザーを配列で返し、current_userが
    # 含まれているか確かめる
    favorite_users.include?(user)
  end
  
  private
    
    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
  
end
