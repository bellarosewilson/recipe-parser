class CreateRecipes < ActiveRecord::Migration[8.0]
  def change
    create_table :recipes do |t|
      t.string :title
      t.integer :author_id
      t.string :source_url

      t.timestamps
    end
  end
end
