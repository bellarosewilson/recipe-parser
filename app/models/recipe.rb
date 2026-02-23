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
  scope :recent, -> { order(created_at: :desc) }
  
  belongs_to :author, required: true, class_name: "User", foreign_key: "author_id"

  has_many :recipe_ingredients, class_name: "Ingredient", foreign_key: "recipe_id", dependent: :destroy
  has_many :steps, class_name: "Step", foreign_key: "recipe_id", dependent: :destroy

  has_one_attached :original_image

  validates :title, presence: true
  validates :author_id, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[author_id created_at id source_url title updated_at]
  end
  # For User to be able to delete ingredeients/steps when editing/reviewing recipe
  accepts_nested_attributes_for :recipe_ingredients, allow_destroy: true
  accepts_nested_attributes_for :steps, allow_destroy: true

  # Applies parsed data to the recipe. Returns [success, errors]
  def apply_parsed_data(parsed_data)
    ok = update(
      title: parsed_data[:title],
      recipe_ingredients_attributes: parsed_data[:ingredients],
      steps_attributes: parsed_data[:steps],
    )
    return [true, nil] if ok

    errors = errors.full_messages.to_a
    recipe_ingredients.each { |i| errors.concat(i.errors.full_messages) }
    steps.each { |s| errors.concat(s.errors.full_messages) }
    [false, errors.uniq]
  end

  def parse_original_image(preferred_units: "metric")
    return false unless original_image.attached?

    parser = OpenAiParser::ParserService.new(
      original_image.blob,
      preferred_units
    )
    parsed = parser.parse_recipe
    apply_parsed_data(parsed).first
  end
end
