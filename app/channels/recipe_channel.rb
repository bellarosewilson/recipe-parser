# frozen_string_literal: true

class RecipeChannel < ApplicationCable::Channel
  def subscribed
    recipe = Recipe.find(params[:id])
    stream_for recipe
  end

  def unsubscribed
    stop_all_streams
  end
end
