class CreateStories < ActiveRecord::Migration[6.1]
  def change
    create_table :stories do |t|
      t.string :title
      t.text :content
      t.timestamps
    end
    add_reference :stories, :user, foreign_key: true
  end
end
