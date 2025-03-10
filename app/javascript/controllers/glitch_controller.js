import { Controller } from "@hotwired/stimulus"

// Handles glitch effect interactions
export default class extends Controller {
  connect() {
    // Add random glitch triggers
    this.glitchInterval = setInterval(() => {
      this.triggerGlitch()
    }, 5000)
  }

  disconnect() {
    if (this.glitchInterval) {
      clearInterval(this.glitchInterval)
    }
  }

  triggerGlitch() {
    // Add extra glitch classes temporarily
    this.element.classList.add('extra-glitch')
    
    // Remove after animation
    setTimeout(() => {
      this.element.classList.remove('extra-glitch')
    }, 500)
  }
} 