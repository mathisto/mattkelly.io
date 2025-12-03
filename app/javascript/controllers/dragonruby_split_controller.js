import { Controller } from "@hotwired/stimulus"
import { EditorView, keymap } from "@codemirror/view"
import { EditorState } from "@codemirror/state"
import { defaultKeymap } from "@codemirror/commands"
import { StreamLanguage, syntaxHighlighting } from "@codemirror/language"
import { ruby } from "@codemirror/legacy-modes/mode/ruby"
import { tokyoNightHighlight, tokyoNightTheme } from "lib/codemirror_tokyo_night"

export default class extends Controller {
  static targets = ["editor", "canvas", "resizeHandle"]

  connect() {
    console.log("[DragonRubySplit] Connected - CodeMirror 6 with Ruby syntax")
    this.dragonRubyModule = null
    this.initializeEditor()
    this.setupResizeHandle()
    
    // Preload DragonRuby immediately so it's ready when user clicks Run
    console.log("[DragonRubySplit] Preloading DragonRuby engine...")
    this.loadDragonRuby()
  }

  disconnect() {
    console.log("[DragonRubySplit] Disconnecting - cleaning up resources")
    
    if (this.gameIframe) {
      console.log("[DragonRubySplit] Removing DragonRuby iframe")
      this.gameIframe.remove()
      this.gameIframe = null
    }
    
    if (this.editor) {
      console.log("[DragonRubySplit] Destroying CodeMirror editor")
      this.editor.destroy()
      this.editor = null
    }
    
    this.gtkReady = false
  }

  initializeEditor() {
    console.log("[DragonRubySplit] Initializing CodeMirror 6")
    
    const starterCode = this.editorTarget.dataset.starterCode || this.defaultCode()

    // Create the editor with extracted Tokyo Night theme
    this.editor = new EditorView({
      state: EditorState.create({
        doc: starterCode,
        extensions: [
          StreamLanguage.define(ruby),
          syntaxHighlighting(tokyoNightHighlight),
          tokyoNightTheme,
          keymap.of([
            ...defaultKeymap,
            {
              key: "Mod-Enter",
              run: () => {
                this.run()
                return true
              }
            }
          ]),
          EditorView.lineWrapping
        ]
      }),
      parent: this.editorTarget
    })
    
    console.log("[DragonRubySplit] CodeMirror 6 initialized with Ruby syntax")
  }

  loadDragonRuby() {
    console.log("[DragonRubySplit] Preloading DragonRuby engine (invisible iframe)...")
    
    // Create iframe for DragonRuby (matches fiddle.dragonruby.org architecture)
    const iframe = document.createElement('iframe')
    iframe.src = `/dragonruby/game.html?v=${Date.now()}`
    iframe.style.width = '100%'
    iframe.style.height = '100%'
    iframe.style.border = 'none'
    iframe.style.visibility = 'hidden' // Hidden but preloading in background
    iframe.id = 'dragonruby-game-iframe'
    
    iframe.onload = () => {
      console.log("[DragonRubySplit] ✓ DragonRuby iframe loaded, engine initializing in background...")
      console.log("[DragonRubySplit] Iframe dimensions:", {
        width: iframe.offsetWidth,
        height: iframe.offsetHeight,
        clientWidth: iframe.clientWidth,
        clientHeight: iframe.clientHeight
      })
      this.dragonRubyFrame = iframe
      this.waitForGTK()
    }
    
    iframe.onerror = (error) => {
      console.error("[DragonRubySplit] ✗ DragonRuby game.html failed to load:", error)
      this.dragonRubyFrame = null
    }
    
    // Append immediately so it starts loading in background
    this.canvasTarget.appendChild(iframe)
    this.gameIframe = iframe
    console.log("[DragonRubySplit] Iframe preloading started (hidden)")
  }

