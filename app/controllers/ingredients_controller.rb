class IngredientsController < ApplicationController
  def index
    matching_ingredients = Ingredient.all

    @list_of_ingredients = matching_ingredients.order({ :created_at => :desc })

    render({ :template => "ingredient_templates/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_ingredients = Ingredient.where({ :id => the_id })

    @the_ingredient = matching_ingredients.at(0)

    render({ :template => "ingredient_templates/show" })
  end

  def create
    the_ingredient = Ingredient.new
    the_ingredient.recipe_id = params.fetch("query_recipe_id")
    the_ingredient.unit = params.fetch("query_unit")
    the_ingredient.amount = params.fetch("query_amount")
    the_ingredient.name = params.fetch("query_name")

    if the_ingredient.valid?
      the_ingredient.save
      redirect_to("/ingredients", { :notice => "Ingredient created successfully." })
    else
      redirect_to("/ingredients", { :alert => the_ingredient.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_ingredient = Ingredient.where({ :id => the_id }).at(0)

    the_ingredient.recipe_id = params.fetch("query_recipe_id")
    the_ingredient.unit = params.fetch("query_unit")
    the_ingredient.amount = params.fetch("query_amount")
    the_ingredient.name = params.fetch("query_name")

    if the_ingredient.valid?
      the_ingredient.save
      redirect_to("/ingredients/#{the_ingredient.id}", { :notice => "Ingredient updated successfully." } )
    else
      redirect_to("/ingredients/#{the_ingredient.id}", { :alert => the_ingredient.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_ingredient = Ingredient.where({ :id => the_id }).at(0)

    the_ingredient.destroy

    redirect_to("/ingredients", { :notice => "Ingredient deleted successfully." } )
  end
end
