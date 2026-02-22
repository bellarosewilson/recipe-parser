# RecipePolicy allows show to any signed-in user; update/destroy/parse only for the recipe author.
class RecipePolicy < ApplicationPolicy
  def show?
    true
  end

  def update?
    user.present? && record.author_id == user.id
  end

  def destroy?
    user.present? && record.author_id == user.id
  end

  def parse?
    user.present? && record.author_id == user.id
  end
end
