class CreateLists < ActiveRecord::Migration[6.1]
  def change
    create_table :lists do |t|
      t.references :user, type: :integer, null: false, foreign_key: true
      t.references :post, type: :integer, null: false, foreign_key: true
      t.string :memo
      t.timestamps
    end
  end
end
