class Category < ApplicationRecord
    has_many :story_categories, dependent: :destroy
    has_many :stories, through: :story_categories

    validates :name, presence: true, length: { minimum: 3, maximum: 25 }
    validates_uniqueness_of :name
end