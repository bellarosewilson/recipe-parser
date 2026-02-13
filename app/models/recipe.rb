class Recipe < ApplicationRecord
 belongs_to :author, required: true, class_name: "User", foreign_key: "author_id"
 
 has_many  :recipe_ingredients, class_name: "Ingredient", foreign_key: "recipe_id", dependent: :destroy
 has_many  :steps, class_name: "Step", foreign_key: "recipe_id", dependent: :destroy
end
