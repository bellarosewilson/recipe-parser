class StepsController < ApplicationController
  def index
    matching_steps = Step.all

    @list_of_steps = matching_steps.order({ :created_at => :desc })

    render({ :template => "step_templates/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_steps = Step.where({ :id => the_id })

    @the_step = matching_steps.at(0)

    render({ :template => "step_templates/show" })
  end

  def create
    the_step = Step.new
    the_step.recipe_id = params.fetch("query_recipe_id")
    the_step.position = params.fetch("query_position")
    the_step.instruction = params.fetch("query_instruction")

    if the_step.valid?
      the_step.save
      redirect_to("/steps", { :notice => "Step created successfully." })
    else
      redirect_to("/steps", { :alert => the_step.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_step = Step.where({ :id => the_id }).at(0)

    the_step.recipe_id = params.fetch("query_recipe_id")
    the_step.position = params.fetch("query_position")
    the_step.instruction = params.fetch("query_instruction")

    if the_step.valid?
      the_step.save
      redirect_to("/steps/#{the_step.id}", { :notice => "Step updated successfully." } )
    else
      redirect_to("/steps/#{the_step.id}", { :alert => the_step.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_step = Step.where({ :id => the_id }).at(0)

    the_step.destroy

    redirect_to("/steps", { :notice => "Step deleted successfully." } )
  end
end
