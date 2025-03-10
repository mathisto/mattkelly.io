import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["code", "copyButton"]

  connect() {
    // Initialize Prism.js highlighting when the component connects
    if (typeof Prism !== 'undefined') {
      Prism.highlightAll()
    }
  }

  async copy() {
    const code = this.codeTarget.textContent
    const button = this.copyButtonTarget
    const copyIcon = button.querySelector('.copy-icon')
    const checkIcon = button.querySelector('.check-icon')

    try {
      await navigator.clipboard.writeText(code)
      
      // Show success state
      copyIcon.classList.add('hidden')
      checkIcon.classList.remove('hidden')
      
      // Reset after 2 seconds
      setTimeout(() => {
        copyIcon.classList.remove('hidden')
        checkIcon.classList.add('hidden')
      }, 2000)
    } catch (err) {
      console.error('Failed to copy code:', err)
      // Could add error feedback here if needed
    }
  }
} 