class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable, :validatable
  # posts
  has_many :posts, dependent: :destroy

  # comments
  has_many :comments, dependent: :destroy

  # likes
  has_many :likes, dependent: :destroy

  # follows
  has_many :follows

  has_many :follower_relationships, foreign_key: :following_id,
                                    class_name: 'Follow',
                                    dependent: :destroy
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :following_relationships, foreign_key: :follower_id,
                                     class_name: 'Follow',
                                     dependent: :destroy
  has_many :following, through: :following_relationships, source: :following

  # validations
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[\w\-.]+[\w\-]\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: true

  # Follows a user.
  def follow(other_user)
    following << other_user
  end

  # Unfollows a user.
  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  # Gets posts for feed
  def feed
    following_ids = 'SELECT following_id FROM follows
                     WHERE follower_id = :user_id'
    Post.where("user_id IN (#{following_ids})
                        OR user_id = :user_id", user_id: id)
  end
end
