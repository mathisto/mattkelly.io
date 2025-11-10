import { Controller } from "@hotwired/stimulus"
import filesystemService from "lib/filesystem_service"
import commandParser from "lib/command_parser"
import commands from "lib/commands"

export default class extends Controller {
  static targets = ["output", "input", "prompt"]

  async connect() {
    console.log("[Terminal] Controller connected")
    
    // Initialize filesystem
    try {
      await filesystemService.init()
      this.fs = filesystemService.getFS()
      console.log("[Terminal] Filesystem initialized")
    } catch (error) {
      console.error("[Terminal] Failed to initialize filesystem:", error)
      this.appendOutput(`<span style="color: #f7768e;">Failed to initialize filesystem: ${error.message}</span>`)
      return
    }

    // Register commands
    Object.entries(commands).forEach(([name, handler]) => {
      commandParser.register(name, handler)
    })

    // Initialize state
    this.cwd = "/"
    this.prevDir = null
    this.history = this.loadHistory()
    this.historyIndex = this.history.length
    this.cursorPosition = 0
    this.inputText = ""

    // Focus on terminal
    this.element.focus()
    this.element.addEventListener("click", (e) => this.handleClick(e))

    // Show welcome message
    this.showWelcome()
  }

  handleClick(event) {
    // Don't steal focus if user clicked a link
    console.log('[Terminal] Click target:', event.target.tagName, event.target)
    if (event.target.tagName === 'A') {
      console.log('[Terminal] Link clicked, allowing default behavior')
      return
    }
    this.focusInput()
  }

  focusInput() {
    this.element.focus()
  }

  async handleKeydown(event) {
    const key = event.key
    const ctrl = event.ctrlKey
    const input = this.getCurrentInput()

    // Ctrl+C - Cancel current input
    if (ctrl && key === "c") {
      event.preventDefault()
      this.appendOutput(`<span style="color: #565f89;">${this.getPrompt()}${input}^C</span>`)
      this.clearInput()
      this.showPrompt()
      return
    }

    // Ctrl+L - Clear screen
    if (ctrl && key === "l") {
      event.preventDefault()
      this.clearOutput()
      this.showPrompt()
      return
    }

    // Ctrl+U - Clear line
    if (ctrl && key === "u") {
      event.preventDefault()
      this.clearInput()
      return
    }

    // Ctrl+A - Move to start
    if (ctrl && key === "a") {
      event.preventDefault()
      this.cursorPosition = 0
      this.setInput(input)
      return
    }

    // Ctrl+E - Move to end
    if (ctrl && key === "e") {
      event.preventDefault()
      this.cursorPosition = input.length
      this.setInput(input)
      return
    }

    // Enter - Execute command
    if (key === "Enter") {
      event.preventDefault()
      await this.executeCommand(input)
      return
    }

    // Backspace
    if (key === "Backspace") {
      event.preventDefault()
      if (this.cursorPosition > 0) {
        const before = input.slice(0, this.cursorPosition - 1)
        const after = input.slice(this.cursorPosition)
        this.setInput(before + after)
        this.cursorPosition--
      }
      return
    }

    // Arrow Up - Previous command
    if (key === "ArrowUp") {
      event.preventDefault()
      if (this.historyIndex > 0) {
        this.historyIndex--
        this.setInput(this.history[this.historyIndex] || "")
        this.cursorPosition = this.getCurrentInput().length
      }
      return
    }

    // Arrow Down - Next command
    if (key === "ArrowDown") {
      event.preventDefault()
      if (this.historyIndex < this.history.length) {
        this.historyIndex++
        this.setInput(this.history[this.historyIndex] || "")
        this.cursorPosition = this.getCurrentInput().length
      }
      return
    }

    // Arrow Left - Move cursor left
    if (key === "ArrowLeft") {
      event.preventDefault()
      if (this.cursorPosition > 0) {
        this.cursorPosition--
        this.setInput(input)
      }
      return
    }

    // Arrow Right - Move cursor right
    if (key === "ArrowRight") {
      event.preventDefault()
      if (this.cursorPosition < input.length) {
        this.cursorPosition++
        this.setInput(input)
      }
      return
    }

    // Tab - Autocomplete
    if (key === "Tab") {
      event.preventDefault()
      this.handleAutocomplete()
      return
    }

    // Printable characters
    if (key.length === 1 && !ctrl) {
      event.preventDefault()
      const before = input.slice(0, this.cursorPosition)
      const after = input.slice(this.cursorPosition)
      const newInput = before + key + after
      console.log(`[Input] key="${key}" pos=${this.cursorPosition} input="${input}" -> "${newInput}"`)
      this.cursorPosition++  // Move cursor BEFORE rendering
      this.setInput(newInput)
    }
  }

