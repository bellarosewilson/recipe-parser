import { Controller } from "@hotwired/stimulus";

// Adds new ingredient or step rows to the recipe edit form by cloning a template
// and replacing the placeholder index in field names/ids.
export default class extends Controller {
  static targets = [
    "ingredientTemplate",
    "ingredientContainer",
    "stepTemplate",
    "stepContainer",
  ];

  addIngredient(event) {
    event.preventDefault();
    if (!this.hasIngredientTemplateTarget || !this.hasIngredientContainerTarget)
      return;
    const index = new Date().getTime();
    const content = this.ingredientTemplateTarget.innerHTML.replace(
      /NEW_INGREDIENT_INDEX/g,
      index,
    );
    this.ingredientContainerTarget.insertAdjacentHTML("beforeend", content);
  }

  addStep(event) {
    event.preventDefault();
    if (!this.hasStepTemplateTarget || !this.hasStepContainerTarget) return;
    const index = new Date().getTime();
    const content = this.stepTemplateTarget.innerHTML.replace(
      /NEW_STEP_INDEX/g,
      index,
    );
    this.stepContainerTarget.insertAdjacentHTML("beforeend", content);
    const rows = this.stepContainerTarget.querySelectorAll(
      "[data-nested-form-target='stepRow']",
    );
    const positionInput = rows[rows.length - 1]?.querySelector(
      "input[name*='[position]']",
    );
    if (positionInput) positionInput.value = rows.length;
  }
}
