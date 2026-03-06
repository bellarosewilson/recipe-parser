import { Controller } from "@hotwired/stimulus"

// Closes a Bootstrap collapse when the action is triggered (e.g. a "Close" button inside the panel).
// Use when the toggle is inside the collapsible content and data-bs-toggle doesn't work reliably.
export default class extends Controller {
  static targets = ["collapse"]

  close(event) {
    event?.preventDefault()
    const el = this.collapseTarget
    if (!el) return
    const collapse = window.bootstrap?.Collapse?.getOrCreateInstance(el)
    if (collapse) collapse.hide()
  }
}
