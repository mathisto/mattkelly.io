// Filer is loaded via script tag as a global
const Filer = window.Filer

class FilesystemService {
  constructor() {
    this.fs = null
    this.initialized = false
  }

  async init() {
    if (this.initialized) return this.fs

    return new Promise((resolve, reject) => {
      this.fs = new Filer.FileSystem({
        name: "mattkelly-io-terminal",
        provider: new Filer.FileSystem.providers.IndexedDB()
      })

      this.populateInitialFiles()
        .then(() => {
          this.initialized = true
          resolve(this.fs)
        })
        .catch(reject)
    })
  }

  async populateInitialFiles() {
    const sh = this.fs.promises
    const FILESYSTEM_VERSION = "5"  // Increment to force repopulation

    try {
      const versionContent = await sh.readFile("/.version", "utf8")
      if (versionContent === FILESYSTEM_VERSION) {
        console.log("[Filesystem] Already initialized, skipping population")
        return
      }
      console.log("[Filesystem] Version mismatch, clearing and repopulating files...")
      
      // Clear all files by recreating the filesystem
      // This is simpler than trying to delete individual files
      const Filer = window.Filer
      await new Promise((resolve) => {
        indexedDB.deleteDatabase("mattkelly-io-terminal")
        setTimeout(resolve, 100) // Give it time to delete
      })
      
      // Recreate filesystem
      this.fs = new Filer.FileSystem({
        name: "mattkelly-io-terminal",
        provider: new Filer.FileSystem.providers.IndexedDB()
      })
      
      console.log("[Filesystem] Database cleared, populating fresh files...")
    } catch (e) {
      console.log("[Filesystem] First run, populating initial files...")
    }

    await sh.writeFile("/README.md", `# Welcome to Matt Kelly's Portfolio Terminal

This is an interactive shell emulator running entirely in your browser. Your filesystem is persisted in IndexedDB, so any changes you make will survive page reloads.

## Getting Started

Try these commands:
- \`ls\` - List files in the current directory
- \`cat role.txt\` - Read my role description
- \`./whoami\` - Run the whoami script
- \`help\` - See all available commands
- \`clear\` - Clear the terminal

## Easter Eggs

There are hidden files and commands throughout the filesystem. Try:
- \`ls -la\` to see hidden files
- Explore the \`.secrets/\` directory
- Try running \`neofetch\` or \`fortune\`

Happy exploring!
`)

    await sh.writeFile("/role.txt", "Polyglot problem solver who bridges the gap between complex architecture and human-centered leadership.")

    const asciiArt = `███╗   ███╗ █████╗ ████████╗████████╗    ██╗  ██╗███████╗██╗     ██╗     ██╗   ██╗
████╗ ████║██╔══██╗╚══██╔══╝╚══██╔══╝    ██║ ██╔╝██╔════╝██║     ██║     ╚██╗ ██╔╝
██╔████╔██║███████║   ██║      ██║       █████╔╝ █████╗  ██║     ██║      ╚████╔╝ 
██║╚██╔╝██║██╔══██║   ██║      ██║       ██╔═██╗ ██╔══╝  ██║     ██║       ╚██╔╝  
██║ ╚═╝ ██║██║  ██║   ██║      ██║       ██║  ██╗███████╗███████╗███████╗   ██║   
╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝      ╚═╝       ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝   ╚═╝`

    await sh.writeFile("/whoami", `#!/bin/bash
# Display Matt Kelly ASCII art name

cat << 'EOF'
${asciiArt}
EOF
`)

    await sh.chmod("/whoami", 0o755)

    await sh.writeFile("/contact.txt", `📧&nbsp;Email:&nbsp;matthew.ryan.kelly@gmail.com
📄&nbsp;CV:&nbsp;/CV.pdf
🐙&nbsp;GitHub:&nbsp;https://github.com/mathisto
💼&nbsp;LinkedIn:&nbsp;https://www.linkedin.com/in/matthewryankelly`)

    await sh.mkdir("/projects")
    await sh.writeFile("/projects/mattkelly-io.txt", `# mattkelly.io

My personal portfolio website built with Rails 8, ViewComponent, and Stimulus.

**Tech Stack:**
- Ruby on Rails 8
- Hotwire (Turbo + Stimulus)
- ViewComponent architecture
- Tokyo Night theme
- Interactive terminal (you're using it now!)

**Features:**
- Blog with markdown support
- GitHub contribution heatmap
- Responsive design
- This very terminal emulator!
`)

    await sh.mkdir("/.secrets")
    await sh.writeFile("/.secrets/superpowers.txt", `# Matt's Technical Superpowers

## Languages
- Ruby (expert)
- Python (proficient)
- JavaScript/TypeScript (proficient)
- Go (intermediate)
- Clojure (familiar)
- Lua (familiar)

## Frameworks & Tools
- Ruby on Rails (expert)
- React (proficient)
- Docker & Kubernetes (proficient)
- AWS (proficient)
- PostgreSQL, Redis, MongoDB

## Specialties
- System Architecture & Design
- Technical Leadership & Mentoring
- Cloud Infrastructure & DevOps
- API Design & Microservices
`)

    await sh.writeFile("/.secrets/philosophy.md", `# Development Philosophy

## Core Principles

1. **Clarity over Cleverness**
   Code should be readable by humans first, machines second.

2. **Test What Matters**
   Focus testing effort on business logic and integration points.

3. **Iterate Quickly**
   Ship early, learn fast, improve continuously.

4. **Lead with Empathy**
   The best code is written by teams that care about each other.

5. **Embrace Constraints**
   Limitations breed creativity and focus.

## On Technology Choices

> "Choose boring technology." - Dan McKinley

The newest framework isn't always the right choice. Proven, stable tech with great documentation often wins.

## On Leadership

Great technical leaders:
- Write code alongside their team
- Say "I don't know" without shame
- Celebrate others' successes
- Make time for mentoring
- Keep learning, always
`)

    await sh.mkdir("/.config")
    await sh.writeFile("/.config/theme.json", JSON.stringify({
      name: "Tokyo Night",
      colors: {
        background: {
          primary: "#1a1b26",
          secondary: "#1f2335",
          tertiary: "#24283b"
        },
        foreground: {
          primary: "#a9b1d6",
          secondary: "#565f89"
        },
        accent: {
          red: "#f7768e",
          orange: "#ff9e64",
          yellow: "#e0af68",
          green: "#9ece6a",
          cyan: "#7dcfff",
          blue: "#7aa2f7",
          purple: "#bb9af7",
          magenta: "#bb9af7"
        },
        ui: {
          border: "#29293f",
          selection: "#364a82",
          comment: "#565f89"
        }
      }
    }, null, 2))

    // Write version file
    await sh.writeFile("/.version", FILESYSTEM_VERSION)

    console.log("[Filesystem] Initial files created successfully")
  }

  getFS() {
    if (!this.initialized) {
      throw new Error("Filesystem not initialized. Call init() first.")
    }
    return this.fs
  }
}

export default new FilesystemService()
