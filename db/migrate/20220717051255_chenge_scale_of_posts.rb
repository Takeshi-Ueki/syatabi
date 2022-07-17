class ChengeScaleOfPosts < ActiveRecord::Migration[6.1]
  def change
    change_column :posts, :lat, :decimal, precision: 7, scale: 4
    change_column :posts, :long, :decimal, precision: 7, scale: 4
  end
end