  waitForGTK() {
    // Wait for window.gtk.saveMain to be available in iframe
    let attempts = 0
    const maxAttempts = 100 // 10 seconds max
    
    const checkGTK = () => {
      attempts++
      try {
        // Debug logging
        if (attempts === 1) {
          console.log("[DragonRubySplit] Checking for GTK...", {
            hasIframe: !!this.gameIframe,
            hasContentWindow: !!(this.gameIframe && this.gameIframe.contentWindow),
            hasGtk: !!(this.gameIframe && this.gameIframe.contentWindow && this.gameIframe.contentWindow.gtk),
            hasSaveMain: !!(this.gameIframe && this.gameIframe.contentWindow && this.gameIframe.contentWindow.gtk && this.gameIframe.contentWindow.gtk.saveMain)
          })
        }
        
        if (this.gameIframe && this.gameIframe.contentWindow && 
            this.gameIframe.contentWindow.gtk && 
            typeof this.gameIframe.contentWindow.gtk.saveMain === 'function') {
          console.log("[DragonRubySplit] ✓ DragonRuby GTK ready!")
          console.log("[DragonRubySplit] ✓ Engine preloaded - ready for instant execution")
          this.gtkReady = true
          
          // Update placeholder to show ready state
          const placeholder = this.canvasTarget.querySelector('.canvas-placeholder')
          if (placeholder) {
            placeholder.innerHTML = '✓ Engine Ready - Click "Run" to execute your code'
            placeholder.style.color = '#9ece6a' // Green success color
          }
          
          return
        }
        
        if (attempts >= maxAttempts) {
          console.error("[DragonRubySplit] GTK failed to load after 10 seconds")
          console.log("[DragonRubySplit] Check browser console for iframe errors")
          console.log("[DragonRubySplit] Possible SharedArrayBuffer issue - try refreshing the page")
          return
        }
        
        if (attempts === 1 || attempts % 10 === 0) {
          console.log(`[DragonRubySplit] Waiting for GTK... (${attempts}/100)`)
        }
        
        setTimeout(checkGTK, 100)
      } catch (error) {
        console.log("[DragonRubySplit] Error checking GTK:", error.message)
        if (attempts < maxAttempts) {
          setTimeout(checkGTK, 100)
        }
      }
    }
    checkGTK()
  }

  setupResizeHandle() {
    if (!this.hasResizeHandleTarget) return

    let isResizing = false
    let startX = 0
    let startWidth = 0

    this.resizeHandleTarget.addEventListener('mousedown', (e) => {
      isResizing = true
      startX = e.clientX
      
      const leftPane = this.element.querySelector('.left-pane')
      startWidth = leftPane.offsetWidth
      
      document.body.style.cursor = 'col-resize'
      e.preventDefault()
    })

    document.addEventListener('mousemove', (e) => {
      if (!isResizing) return

      const deltaX = e.clientX - startX
      const containerWidth = this.element.offsetWidth
      const newWidth = startWidth + deltaX
      const percentage = (newWidth / containerWidth) * 100

      if (percentage > 20 && percentage < 80) {
        const leftPane = this.element.querySelector('.left-pane')
        leftPane.style.flex = `0 0 ${percentage}%`
      }
    })

    document.addEventListener('mouseup', () => {
      if (isResizing) {
        isResizing = false
        document.body.style.cursor = ''
      }
    })
  }

