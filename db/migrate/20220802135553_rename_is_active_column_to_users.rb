class RenameIsActiveColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :is_active, :withdraw_status
  end
end
