class Step < ApplicationRecord
 belongs_to :recipe, required: true, class_name: "Recipe", foreign_key: "recipe_id"
end
