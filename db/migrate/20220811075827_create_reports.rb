class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.integer :reporter_id, null: false
      t.integer :reported_id, null: false
      t.string :reason, null: false
      t.string :url
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
