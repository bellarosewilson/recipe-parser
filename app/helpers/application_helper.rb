module ApplicationHelper
  def preferred_unit_options
    [
      ["Metric (g, ml, °C)", "metric"],
      ["Imperial (oz, cups, °F)", "imperial"]
    ]
  end

  def breadcrumb_items
    return [{ label: "Home", path: nil }] if controller_name == "pages" && action_name == "home"

    items = [{ label: "Home", path: root_path }]
    case controller_name
    when "recipes"
      items << { label: "Recipes", path: recipes_path }
      items << { label: @the_recipe.title, path: nil } if action_name == "show" && @the_recipe.present?
      items << { label: "New recipe", path: nil } if action_name == "new"
    when "steps"
      items << { label: "Steps", path: steps_path }
      items << { label: @the_recipe.title.presence || "Recipe", path: nil } if action_name == "show" && @the_recipe.present?
    when "ingredients"
      items << { label: "Ingredients", path: ingredients_path }
      items << { label: "Ingredient ##{@the_ingredient&.id}", path: nil } if action_name == "show" && @the_ingredient.present?
    end
    items
  end
end
