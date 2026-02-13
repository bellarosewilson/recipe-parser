class CreateIngredients < ActiveRecord::Migration[8.0]
  def change
    create_table :ingredients do |t|
      t.integer :recipe_id
      t.string :unit
      t.string :amount
      t.string :name

      t.timestamps
    end
  end
end
