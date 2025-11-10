import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="auto-dismiss"
export default class extends Controller {
  static values = {
    delay: { type: Number, default: 3000 }
  }

  connect() {
    console.log("[AutoDismiss] Controller connected with delay:", this.delayValue)
    this.timeout = setTimeout(() => {
      this.dismiss()
    }, this.delayValue)
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }

  dismiss() {
    console.log("[AutoDismiss] Dismissing element")
    this.element.style.transition = "opacity 0.3s ease-out, transform 0.3s ease-out"
    this.element.style.opacity = "0"
    this.element.style.transform = "translateY(-10px)"
    
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}
