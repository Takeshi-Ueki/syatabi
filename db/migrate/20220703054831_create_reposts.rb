class CreateReposts < ActiveRecord::Migration[6.1]
  def change
    create_table :reposts do |t|
      t.references :user, type: :bigint, null: false, foreign_key: true
      t.references :post, type: :bigint, null: false, foreign_key: true

      t.timestamps
    end
  end
end
