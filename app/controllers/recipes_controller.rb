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
    uploaded_file = params[:recipe_file]

    # Create recipe with image
    the_recipe = Recipe.new
    the_recipe.author_id = current_user.id
    the_recipe.title = "Processing..."
    the_recipe.original_image.attach(uploaded_file)

    if the_recipe.save
      # Get URL for OpenAI
      image_url = url_for(the_recipe.original_image)

      # Parse with OpenAI
      parser = OpenaiParserService.new(image_url, current_user.preferred_units)
      parsed_data = parser.parse_recipe

      # Update with parsed data
      the_recipe.update(
        title: parsed_data[:title],
        recipe_ingredients_attributes: parsed_data[:ingredients],
        steps_attributes: parsed_data[:steps],
      )

      redirect_to("/recipes/#{the_recipe.id}", { :notice => "Recipe created successfully." })
    else
      redirect_to("/recipes", { :alert => the_recipe.errors.full_messages.to_sentence })
    end
  rescue StandardError => e
    redirect_to("/recipes", { :alert => "Upload failed: #{e.message}" })
  end

  def update
    the_id = params.fetch("path_id")
    the_recipe = Recipe.where({ :id => the_id }).at(0)

    the_recipe.title = params.fetch("query_title")
    the_recipe.author_id = params.fetch("query_author_id")
    the_recipe.source_url = params.fetch("query_source_url")

    if the_recipe.valid?
      the_recipe.save
      redirect_to("/recipes/#{the_recipe.id}", { :notice => "Recipe updated successfully." })
    else
      redirect_to("/recipes/#{the_recipe.id}", { :alert => the_recipe.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_recipe = Recipe.where({ :id => the_id }).at(0)

    the_recipe.destroy

    redirect_to("/recipes", { :notice => "Recipe deleted successfully." })
  end

  def new
    render({ :template => "recipe_templates/new" })
  end
end