  async executeCommand(input) {
    const trimmed = input.trim()
    
    // Show command in output
    this.appendOutput(`${this.getPrompt()}${input}`)

    if (!trimmed) {
      this.showPrompt()
      return
    }

    // Add to history
    this.addToHistory(trimmed)

    // Execute command
    const context = {
      fs: this.fs,
      cwd: this.cwd,
      setCwd: (path) => { this.cwd = path },
      prevDir: this.prevDir,
      setPrevDir: (path) => { this.prevDir = path }
    }

    try {
      const result = await commandParser.execute(trimmed, context)

      // Check for special clear command
      if (result.output && result.output._clearScreen) {
        this.clearOutput()
      } else {
        // Show output
        if (result.error) {
          this.appendOutput(`<span style="color: #f7768e;">${result.error}</span>`)
        } else if (result.output) {
          this.appendOutput(result.output)
        }
      }
    } catch (error) {
      this.appendOutput(`<span style="color: #f7768e;">Error: ${error.message}</span>`)
    }

    this.clearInput()
    this.showPrompt()
  }

  getCurrentInput() {
    if (!this.hasInputTarget) return ""
    // Store input text separately to avoid cursor HTML interference
    return this.inputText || ""
  }

  setInput(text) {
    if (!this.hasInputTarget) return
    
    // Store the actual text content
    this.inputText = text
    
    // Render text with cursor overlaying character at cursor position
    const beforeCursor = text.slice(0, this.cursorPosition)
    const charAtCursor = text.charAt(this.cursorPosition) || ' '
    const afterCursor = text.slice(this.cursorPosition + 1)
    
    this.inputTarget.innerHTML = 
      beforeCursor + 
      '<span class="cursor">' + charAtCursor + '</span>' + 
      afterCursor
  }

  clearInput() {
    this.inputText = ""
    this.cursorPosition = 0
    this.setInput("")
  }

  getPrompt() {
    const dir = this.cwd === "/" ? "~" : this.cwd.split("/").pop()
    return `<span style="color: #9ece6a;">❯</span> `
  }

  showPrompt() {
    if (this.hasPromptTarget) {
      this.promptTarget.innerHTML = this.getPrompt()
    }
  }

  appendOutput(html) {
    if (!this.hasOutputTarget) return

    const line = document.createElement("div")
    line.innerHTML = html
    line.style.marginBottom = "0.5rem"
    line.style.pointerEvents = "auto"  // Ensure clicks pass through
    this.outputTarget.appendChild(line)
    
    // Force scroll to bottom of output container
    requestAnimationFrame(() => {
      this.outputTarget.scrollTop = this.outputTarget.scrollHeight
    })
  }

  clearOutput() {
    if (this.hasOutputTarget) {
      this.outputTarget.innerHTML = ""
    }
  }

  addToHistory(command) {
    // Don't add duplicate consecutive commands
    if (this.history[this.history.length - 1] !== command) {
      this.history.push(command)
      this.saveHistory()
    }
    this.historyIndex = this.history.length
  }

  loadHistory() {
    try {
      const saved = localStorage.getItem("terminal-history")
      return saved ? JSON.parse(saved) : []
    } catch (e) {
      return []
    }
  }

