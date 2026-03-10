class IngredientsController < ApplicationController
  def index
    @list_of_ingredients = policy_scope(Ingredient).order(created_at: :desc)
    render({ :template => "ingredient_templates/index" })
  end

  def show
    @the_ingredient = Ingredient.find(params[:id])
    authorize @the_ingredient
    render({ :template => "ingredient_templates/show" })
  end

  def create
    recipe_id = recipe_id_for_ingredient
    return redirect_to ingredients_path, alert: "Recipe is required." if recipe_id.blank?
    recipe = Recipe.find(recipe_id)
    authorize recipe, :update?
    the_ingredient = Ingredient.new(ingredient_params)
    the_ingredient.recipe_id = recipe.id

    if the_ingredient.save
      redirect_to ingredients_path, notice: "Ingredient created successfully."
    else
      redirect_to ingredients_path, alert: the_ingredient.errors.full_messages.to_sentence
    end
  end

  def update
    @the_ingredient = Ingredient.find(params[:id])
    authorize @the_ingredient
    if @the_ingredient.update(ingredient_params)
      redirect_to ingredient_path(@the_ingredient), notice: "Ingredient updated successfully."
    else
      redirect_to ingredient_path(@the_ingredient), alert: @the_ingredient.errors.full_messages.to_sentence
    end
  end

  def destroy
    @the_ingredient = Ingredient.find(params[:id])
    authorize @the_ingredient
    @the_ingredient.destroy
    redirect_to ingredients_path, notice: "Ingredient deleted successfully."
  end

  private

  def recipe_id_for_ingredient
    params[:ingredient]&.dig(:recipe_id) || params[:recipe_id]
  end

  def ingredient_params
    params.require(:ingredient).permit(:unit, :amount, :name)
  end
end
