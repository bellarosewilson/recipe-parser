class RecipesController < ApplicationController
  def recipe_author
    current_user || User.first
  end

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
    if uploaded_file.blank?
      redirect_to("/recipes/new", { alert: "Please choose an image to upload." })
      return
    end

    author = recipe_author
    unless author
      redirect_to("/recipes/new", { alert: "No user in the database. Run: rails db:seed" })
      return
    end

    # Fail fast if OpenAI key is missing (credentials)
    if Rails.application.credentials.dig(:openai_api_key).blank?
      redirect_to("/recipes/new", { alert: "OpenAI API key not set. Run: rails credentials:edit and add openai_api_key:" })
      return
    end

    # Create recipe with image
    the_recipe = Recipe.new
    the_recipe.author_id = author.id
    the_recipe.title = "Processing..."
    the_recipe.original_image.attach(uploaded_file)

    if the_recipe.save
      # Parse recipe from image with OpenAI vision (pass blob so it works without a public URL)
      preferred_units = author.respond_to?(:preferred_units) ? author.preferred_units : nil
      parser = OpenAiParser::ParserService.new(
        the_recipe.original_image.blob,
        preferred_units
      )
      parsed_data = parser.parse_recipe

      # Update with parsed data; surface errors if nested save fails
      ok = the_recipe.update(
        title: parsed_data[:title],
        recipe_ingredients_attributes: parsed_data[:ingredients],
        steps_attributes: parsed_data[:steps],
      )
      if ok
        redirect_to("/recipes/#{the_recipe.id}", { :notice => "Recipe created successfully." })
      else
        errors = the_recipe.errors.full_messages
        the_recipe.recipe_ingredients.each { |i| errors.concat(i.errors.full_messages) }
        the_recipe.steps.each { |s| errors.concat(s.errors.full_messages) }
        redirect_to("/recipes/#{the_recipe.id}", { :alert => "Recipe saved but parse data could not be applied: #{errors.uniq.join(", ")}" })
      end
    else
      redirect_to("/recipes", { :alert => the_recipe.errors.full_messages.to_sentence })
    end
  rescue StandardError => e
    # Recipe may already be saved with "Processing..."; show error on its page so user sees which recipe failed
    last_recipe = Recipe.order(created_at: :desc).first
    if last_recipe && last_recipe.title == "Processing..."
      last_recipe.update_column(:title, "Parse failed")
      redirect_to("/recipes/#{last_recipe.id}", { :alert => "Parse failed: #{e.message}" })
    else
      redirect_to("/recipes", { :alert => "Upload failed: #{e.message}" })
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