  saveHistory() {
    try {
      // Keep last 100 commands
      const toSave = this.history.slice(-100)
      localStorage.setItem("terminal-history", JSON.stringify(toSave))
    } catch (e) {
      console.warn("[Terminal] Failed to save history:", e)
    }
  }

  async handleAutocomplete() {
    const input = this.getCurrentInput().trim()
    if (!input) return

    const parts = input.split(/\s+/)
    const isFirstWord = parts.length === 1
    
    if (isFirstWord) {
      // Autocomplete command names
      await this.autocompleteCommand(input)
    } else {
      // Autocomplete file/directory names
      await this.autocompleteFilePath(parts)
    }
  }

  async autocompleteCommand(partial) {
    const commands = commandParser.getCommands()
    const matches = commands.filter(cmd => cmd.startsWith(partial))
    
    if (matches.length === 0) {
      return // No matches
    } else if (matches.length === 1) {
      // Single match - complete it
      const newInput = matches[0] + ' '
      this.cursorPosition = matches[0].length  // Position after completed word, before space
      this.setInput(newInput)
    } else {
      // Multiple matches - show them
      this.appendOutput(`<span style="color: #565f89;">${this.getPrompt()}${this.getCurrentInput()}</span>`)
      this.appendOutput(matches.map(m => `<span style="color: #7aa2f7;">${m}</span>`).join('  '))
      this.showPrompt()
    }
  }

  async autocompleteFilePath(parts) {
    const command = parts[0]
    const partial = parts[parts.length - 1]
    
    try {
      // Get files in current directory
      const entries = await new Promise((resolve, reject) => {
        this.fs.readdir(this.cwd, (err, files) => {
          if (err) reject(err)
          else resolve(files)
        })
      })

      // Filter matches
      const matches = entries.filter(entry => entry.startsWith(partial))
      
      if (matches.length === 0) {
        return // No matches
      } else if (matches.length === 1) {
        // Single match - complete it
        parts[parts.length - 1] = matches[0]
        const completed = parts.join(' ')
        
        // Check if it's a directory to add trailing slash
        const fullPath = this.cwd === '/' ? `/${matches[0]}` : `${this.cwd}/${matches[0]}`
        const stats = await new Promise((resolve, reject) => {
          this.fs.stat(fullPath, (err, stats) => {
            if (err) reject(err)
            else resolve(stats)
          })
        })
        
        const suffix = stats.isDirectory() ? '/' : ' '
        const newInput = completed + suffix
        // Position after completed path, before trailing space (but after / for dirs)
        this.cursorPosition = completed.length + (stats.isDirectory() ? 1 : 0)
        this.setInput(newInput)
      } else {
        // Multiple matches - show them
        this.appendOutput(`<span style="color: #565f89;">${this.getPrompt()}${this.getCurrentInput()}</span>`)
        this.appendOutput(matches.map(m => `<span style="color: #7aa2f7;">${m}</span>`).join('  '))
        this.showPrompt()
      }
    } catch (error) {
      console.error("[Terminal] Autocomplete error:", error)
    }
  }

  async showWelcome() {
    console.log("[Terminal] Controller loaded - v2")
    
    // Execute whoami to show ASCII art
    const context = {
      fs: this.fs,
      cwd: this.cwd,
      setCwd: (path) => { this.cwd = path },
      prevDir: this.prevDir,
      setPrevDir: (path) => { this.prevDir = path }
    }
    
    try {
      const whoamiResult = await commandParser.execute("whoami", context)
      if (whoamiResult.output) {
        this.appendOutput(whoamiResult.output)
      }
      
      this.appendOutput("")
      
      const roleResult = await commandParser.execute("cat role.txt", context)
      if (roleResult.output) {
        this.appendOutput(roleResult.output)
      }
      
      this.appendOutput("")
      this.appendOutput(`<span style="color: #565f89;">Type <span style="color: #e0af68;">help</span> for available commands</span>`)
      this.appendOutput("")
    } catch (error) {
      console.error("[Terminal] Error showing welcome:", error)
    }
    
    this.showPrompt()
  }
}
