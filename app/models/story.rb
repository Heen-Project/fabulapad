class Story < ApplicationRecord
    belongs_to :user
    has_many :comments, dependent: :destroy
    has_many :story_categories, dependent: :destroy
    has_many :categories, through: :story_categories
    scope :subscribed, ->(followers) { where user_id: followers }

    validates :title, presence: true, length: { minimum: 6, maximum: 255 }
    validates :content, presence: true, length: { minimum: 50, message: "length are to short" }
    has_rich_text :content
end