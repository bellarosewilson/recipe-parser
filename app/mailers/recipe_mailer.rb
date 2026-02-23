# frozen_string_literal: true

class RecipeMailer < ApplicationMailer
  def parse_confirmation(recipe, user)
    @recipe = recipe
    @user = user
    @recipe_url = recipe_url(recipe)
    @ingredient_count = recipe.recipe_ingredients.size
    @step_count = recipe.steps.size

    attach_recipe_image_if_present

    mail(
      to: user.email,
      subject: "Recipe parsed: #{recipe.title}"
    )
  end

  private

  def attach_recipe_image_if_present
    return unless @recipe.original_image.attached?

    blob = @recipe.original_image.blob
    attachments[blob.filename.to_s] = {
      mime_type: blob.content_type,
      content: @recipe.original_image.download
    }
  end
end
