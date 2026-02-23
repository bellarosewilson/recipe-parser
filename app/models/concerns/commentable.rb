# frozen_string_literal: true

# Shared behavior for models that can receive polymorphic comments (e.g. Recipe, Step).
# Include in any model that has_many :comments, as: :commentable.
module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable, dependent: :destroy
  end
end
