class User < ApplicationRecord
    before_save { self.email = email.downcase }
    has_many :stories, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :followed_users, foreign_key: :follower_id, class_name: 'Follow', dependent: :destroy
    has_many :followings, through: :followed_users
    has_many :following_users, foreign_key: :following_id, class_name: 'Follow', dependent: :destroy
    has_many :followers, through: :following_users

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :username, presence: true, 
        uniqueness: { case_sensitive: false }, 
        length: { minimum: 3, maximum: 25 }
    validates :email, presence: true, 
        uniqueness: { case_sensitive: false }, 
        length: { maximum: 126 },
        format: { with: VALID_EMAIL_REGEX, message: "format incorrect" }
    has_secure_password
end