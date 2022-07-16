class CreatePostComments < ActiveRecord::Migration[6.1]
  def change
    create_table :post_comments do |t|
      t.references :user, type: :integer, null: false, foreign_key: true
      t.references :post, type: :integer, null: false, foreign_key: true
      t.string :comment, null: false

      t.timestamps
    end
  end
end
