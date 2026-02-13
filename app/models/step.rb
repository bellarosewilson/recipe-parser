# == Schema Information
#
# Table name: steps
#
#  id          :bigint           not null, primary key
#  instruction :string
#  position    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  recipe_id   :integer
#
class Step < ApplicationRecord
 belongs_to :recipe, required: true, class_name: "Recipe", foreign_key: "recipe_id"
end
