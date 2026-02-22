module Recipes
  class CreateFromImageService
    Result = Struct.new(:success?, :recipe, :redirect_path, :notice, :alert, keyword_init: true)

    def self.call(uploaded_file:, author:)
      new(uploaded_file: uploaded_file, author: author).call
    end

    def initialize(uploaded_file:, author:)
      @uploaded_file = uploaded_file
      @author = author
    end

    def call
      return failure("/recipes/new", alert: "Please choose an image to upload.") if @uploaded_file.blank?
      return failure("/recipes/new", alert: "No user in the database. Run: rails db:seed") unless @author
      return failure("/recipes/new", alert: "OpenAI API key not set. Run: rails credentials:edit and add openai_api_key:") if openai_key_blank?

      recipe = build_recipe_with_image
      unless recipe&.persisted?
        return failure("/recipes", alert: recipe ? recipe.errors.full_messages.to_sentence : "Failed to save recipe.")
      end

      parsed_data = parse_recipe_image(recipe)
      ok, errors = recipe.apply_parsed_data(parsed_data)

      if ok
        Result.new(success?: true, recipe: recipe, redirect_path: "/recipes/#{recipe.id}", notice: "Recipe created successfully.")
      else
        Result.new(
          success?: true, # recipe exists, we're showing it
          recipe: recipe,
          redirect_path: "/recipes/#{recipe.id}",
          alert: "Recipe saved but parse data could not be applied: #{errors.join(', ')}"
        )
      end
    rescue StandardError => e
      handle_error(e)
    end

    private

    def openai_key_blank?
      Rails.application.credentials.dig(:openai_api_key).blank?
    end

    def build_recipe_with_image
      recipe = Recipe.new
      recipe.author_id = @author.id
      recipe.title = "Processing..."
      recipe.original_image.attach(@uploaded_file)
      recipe.save ? recipe : recipe
    end

    def parse_recipe_image(recipe)
      preferred_units = @author.respond_to?(:preferred_units) ? @author.preferred_units : nil
      parser = OpenAiParser::ParserService.new(recipe.original_image.blob, preferred_units)
      parsed = parser.parse_recipe

      ing_count = parsed[:ingredients]&.size || 0
      steps_count = parsed[:steps]&.size || 0
      Rails.logger.info "[Recipe parse] title=#{parsed[:title].inspect} ingredients=#{ing_count} steps=#{steps_count}"
      Rails.logger.warn "[Recipe parse] No ingredients or steps in parsed data" if ing_count.zero? && steps_count.zero?

      parsed
    end

    def handle_error(e)
      last_recipe = Recipe.order(created_at: :desc).first
      if last_recipe&.title == "Processing..."
        last_recipe.update_column(:title, "Parse failed")
        failure("/recipes/#{last_recipe.id}", alert: "Parse failed: #{e.message}")
      else
        failure("/recipes", alert: "Upload failed: #{e.message}")
      end
    end

    def failure(path, notice: nil, alert: nil)
      Result.new(success?: false, recipe: nil, redirect_path: path, notice: notice, alert: alert)
    end
  end
end
