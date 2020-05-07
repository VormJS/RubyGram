class User < ApplicationRecord
  # posts
  has_many :posts, dependent: :destroy

  # comments
  has_many :comments, dependent: :destroy

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
  attr_accessor :remember_token
  before_save { email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[\w\-.]+[\w\-]\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the diou can see our join model belongs to two types of users, a “follower” and a “following”. gest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

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
