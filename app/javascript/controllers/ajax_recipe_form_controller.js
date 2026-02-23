import { Controller } from "@hotwired/stimulus"

// Submits the recipe edit form via fetch (AJAX) and updates the DOM with the response (AJAX CRUD).
export default class extends Controller {
  static targets = ["title", "sourceUrl", "sourceRow", "submit", "message"]

  connect() {
    this.element.addEventListener("submit", this.submit.bind(this))
  }

  async submit(e) {
    e.preventDefault()
    const form = this.element
    const url = form.action
    const formData = new FormData(form)
    const body = new URLSearchParams({
      "recipe[title]": formData.get("recipe[title]") || "",
      "recipe[source_url]": formData.get("recipe[source_url]") || "",
      authenticity_token: formData.get("authenticity_token") || ""
    })

    if (this.hasSubmitTarget) this.submitTarget.disabled = true
    if (this.hasMessageTarget) this.messageTarget.textContent = ""

    try {
      const res = await fetch(url, {
        method: "PATCH",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "X-CSRF-Token": formData.get("authenticity_token") || ""
        },
        body: body.toString()
      })
      const data = await res.json()

      if (res.ok && data.recipe) {
        this.updateDOM(data.recipe)
        if (this.hasMessageTarget) {
          this.messageTarget.textContent = "Saved."
          this.messageTarget.className = "small text-success"
        }
      } else {
        const msg = (data.errors && data.errors.join(", ")) || "Update failed."
        if (this.hasMessageTarget) {
          this.messageTarget.textContent = msg
          this.messageTarget.className = "small text-danger"
        }
      }
    } catch (err) {
      if (this.hasMessageTarget) {
        this.messageTarget.textContent = "Network error."
        this.messageTarget.className = "small text-danger"
      }
    } finally {
      if (this.hasSubmitTarget) this.submitTarget.disabled = false
    }
  }

  updateDOM(recipe) {
    const titleDisplay = document.getElementById("recipe_title_display")
    const titleInput = document.getElementById("title_box")
    const sourceDisplay = document.getElementById("recipe_source_display")
    const sourceDt = document.getElementById("recipe_source_dt")
    const sourceDd = document.getElementById("recipe_source_dd")
    const sourceInput = document.getElementById("source_url_box")

    if (titleDisplay && recipe.title != null) titleDisplay.textContent = recipe.title
    if (titleInput && recipe.title != null) titleInput.value = recipe.title
    const hasSource = !!(recipe.source_url && recipe.source_url.length > 0)
    if (sourceDisplay) {
      if (hasSource) {
        sourceDisplay.href = recipe.source_url
        sourceDisplay.textContent = recipe.source_url
        sourceDisplay.style.display = ""
      } else {
        sourceDisplay.textContent = ""
        sourceDisplay.style.display = "none"
      }
    }
    if (sourceDt) sourceDt.style.display = hasSource ? "" : "none"
    if (sourceDd) sourceDd.style.display = hasSource ? "" : "none"
    if (sourceInput && recipe.source_url != null) sourceInput.value = recipe.source_url || ""
  }
}
