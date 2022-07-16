class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.references :user, type: :integer, null: false, foreign_key: true
      t.string :body, null: false
      t.decimal :lat
      t.decimal :long
      t.boolean :is_active, null: false, default: true

      t.timestamps
    end
  end
end
