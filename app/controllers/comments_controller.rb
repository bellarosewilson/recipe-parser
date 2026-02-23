# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    commentable = commentable_from_params
    @comment = commentable.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_back fallback_location: commentable_path(commentable), notice: "Note Added"
    else
      redirect_back fallback_location: commentable_path(commentable), alert: @comment.errors.full_messages.to_sentence
    end
  end

  private

  def commentable_from_params
    if params[:recipe_id].present?
      Recipe.find(params[:recipe_id])
    elsif params[:step_id].present?
      Step.find(params[:step_id])
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def commentable_path(commentable)
    case commentable
    when Recipe then recipe_path(commentable)
    when Step then recipe_path(commentable.recipe)
    else root_path
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
