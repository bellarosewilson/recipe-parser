class StepsController < ApplicationController
  def index
    matching_steps = Step.all

    @list_of_steps = matching_steps.order({ :created_at => :desc })

    render({ :template => "step_templates/index" })
  end

  def show
    @the_step = Step.find(params[:id])
    render({ :template => "step_templates/show" })
  end

  def create
    the_step = Step.new(step_params)

    if the_step.save
      redirect_to steps_path, notice: "Step created successfully."
    else
      redirect_to steps_path, alert: the_step.errors.full_messages.to_sentence
    end
  end

  def update
    @the_step = Step.find(params[:id])

    if @the_step.update(step_params)
      redirect_to step_path(@the_step), notice: "Step updated successfully."
    else
      redirect_to step_path(@the_step), alert: @the_step.errors.full_messages.to_sentence
    end
  end

  def destroy
    @the_step = Step.find(params[:id])
    @the_step.destroy
    redirect_to steps_path, notice: "Step deleted successfully."
  end

  private

  def step_params
    params.require(:step).permit(:recipe_id, :position, :instruction)
  end
end
