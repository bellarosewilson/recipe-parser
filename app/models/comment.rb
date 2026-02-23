# frozen_string_literal: true

class Comment < ApplicationRecord
  before_validation :strip_comment_body

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true, length: { maximum: 2000 }

  private

  def strip_comment_body
    self.body = body.to_s.strip if body.present?
  end
end
