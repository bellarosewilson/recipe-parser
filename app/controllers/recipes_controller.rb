class RecipesController < ApplicationController
  def index
    matching_recipes = Recipe.all

    @list_of_recipes = matching_recipes.order({ :created_at => :desc })

    render({ :template => "recipe_templates/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_recipes = Recipe.where({ :id => the_id })

    @the_recipe = matching_recipes.at(0)

    render({ :template => "recipe_templates/show" })
  end

  def create
    the_recipe = Recipe.new
    the_recipe.title = params.fetch("query_title")
    the_recipe.author_id = params.fetch("query_author_id")
    the_recipe.source_url = params.fetch("query_source_url")

    if the_recipe.valid?
      the_recipe.save
      redirect_to("/recipes", { :notice => "Recipe created successfully." })
    else
      redirect_to("/recipes", { :alert => the_recipe.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_recipe = Recipe.where({ :id => the_id }).at(0)

    the_recipe.title = params.fetch("query_title")
    the_recipe.author_id = params.fetch("query_author_id")
    the_recipe.source_url = params.fetch("query_source_url")

    if the_recipe.valid?
      the_recipe.save
      redirect_to("/recipes/#{the_recipe.id}", { :notice => "Recipe updated successfully." } )
    else
      redirect_to("/recipes/#{the_recipe.id}", { :alert => the_recipe.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_recipe = Recipe.where({ :id => the_id }).at(0)

    the_recipe.destroy

    redirect_to("/recipes", { :notice => "Recipe deleted successfully." } )
  end
end
