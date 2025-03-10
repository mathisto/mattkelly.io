import { Controller } from "@hotwired/stimulus"

// Handles entrance animations for elements
export default class extends Controller {
  static values = {
    delay: { type: Number, default: 0 }
  }

  connect() {
    // Start invisible and below
    this.element.style.opacity = "0"
    this.element.style.transform = "translateY(40px)"
    
    // Add transition classes
    this.element.classList.add("transition-all", "duration-700", "ease-out")
    
    // Trigger entrance animation after specified delay
    setTimeout(() => {
      requestAnimationFrame(() => {
        this.element.style.opacity = "1"
        this.element.style.transform = "translateY(0)"
      })
    }, this.delayValue)
  }

  disconnect() {
    // Clean up styles when element is removed
    this.element.style.opacity = ""
    this.element.style.transform = ""
  }
} 