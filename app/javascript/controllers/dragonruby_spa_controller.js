import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "hamburger", "titleDisplay"]
  
  connect() {
    console.log("[DragonRubySPA] Connected")
    this.sidebarOpen = false
    
    if (window.innerWidth < 768) {
      this.closeSidebar()
    } else {
      this.openSidebar()
    }
    
    this.updateActiveLink()
    this.setupTurboFrameListener()
    this.setupClickOutsideListener()
    this.setupPopStateListener()
  }
  
  disconnect() {
    // Clean up popstate listener
    if (this.popStateHandler) {
      window.removeEventListener('popstate', this.popStateHandler)
    }
  }
  
  setupPopStateListener() {
    // Handle browser back/forward buttons
    this.popStateHandler = (event) => {
      console.log("[DragonRubySPA] Popstate event - back/forward button pressed")
      console.log("[DragonRubySPA] New URL:", window.location.pathname)
      
      // Reload the frame with the new URL
      const frame = document.getElementById('tutorial-content')
      if (frame && window.location.pathname !== '/dragonruby' && window.location.pathname !== '/dragonruby/') {
        frame.src = window.location.pathname
      } else {
        // Back to index - reload the welcome screen
        frame.src = '/dragonruby'
      }
      
      this.updateActiveLink()
      
      // Re-enable buttons after navigation
      setTimeout(() => {
        this.enableButtons()
      }, 100)
    }
    
    window.addEventListener('popstate', this.popStateHandler)
  }
  
  setupTurboFrameListener() {
    this.element.addEventListener('turbo:frame-load', (event) => {
      if (event.target.id === 'tutorial-content') {
        console.log("[DragonRubySPA] Tutorial content loaded via Turbo Frame")
        
        setTimeout(() => {
          this.enableButtons()
        }, 100)
      }
    })
  }
  
  setupClickOutsideListener() {
    document.addEventListener('click', (event) => {
      if (!this.sidebarOpen) return
      
      const clickedSidebar = this.sidebarTarget.contains(event.target)
      const clickedHamburger = this.hamburgerTarget.contains(event.target)
      
      if (!clickedSidebar && !clickedHamburger) {
        console.log("[DragonRubySPA] Click outside sidebar - closing")
        this.closeSidebar()
      }
    })
  }
  
  enableButtons() {
    const runBtn = document.querySelector('.btn-run')
    const resetBtn = document.querySelector('.btn-reset')
    
    if (runBtn) {
      runBtn.disabled = false
      console.log("[DragonRubySPA] Run button enabled")
    }
    if (resetBtn) {
      resetBtn.disabled = false
      console.log("[DragonRubySPA] Reset button enabled")
    }
  }
  
  toggleSidebar() {
    this.sidebarOpen ? this.closeSidebar() : this.openSidebar()
  }
  
  openSidebar() {
    this.sidebarTarget.classList.add("open")
    this.element.classList.add("sidebar-open")
    this.sidebarOpen = true
  }
  
  closeSidebar() {
    this.sidebarTarget.classList.remove("open")
    this.element.classList.remove("sidebar-open")
    this.sidebarOpen = false
  }
  
  loadTutorial(event) {
    event.preventDefault()
    const link = event.currentTarget
    const tutorialTitle = link.dataset.tutorialTitle
    const tutorialUrl = link.href
    
    // Update the URL in browser history
    window.history.pushState({}, '', tutorialUrl)
    
    // Load content via Turbo Frame
    const frame = document.getElementById('tutorial-content')
    if (frame) {
      frame.src = tutorialUrl
    }
    
    if (this.hasTitleDisplayTarget) {
      this.titleDisplayTarget.textContent = tutorialTitle
    }
    
    if (window.innerWidth < 768) {
      this.closeSidebar()
    }
    
    this.updateActiveLink(link)
  }
  
  updateActiveLink(activeLink = null) {
    this.element.querySelectorAll('.tutorial-nav-link').forEach(el => {
      el.classList.remove('active')
    })
    
    if (activeLink) {
      activeLink.classList.add('active')
    } else {
      const currentPath = window.location.pathname
      const matchingLink = this.element.querySelector(`a[href="${currentPath}"]`)
      if (matchingLink) {
        matchingLink.classList.add('active')
        if (this.hasTitleDisplayTarget) {
          this.titleDisplayTarget.textContent = matchingLink.dataset.tutorialTitle
        }
      } else if (currentPath === '/dragonruby' || currentPath === '/dragonruby/') {
        // Back to index - reset title
        if (this.hasTitleDisplayTarget) {
          this.titleDisplayTarget.textContent = 'Select a tutorial to begin'
        }
      }
    }
  }
  
  run(event) {
    event.preventDefault()
    const splitController = this.getSplitController()
    if (splitController) {
      splitController.run()
    } else {
      console.warn("[DragonRubySPA] Split controller not found")
    }
  }
  
  reset(event) {
    event.preventDefault()
    const splitController = this.getSplitController()
    if (splitController) {
      splitController.reset()
    } else {
      console.warn("[DragonRubySPA] Split controller not found")
    }
  }
  
  getSplitController() {
    const splitElement = document.querySelector('[data-controller*="dragonruby-split"]')
    if (splitElement) {
      return this.application.getControllerForElementAndIdentifier(
        splitElement,
        "dragonruby-split"
      )
    }
    return null
  }
  
  toggleDifficulty(event) {
    event.preventDefault()
    const button = event.currentTarget
    const difficulty = button.dataset.difficulty
    const list = this.element.querySelector(`ul[data-list="${difficulty}"]`)
    const icon = button.querySelector('.accordion-icon')
    
    if (!list) return
    
    const isExpanded = button.getAttribute('aria-expanded') === 'true'
    
    if (isExpanded) {
      list.style.maxHeight = '0'
      list.style.opacity = '0'
      button.setAttribute('aria-expanded', 'false')
      icon.style.transform = 'rotate(-90deg)'
    } else {
      list.style.maxHeight = list.scrollHeight + 'px'
      list.style.opacity = '1'
      button.setAttribute('aria-expanded', 'true')
      icon.style.transform = 'rotate(0deg)'
    }
  }
}
