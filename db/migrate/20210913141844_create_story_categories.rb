class CreateStoryCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :story_categories do |t|
      t.timestamps
    end
    add_reference :story_categories, :story, foreign_key: true
    add_reference :story_categories, :category, foreign_key: true
  end
end
