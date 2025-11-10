import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="utterance-form"
export default class extends Controller {
  static targets = ["form", "textarea", "charCounter", "charCount"]
  static values = {
    maxLength: { type: Number, default: 500 }
  }

  connect() {
    console.log("[UtteranceForm] Controller connected")
    this.updateCharacterCount()
  }

  submitWithCtrlEnter(event) {
    // Check if Ctrl+Enter or Cmd+Enter was pressed
    if ((event.ctrlKey || event.metaKey) && event.key === "Enter") {
      event.preventDefault()
      console.log("[UtteranceForm] Ctrl+Enter detected, submitting form")
      if (this.isValid()) {
        this.formTarget.requestSubmit()
      }
    }
  }

  isValid() {
    const value = this.textareaTarget.value.trim()
    return value.length > 0 && value.length <= this.maxLengthValue
  }

  handleSubmitStart(event) {
    console.log("[UtteranceForm] Form submission started")
    this.formTarget.dataset.submitting = "true"
    this.textareaTarget.disabled = true
  }

  handleSubmitEnd(event) {
    console.log("[UtteranceForm] Form submission ended")
    this.formTarget.dataset.submitting = "false"
    this.textareaTarget.disabled = false

    // Clear textarea on successful submission
    if (event.detail.success !== false) {
      this.textareaTarget.value = ""
      this.updateCharacterCount()
      this.textareaTarget.focus()
    }
  }

  updateCharacterCount() {
    if (!this.hasCharCountTarget) return

    const length = this.textareaTarget.value.length
    const remaining = this.maxLengthValue - length

    this.charCountTarget.textContent = length

    // Update visual state based on character count
    if (remaining < 50 && remaining > 0) {
      this.charCounterTarget.dataset.warning = "true"
      this.charCounterTarget.dataset.error = "false"
    } else if (remaining <= 0) {
      this.charCounterTarget.dataset.warning = "false"
      this.charCounterTarget.dataset.error = "true"
    } else {
      this.charCounterTarget.dataset.warning = "false"
      this.charCounterTarget.dataset.error = "false"
    }
  }
}
