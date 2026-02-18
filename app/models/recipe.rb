# == Schema Information
#
# Table name: recipes
#
#  id         :bigint           not null, primary key
#  source_url :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :integer
#
class Recipe < ApplicationRecord
  belongs_to :author, required: true, class_name: "User", foreign_key: "author_id"

  has_many :recipe_ingredients, class_name: "Ingredient", foreign_key: "recipe_id", dependent: :destroy
  has_many :steps, class_name: "Step", foreign_key: "recipe_id", dependent: :destroy

  has_one_attached :original_image

  validates :title, presence: true
  validates :author_id, presence: true

  # For User to be able to delete ingredeients/steps when editing/reviewing recipe
  accepts_nested_attributes_for :recipe_ingredients, allow_destroy: true
  accepts_nested_attributes_for :steps, allow_destroy: true

  def parse_original_image(preferred_units: "metric")
    return {} unless original_image.attached?

    parser = OpenAiParser::ParserService.new(
      original_image.blob,
      preferred_units
    )
    parsed = parser.parse_recipe

    update(
      title: parsed[:title],
      recipe_ingredients_attributes: parsed[:ingredients],
      steps_attributes: parsed[:steps]
    )
  end
end
