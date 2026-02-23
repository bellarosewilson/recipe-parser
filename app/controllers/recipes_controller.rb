class RecipesController < ApplicationController
  def index
    @q = Recipe.ransack(params[:q])
    @list_of_recipes = @q.result.recent.includes(:author).page(params[:page]).per(12)
    render template: "recipe_templates/index"
  end

  def show
    @the_recipe = Recipe.includes(:author, :recipe_ingredients, :steps).find(params[:id])
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
    @recipe = Recipe.find(params[:id])
    if @recipe.parse_original_image(preferred_units: recipe_author.preferred_units)
      RecipeMailer.parse_confirmation(@recipe, recipe_author).deliver_later
      redirect_to recipe_path(@recipe), notice: "Recipe parsed successfully from image."
    else
      redirect_to recipe_path(@recipe), alert: "Could not parse recipe (no image attached?)."
    end
  end

  def update
    @the_recipe = Recipe.find(params[:id])
    if @the_recipe.update(recipe_params)
      redirect_to recipe_path(@the_recipe), notice: "Recipe updated successfully."
    else
      redirect_to recipe_path(@the_recipe), alert: @the_recipe.errors.full_messages.to_sentence
    end
  end

  def destroy
    @the_recipe = Recipe.find(params[:id])
    @the_recipe.destroy
    redirect_to recipes_path, notice: "Recipe deleted successfully."
  end

  private

  def recipe_author
    (respond_to?(:current_user) && current_user) || User.first
  end

  def recipe_params
    p = params.require(:recipe).permit(:title, :source_url)
    p[:author_id] = recipe_author.id
    p
  end
end
