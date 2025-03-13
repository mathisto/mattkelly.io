import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["heatmap"]
  static values = {
    data: Array,
    total: Number
  }

  connect() {
    if (this.hasDataValue && this.hasTotalValue) {
      this.renderHeatmap()
    }
  }

  renderHeatmap() {
    const data = this.dataValue
    const total = this.totalValue
    const container = this.heatmapTarget
    container.innerHTML = '' // Clear existing content
    container.className = 'github-heatmap-container'

    // Create the heatmap grid
    const grid = document.createElement('div')
    grid.className = 'github-heatmap-grid'

    // Group contributions by week
    const weeks = []
    let currentWeek = []
    
    data.forEach((day, index) => {
      currentWeek.push(day)
      if (currentWeek.length === 7 || index === data.length - 1) {
        weeks.push([...currentWeek])
        currentWeek = []
      }
    })

    // Create week columns
    weeks.forEach(week => {
      const weekEl = document.createElement('div')
      weekEl.className = 'github-heatmap-week'

      week.forEach(day => {
        const dayEl = document.createElement('div')
        dayEl.className = 'github-heatmap-day'
        dayEl.setAttribute('data-count', day.count)
        dayEl.setAttribute('data-date', day.date)
        dayEl.style.backgroundColor = day.color
        
        // Add tooltip
        dayEl.title = `${day.count} contributions on ${new Date(day.date).toLocaleDateString()}`
        
        weekEl.appendChild(dayEl)
      })

      grid.appendChild(weekEl)
    })

    // Add total contributions
    const totalEl = document.createElement('div')
    totalEl.className = 'github-heatmap-total'
    totalEl.textContent = `${total} contributions in the last year`

    container.appendChild(grid)
    container.appendChild(totalEl)
  }
} 