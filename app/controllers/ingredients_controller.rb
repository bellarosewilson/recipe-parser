class IngredientsController < ApplicationController
  def index
    matching_ingredients = Ingredient.all

    @list_of_ingredients = matching_ingredients.order({ :created_at => :desc })

    render({ :template => "ingredient_templates/index" })
  end

  def show
    @the_ingredient = Ingredient.find(params[:id])
    render({ :template => "ingredient_templates/show" })
  end

  def create
    the_ingredient = Ingredient.new(ingredient_params)

    if the_ingredient.save
      redirect_to ingredients_path, notice: "Ingredient created successfully."
    else
      redirect_to ingredients_path, alert: the_ingredient.errors.full_messages.to_sentence
    end
  end

  def update
    @the_ingredient = Ingredient.find(params[:id])

    if @the_ingredient.update(ingredient_params)
      redirect_to ingredient_path(@the_ingredient), notice: "Ingredient updated successfully."
    else
      redirect_to ingredient_path(@the_ingredient), alert: @the_ingredient.errors.full_messages.to_sentence
    end
  end

  def destroy
    @the_ingredient = Ingredient.find(params[:id])
    @the_ingredient.destroy
    redirect_to ingredients_path, notice: "Ingredient deleted successfully."
  end

  private

  def ingredient_params
    params.require(:ingredient).permit(:recipe_id, :unit, :amount, :name)
  end
end
