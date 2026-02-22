class RecipesController < ApplicationController
  def index
    @list_of_recipes = Recipe.order(created_at: :desc)
    render template: "recipe_templates/index"
  end

  def show
    @the_recipe = Recipe.find(params[:path_id])
    @can_reparse_recipe = @the_recipe.original_image.attached? && (respond_to?(:current_user) && current_user == @the_recipe.author)
    render template: "recipe_templates/show"
  end

  def new
    render template: "recipe_templates/new"
  end

  def create
    result = Recipes::CreateFromImageService.call(
      uploaded_file: params[:recipe_file],
      author: recipe_author
    )
    opts = result.notice.present? ? { notice: result.notice } : { alert: result.alert }
    redirect_to result.redirect_path, opts
  end

  def parse
    @recipe = Recipe.find(params[:path_id])
    if @recipe.parse_original_image(preferred_units: recipe_author.preferred_units)
      redirect_to "/recipes/#{@recipe.id}", notice: "Recipe parsed successfully from image."
    else
      redirect_to "/recipes/#{@recipe.id}", alert: "Could not parse recipe (no image attached?)."
    end
  end

  def update
    @the_recipe = Recipe.find(params[:path_id])
    if @the_recipe.update(update_params)
      redirect_to "/recipes/#{@the_recipe.id}", notice: "Recipe updated successfully."
    else
      redirect_to "/recipes/#{@the_recipe.id}", alert: @the_recipe.errors.full_messages.to_sentence
    end
  end

  def destroy
    @the_recipe = Recipe.find(params[:path_id])
    @the_recipe.destroy
    redirect_to "/recipes", notice: "Recipe deleted successfully."
  end

  private

  def recipe_author
    (respond_to?(:current_user) && current_user) || User.first
  end

  def update_params
    {
      title: params[:query_title],
      author_id: params[:query_author_id],
      source_url: params[:query_source_url]
    }
  end
end
