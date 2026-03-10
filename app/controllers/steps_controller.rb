class StepsController < ApplicationController
  def index
    @list_of_steps = policy_scope(Step).order(created_at: :desc)
    render({ :template => "step_templates/index" })
  end

  def show
    @the_step = Step.find(params[:id])
    authorize @the_step
    render({ :template => "step_templates/show" })
  end

  def create
    recipe_id = recipe_id_for_step
    return redirect_to steps_path, alert: "Recipe is required." if recipe_id.blank?
    recipe = Recipe.find(recipe_id)
    authorize recipe, :update?
    the_step = Step.new(step_params)
    the_step.recipe_id = recipe.id

    if the_step.save
      redirect_to steps_path, notice: "Step created successfully."
    else
      redirect_to steps_path, alert: the_step.errors.full_messages.to_sentence
    end
  end

  def update
    @the_step = Step.find(params[:id])
    authorize @the_step
    if @the_step.update(step_params)
      redirect_to step_path(@the_step), notice: "Step updated successfully."
    else
      redirect_to step_path(@the_step), alert: @the_step.errors.full_messages.to_sentence
    end
  end

  def destroy
    @the_step = Step.find(params[:id])
    authorize @the_step
    @the_step.destroy
    redirect_to steps_path, notice: "Step deleted successfully."
  end

  private

  def recipe_id_for_step
    params[:step]&.dig(:recipe_id) || params[:recipe_id]
  end

  def step_params
    params.require(:step).permit(:position, :instruction)
  end
end
