class Like < ApplicationRecord
  belongs_to :user
  belongs_to :micropost
  counter_culture :micropost
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :micropost_id, presence: true
end
