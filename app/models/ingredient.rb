# == Schema Information
#
# Table name: ingredients
#
#  id         :bigint           not null, primary key
#  amount     :string
#  name       :string
#  unit       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  recipe_id  :integer
#
class Ingredient < ApplicationRecord
 belongs_to :recipe, required: true, class_name: "Recipe", foreign_key: "recipe_id"

 validates :name, presence: true
 validates :amount, presence: true
 validates :unit, presence: true
 validates :recipe_id, presence: true
end
