class CreatePostComments < ActiveRecord::Migration[6.1]
  def change
    create_table :post_comments do |t|
      t.integer :user_id, null: false, foreign_key: true
      t.integer :post_id, null: false, foreign_key: true
      t.string :comment, null: false
      t.boolean :is_active, default: true

      t.timestamps
    end
  end
end
