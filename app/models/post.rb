class Post < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :description, length: { maximum: 314 }
  include ImageUploader::Attachment(:image)
end
