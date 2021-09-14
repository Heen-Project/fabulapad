class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.text :content
      t.timestamps
    end
    add_reference :comments, :user, foreign_key: true
    add_reference :comments, :story, foreign_key: true
  end
end
