import { Controller } from "@hotwired/stimulus"

// Handles smooth page transitions
export default class extends Controller {
  static targets = ["content"]

  connect() {
    // Add transition classes when controller connects
    this.contentTarget.classList.add("transition-opacity", "duration-300", "ease-in-out")
    
    // Listen for Turbo events
    document.addEventListener("turbo:before-visit", this.beforeVisit.bind(this))
    document.addEventListener("turbo:before-cache", this.beforeCache.bind(this))
    document.addEventListener("turbo:load", this.afterVisit.bind(this))
  }

  disconnect() {
    // Clean up event listeners
    document.removeEventListener("turbo:before-visit", this.beforeVisit.bind(this))
    document.removeEventListener("turbo:before-cache", this.beforeCache.bind(this))
    document.removeEventListener("turbo:load", this.afterVisit.bind(this))
  }

  beforeVisit() {
    // Fade out content before navigation
    this.contentTarget.style.opacity = "0"
  }

  beforeCache() {
    // Reset opacity before page is cached
    this.contentTarget.style.opacity = "1"
  }

  afterVisit() {
    // Start with content invisible
    if (this.hasContentTarget) {
      this.contentTarget.style.opacity = "0"
      
      // Small delay to ensure DOM is ready
      requestAnimationFrame(() => {
        // Fade in the content
        this.contentTarget.style.opacity = "1"
      })
    }
  }
} 