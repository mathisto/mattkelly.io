import { Controller } from "@hotwired/stimulus"

// Handles syntax highlighting with Prism.js
export default class extends Controller {
  connect() {
    // Re-highlight code blocks when content changes
    this.highlight()

    // Listen for Turbo navigation events
    document.addEventListener("turbo:render", this.highlight.bind(this))
  }

  disconnect() {
    // Clean up event listener
    document.removeEventListener("turbo:render", this.highlight.bind(this))
  }

  highlight() {
    // Ensure Prism is available
    if (typeof Prism !== 'undefined') {
      // First, ensure all code blocks have proper language classes
      this.element.querySelectorAll('pre code').forEach((block) => {
        if (!Array.from(block.classList).some(className => className.startsWith('language-'))) {
          block.classList.add('language-plaintext')
        }
      })

      // Then highlight all code blocks
      Prism.highlightAllUnder(this.element)
    } else {
      console.warn('Prism.js is not loaded')
    }
  }
} 