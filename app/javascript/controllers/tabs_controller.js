import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  connect() {
    console.log("[TabsController] Connected!")
    console.log("[TabsController] Found tabs:", this.tabTargets.length)
    console.log("[TabsController] Found panels:", this.panelTargets.length)
    
    // Get active tab from URL or default to "all"
    const urlParams = new URLSearchParams(window.location.search)
    const activeTab = urlParams.get('tab') || 'all'
    
    console.log("[TabsController] Active tab:", activeTab)
    
    // Show the active tab
    this.showTab(activeTab)
  }

  select(event) {
    event.preventDefault()
    event.stopPropagation()
    
    const tabName = event.currentTarget.dataset.tabName
    console.log("[TabsController] Tab clicked:", tabName)
    
    this.showTab(tabName)
    
    // Update URL without page reload
    const url = new URL(window.location)
    url.searchParams.set('tab', tabName)
    window.history.pushState({}, '', url)
  }

  showTab(tabName) {
    console.log("[TabsController] Showing tab:", tabName)
    
    // Update active tab styles
    this.tabTargets.forEach(tab => {
      const isActive = tab.dataset.tabName === tabName
      console.log("[TabsController] Tab button:", tab.dataset.tabName, "Active:", isActive)
      
      if (isActive) {
        tab.classList.add("active")
        tab.classList.remove("inactive")
      } else {
        tab.classList.remove("active")
        tab.classList.add("inactive")
      }
    })

    // Show/hide panels
    this.panelTargets.forEach(panel => {
      const shouldShow = panel.dataset.tabPanel === tabName
      console.log("[TabsController] Panel:", panel.dataset.tabPanel, "Show:", shouldShow)
      
      if (shouldShow) {
        panel.classList.remove("hidden")
        panel.style.display = ""  // Remove inline style
      } else {
        panel.classList.add("hidden")
        panel.style.display = "none"  // Add inline style as fallback
      }
    })
  }
}
