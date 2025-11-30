import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"

// Connects to data-controller="ingestions-table"
export default class extends Controller {
  static targets = ["row"]

  connect() {
    console.log("[IngestionsTable] Controller connected")
    console.log("[IngestionsTable] Consumer:", consumer)
    
    this.subscription = consumer.subscriptions.create(
      { channel: "Scribe::IngestionsChannel" },
      {
        connected: this.cableConnected.bind(this),
        disconnected: this.cableDisconnected.bind(this),
        received: this.cableReceived.bind(this)
      }
    )
    
    console.log("[IngestionsTable] Subscription created:", this.subscription)
  }

  disconnect() {
    console.log("[IngestionsTable] Controller disconnected")
    if (this.subscription) {
      this.subscription.unsubscribe()
    }
  }

  cableConnected() {
    console.log("[IngestionsTable] Cable connected to Scribe::IngestionsChannel")
  }

  cableDisconnected() {
    console.log("[IngestionsTable] Cable disconnected from Scribe::IngestionsChannel")
  }

  cableReceived(data) {
    console.log("[IngestionsTable] Received data:", data)
    
    if (data.action === "created") {
      this.insertNewRow(data.html)
    } else if (data.action === "updated") {
      this.updateExistingRow(data.id, data.html)
    }
  }

  insertNewRow(html) {
    console.log("[IngestionsTable] Inserting new row")
    const tbody = this.element.querySelector("#ingestions-body")
    
    // Check if we have an empty state row
    const emptyState = tbody.querySelector("td[colspan]")
    if (emptyState) {
      tbody.innerHTML = ""
    }

    // Create temporary container to parse HTML
    const temp = document.createElement("div")
    temp.innerHTML = html
    const newRow = temp.firstElementChild

    // Add fade-in animation class
    newRow.style.opacity = "0"
    newRow.style.transform = "translateY(-10px)"
    newRow.style.transition = "opacity 0.5s ease-out, transform 0.5s ease-out"

    // Insert at the top
    tbody.insertBefore(newRow, tbody.firstChild)

    // Trigger animation on next frame
    requestAnimationFrame(() => {
      newRow.style.opacity = "1"
      newRow.style.transform = "translateY(0)"
    })
  }

  updateExistingRow(ingestionId, html) {
    console.log("[IngestionsTable] Updating row", ingestionId)
    const existingRow = this.element.querySelector(`#ingestion_${ingestionId}`)
    
    if (existingRow) {
      // Create temporary container to parse HTML
      const temp = document.createElement("div")
      temp.innerHTML = html
      const newRow = temp.firstElementChild

      // Preserve transition styles
      newRow.style.transition = "background-color 0.3s ease"
      
      // Replace the row
      existingRow.replaceWith(newRow)

      // Flash effect
      newRow.style.backgroundColor = "rgba(122, 162, 247, 0.2)"
      setTimeout(() => {
        newRow.style.backgroundColor = ""
      }, 1000)
    } else {
      // If row doesn't exist, insert it
      this.insertNewRow(html)
    }
  }
}
