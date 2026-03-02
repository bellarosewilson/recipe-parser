# RecipePolicy allows show to any signed-in user; update/destroy/parse only for the recipe author.
# Tightening up Security, now Returns only recipes belonging to the current user.
class RecipePolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    user.present?
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

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.none unless user.present?

      scope.where(author_id: user.id)
    end
  end
end
