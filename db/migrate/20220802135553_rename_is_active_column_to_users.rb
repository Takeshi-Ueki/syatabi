class RenameIsActiveColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :is_active, :user_status
  end
end
