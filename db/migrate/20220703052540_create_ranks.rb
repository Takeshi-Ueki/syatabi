class CreateRanks < ActiveRecord::Migration[6.1]
  def change
    create_table :ranks do |t|
      t.bigint :user_id, type: :bigint, null: false, foreign_key: true
      t.integer :post_id, null: false, foreign_key: true
      t.integer :rank

      t.timestamps
    end
  end
end
