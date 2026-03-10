# frozen_string_literal: true

class StepPolicy < ApplicationPolicy
  def show?
    user.present? && record.recipe && record.recipe.author_id == user.id
  end

  def create?
    false
  end

  def update?
    user.present? && record.recipe && record.recipe.author_id == user.id
  end

  def destroy?
    user.present? && record.recipe && record.recipe.author_id == user.id
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.none unless user.present?

      scope.joins(:recipe).where(recipes: { author_id: user.id })
    end
  end
end
