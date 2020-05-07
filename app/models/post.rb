class Post < ApplicationRecord
  # users
  belongs_to :user

  # comments
  has_many :comments, dependent: :destroy

  # validations and options
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :description, length: { maximum: 314 }
  include ImageUploader::Attachment(:image)
end
