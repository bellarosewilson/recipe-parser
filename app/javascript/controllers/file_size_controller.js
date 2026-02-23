import { Controller } from "@hotwired/stimulus"

// Optional client-side validation: warn when file exceeds max size (default 10MB)
export default class extends Controller {
  static values = { maxMb: { type: Number, default: 10 } }
  static targets = ["input", "message", "submit"]

  connect() {
    this.inputTarget.addEventListener("change", this.validate.bind(this))
  }

  validate() {
    const file = this.inputTarget?.files?.[0]
    const messageEl = this.hasMessageTarget ? this.messageTarget : null
    const submitEl = this.hasSubmitTarget ? this.submitTarget : null
    const maxBytes = this.maxMbValue * 1024 * 1024

    if (messageEl) {
      messageEl.textContent = ""
      messageEl.classList.add("d-none")
    }
    if (submitEl) submitEl.disabled = false

    if (!file) return

    if (file.size > maxBytes) {
      const msg = `File is too large (max ${this.maxMbValue}MB).`
      if (messageEl) {
        messageEl.textContent = msg
        messageEl.classList.remove("d-none")
      }
      if (submitEl) submitEl.disabled = true
    }
  }
}
