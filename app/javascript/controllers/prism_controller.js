import { Controller } from "@hotwired/stimulus"

// Handles syntax highlighting with Prism.js
export default class extends Controller {
  connect() {
    // Re-highlight code blocks when content changes
    this.highlight()

    // Listen for Turbo navigation events
    document.addEventListener("turbo:render", () => this.highlight())
  }

  disconnect() {
    // Clean up event listener
    document.removeEventListener("turbo:render", () => this.highlight())
  }

  highlight() {
    // Ensure Prism is available
    if (typeof Prism !== 'undefined') {
      // Highlight all code blocks in the controller's element
      this.element.querySelectorAll('pre code').forEach((block) => {
        // Add the language class if not present
        if (!block.classList.contains('language-')) {
          const languageClass = Array.from(block.classList)
            .find(className => className.startsWith('language-'))
          
          if (!languageClass) {
            block.classList.add('language-plaintext')
          }
        }
        
        // Highlight the block
        Prism.highlightElement(block)
      })
    }
  }
} 