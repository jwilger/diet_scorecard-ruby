class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.string :name
      t.datetime :consumed_at

      t.timestamps null: false
    end
    add_index :meals, :consumed_at
  end
end
