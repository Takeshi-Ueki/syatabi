class CreateDiaries < ActiveRecord::Migration[6.1]
  def change
    create_table :diaries do |t|
      t.integer :user_id, null: false, foreign_key: true
      t.integer :post_id, null: false, foreign_key: true
      t.string :title, null: false
      t.text :body, null: false
      t.boolean :is_public, default: true

      t.timestamps
    end
  end
end
