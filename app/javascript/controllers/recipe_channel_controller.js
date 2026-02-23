import { Controller } from "@hotwired/stimulus"
import * as ActionCable from "@rails/actioncable"

// Subscribes to RecipeChannel and shows a toast when the recipe is updated or re-parsed (event-driven).
export default class extends Controller {
  static values = { recipeId: Number }

  connect() {
    if (!this.recipeIdValue) return
    this.consumer = ActionCable.createConsumer()
    this.subscription = this.consumer.subscriptions.create(
      { channel: "RecipeChannel", id: this.recipeIdValue },
      {
        received: (data) => this.received(data)
      }
    )
  }

  disconnect() {
    if (this.subscription) this.subscription.unsubscribe()
    if (this.consumer) this.consumer.disconnect()
  }

  received(data) {
    const event = data.event
    if (event === "updated" && data.recipe) {
      this.updateDOM(data.recipe)
      this.showToast("Recipe updated.")
    } else if (event === "parsed") {
      this.showToast("Recipe re-parsed from image.")
    }
  }

  updateDOM(recipe) {
    const titleEl = document.getElementById("recipe_title_display")
    const sourceEl = document.getElementById("recipe_source_display")
    if (titleEl && recipe.title) titleEl.textContent = recipe.title
    if (sourceEl) {
      if (recipe.source_url) {
        sourceEl.href = recipe.source_url
        sourceEl.textContent = recipe.source_url
        sourceEl.style.display = ""
      } else {
        sourceEl.style.display = "none"
      }
    }
  }

  showToast(message) {
    const toast = document.createElement("div")
    toast.setAttribute("role", "alert")
    toast.className = "alert alert-info alert-dismissible fade show position-fixed top-0 start-50 translate-middle-x mt-3"
    toast.style.zIndex = "1050"
    toast.innerHTML = `${message}<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>`
    document.body.appendChild(toast)
    setTimeout(() => toast.remove(), 4000)
  }
}
