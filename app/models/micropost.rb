class Micropost < ApplicationRecord
  belongs_to :user
  # デフォルトの順序を降順へ(新しい投稿から古い投稿の順序で並ぶ)
  default_scope -> { order(created_at: :desc) }     # ラムダ式という文法(すぐに理解しなくても良い)
  mount_uploader :picture, PictureUploader   # CarrierWaveに画像と関連付けたモデルを伝える
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  # 独自のバリデーションなのでvalidateメソッドを使う
  validate :picture_size
  
  def self.search(search)
    if search
      where(['content LIKE ?', "%#{search}%"]) #検索とcontentの部分一致を表示
    else
      all #全て表示
    end
  end
  
  private
    
    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
  
end