  async run() {
    console.log("[DragonRubySplit] ===== RUN BUTTON CLICKED =====")
    
    const code = this.editor ? this.editor.state.doc.toString() : this.editorTarget.textContent
    console.log("[DragonRubySplit] Code length:", code.length, "chars")
    console.log("[DragonRubySplit] GTK ready:", this.gtkReady)
    console.log("[DragonRubySplit] Iframe exists:", !!this.gameIframe)
    
    if (this.gameIframe && this.gtkReady) {
      try {
        console.log("[DragonRubySplit] ✓ Executing code with DragonRuby GTK...")
        
        // Show iframe and hide placeholder
        this.gameIframe.style.visibility = 'visible'
        console.log("[DragonRubySplit] Iframe now visible")
        
        const placeholder = this.canvasTarget.querySelector('.canvas-placeholder')
        if (placeholder) {
          placeholder.style.display = 'none'
          console.log("[DragonRubySplit] Placeholder hidden")
        }
        
        // Extract only the code (remove comments for clean execution)
        const executableCode = this.extractExecutableCode(code)
        console.log("[DragonRubySplit] Executable code:")
        console.log(executableCode)
        
        // Use DragonRuby's saveMain API (writes to app/main.rb and restarts)
        console.log("[DragonRubySplit] Calling iframe.contentWindow.gtk.saveMain...")
        this.gameIframe.contentWindow.gtk.saveMain(executableCode)
        
        console.log("[DragonRubySplit] ✓ Code sent to DragonRuby GTK!")
        console.log("[DragonRubySplit] Check iframe console for DragonRuby logs")
      } catch (error) {
        console.error("[DragonRubySplit] ✗ Execution error:", error)
        console.error(error.stack)
        this.showError(error.message)
      }
    } else if (this.gameIframe && !this.gtkReady) {
      console.log("[DragonRubySplit] GTK still loading...")
      this.canvasTarget.innerHTML = `
        <div style="padding: 2rem; text-align: center;">
          <p style="color: #7aa2f7; font-size: 1.25rem;">
            🎮 DragonRuby Loading...
          </p>
          <div class="loading" style="margin-top: 1rem; color: #565f89;">
            Initializing WASM runtime... (check console for progress)
          </div>
        </div>
      `
    } else {
      console.error("[DragonRubySplit] ✗ DragonRuby not available")
      this.canvasTarget.innerHTML = `
        <div style="padding: 2rem; text-align: center;">
          <p style="color: #f7768e; font-size: 1.5rem; margin-bottom: 1rem;">
            ⚠️ DragonRuby WASM Missing
          </p>
          <p style="color: #565f89; margin-bottom: 1rem;">
            Required file <code style="color: #9ece6a;">public/dragonruby/game.html</code> not found.
          </p>
          <details style="margin-top: 1.5rem;">
            <summary style="color: #7aa2f7; cursor: pointer; user-select: none;">
              Preview Code (click to expand)
            </summary>
            <pre style="color: #a9b1d6; margin-top: 1rem; text-align: left; max-height: 300px; overflow-y: auto; background: #24283b; padding: 1rem; border-radius: 0.375rem; font-size: 0.875rem;">${this.escapeHtml(code)}</pre>
          </details>
        </div>
      `
    }
  }

  extractExecutableCode(literateCode) {
    // Remove comment lines (literate programming prose)
    // Keep only actual Ruby code
    const lines = literateCode.split('\n')
    const codeLines = lines.filter(line => {
      const trimmed = line.trim()
      // Skip empty comment lines and prose comments
      if (trimmed === '#' || trimmed.startsWith('# ')) {
        return false
      }
      return true
    })
    
    let code = codeLines.join('\n').trim()
    
    // Just return the code as-is - tutorial markdown now has complete examples
    return code
  }

  showError(message) {
    this.canvasTarget.innerHTML = `
      <div style="padding: 2rem; text-align: center;">
        <p style="color: #f7768e; font-size: 1.25rem; margin-bottom: 1rem;">
          ⚠️ Error
        </p>
        <pre style="color: #f7768e; text-align: left; background: #24283b; padding: 1rem; border-radius: 0.375rem; overflow-x: auto;">${this.escapeHtml(message)}</pre>
      </div>
    `
  }

  reset() {
    console.log("[DragonRubySplit] Reset button clicked")
    
    const starterCode = this.editorTarget.dataset.starterCode || this.defaultCode()
    
    if (this.editor) {
      this.editor.dispatch({
        changes: {
          from: 0,
          to: this.editor.state.doc.length,
          insert: starterCode
        }
      })
    }
    
    // Clean up existing iframe and reset GTK state
    if (this.gameIframe) {
      console.log("[DragonRubySplit] Removing old iframe during reset")
      this.gameIframe.remove()
      this.gameIframe = null
    }
    this.gtkReady = false
    
    // Reset canvas with placeholder
    this.canvasTarget.innerHTML = '<p class="canvas-placeholder">🎮 Loading DragonRuby engine...</p>'
    
    // Reload DragonRuby engine
    console.log("[DragonRubySplit] Reloading DragonRuby engine after reset")
    this.loadDragonRuby()
  }

  defaultCode() {
    return `def tick args
  args.outputs.labels << [640, 360, "Hello, DragonRuby!", 5, 1]
end`
  }

  escapeHtml(text) {
    const div = document.createElement('div')
    div.textContent = text
    return div.innerHTML
  }
}
