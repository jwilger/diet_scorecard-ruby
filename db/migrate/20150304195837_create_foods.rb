class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.references :meal, index: true
      t.string :name
      t.text :servings

      t.timestamps null: false
    end
    add_foreign_key :foods, :meals
  end
end
