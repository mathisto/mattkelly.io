import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["output", "input", "prompt"]

  connect() {
    this.commandHistory = []
    this.historyIndex = -1
    this.currentCommand = ""
    this.commands = {
      help: this.showHelp.bind(this),
      whoami: this.showWhoami.bind(this),
      "cat role.txt": this.showRole.bind(this),
      clear: this.clearTerminal.bind(this),
      ls: this.showLs.bind(this),
      pwd: this.showPwd.bind(this)
    }

    // Focus the terminal when clicked
    this.element.addEventListener('click', () => {
      this.element.focus()
    })

    // Initialize with the help message
    this.addOutput('<span style="color: #565f89;">Type <span style="color: #e0af68;">help</span> for available commands</span>')
  }

  handleKeydown(event) {
    event.preventDefault()

    switch(event.key) {
      case 'Enter':
        this.executeCommand()
        break
      case 'Backspace':
        this.deleteCharacter()
        break
      case 'ArrowUp':
        this.navigateHistory(-1)
        break
      case 'ArrowDown':
        this.navigateHistory(1)
        break
      case 'Tab':
        event.preventDefault()
        break
      default:
        if (event.key.length === 1) {
          this.addCharacter(event.key)
        }
    }
  }

  addCharacter(char) {
    this.currentCommand += char
    this.updateInput()
  }

  deleteCharacter() {
    this.currentCommand = this.currentCommand.slice(0, -1)
    this.updateInput()
  }

  updateInput() {
    this.inputTarget.innerHTML = this.currentCommand + '<span class="cursor"> </span>'
  }

  executeCommand() {
    const command = this.currentCommand.trim()

    if (command) {
      this.commandHistory.push(command)
      this.historyIndex = this.commandHistory.length
    }

    // Add command to output
    this.addOutput(`<span style="color: #9ece6a;">❯</span> ${command}`)

    // Execute command
    if (this.commands[command]) {
      this.commands[command]()
    } else if (command) {
      this.addOutput(`<span style="color: #f7768e;">Command not found: ${command}</span>`)
      this.addOutput('<span style="color: #565f89;">Type <span style="color: #e0af68;">help</span> for available commands</span>')
    }

    // Reset for next command
    this.currentCommand = ""
    this.updateInput()
  }

  navigateHistory(direction) {
    if (this.commandHistory.length === 0) return

    this.historyIndex += direction

    if (this.historyIndex < 0) {
      this.historyIndex = -1
      this.currentCommand = ""
    } else if (this.historyIndex >= this.commandHistory.length) {
      this.historyIndex = this.commandHistory.length
      this.currentCommand = ""
    } else {
      this.currentCommand = this.commandHistory[this.historyIndex]
    }

    this.updateInput()
  }

  addOutput(content) {
    const div = document.createElement('div')
    div.style.marginBottom = '0.5rem'
    div.style.pointerEvents = 'auto'
    div.style.textAlign = 'left'

    // Check if content contains ASCII art (block characters)
    if (content.includes('█') || content.includes('╔') || content.includes('╗') || content.includes('╚') || content.includes('╝')) {
      div.style.whiteSpace = 'pre'
      div.style.lineHeight = '1.1'
    } else {
      div.style.whiteSpace = 'pre-wrap'
      div.style.lineHeight = '1.4'
      div.style.wordWrap = 'break-word'
    }

    div.innerHTML = content
    this.outputTarget.appendChild(div)
    this.element.scrollTop = this.element.scrollHeight
  }

  showHelp() {
    this.addOutput('<span style="color: #7aa2f7;">Available commands:</span>')
    this.addOutput('  <span style="color: #e0af68;">help</span>     - Show this help message')
    this.addOutput('  <span style="color: #e0af68;">whoami</span>   - Display user information')
    this.addOutput('  <span style="color: #e0af68;">cat role.txt</span> - Display role description')
    this.addOutput('  <span style="color: #e0af68;">ls</span>       - List directory contents')
    this.addOutput('  <span style="color: #e0af68;">pwd</span>      - Print working directory')
    this.addOutput('  <span style="color: #e0af68;">clear</span>    - Clear the terminal')
  }

  showWhoami() {
    const ascii = `<span style="color: #bb9af7;">███╗   ███╗ █████╗ ████████╗████████╗    ██╗  ██╗███████╗██╗     ██╗     ██╗   ██╗
████╗ ████║██╔══██╗╚══██╔══╝╚══██╔══╝    ██║ ██╔╝██╔════╝██║     ██║     ╚██╗ ██╔╝
██╔████╔██║███████║   ██║      ██║       █████╔╝ █████╗  ██║     ██║      ╚████╔╝
██║╚██╔╝██║██╔══██║   ██║      ██║       ██╔═██╗ ██╔══╝  ██║     ██║       ╚██╔╝
██║ ╚═╝ ██║██║  ██║   ██║      ██║       ██║  ██╗███████╗███████╗███████╗   ██║
╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝      ╚═╝       ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝   ╚═╝</span>`
    this.addOutput(ascii)
  }

  showRole() {
    this.addOutput('Polyglot problem solver who bridges the gap between complex architecture and human-centered leadership.')
  }

  showLs() {
    this.addOutput('<span style="color: #a9b1d6;">about.txt    projects/    contact.txt    skills.txt</span>')
  }

  showPwd() {
    this.addOutput('<span style="color: #a9b1d6;">/home/matt</span>')
  }

  clearTerminal() {
    this.outputTarget.innerHTML = ''
    this.addOutput('<span style="color: #565f89;">Terminal cleared. Type <span style="color: #e0af68;">help</span> for available commands</span>')
  }
}