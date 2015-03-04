class AddUserIdToMeals < ActiveRecord::Migration
  def change
    add_column :meals, :user_id, :integer, null: false
    add_index :meals, :user_id
  end
end
