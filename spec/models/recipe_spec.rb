require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe 'associations' do
    it { should belong_to(:author).class_name('User') }
    it { should have_many(:recipe_ingredients).class_name('Ingredient') }
    it { should have_many(:steps) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:author_id) }
  end
end
