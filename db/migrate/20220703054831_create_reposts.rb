class CreateReposts < ActiveRecord::Migration[6.1]
  def change
    create_table :reposts do |t|
      t.bigint :user_id, null: false, foreign_key: true
      t.integer :post_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
