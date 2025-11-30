# Interactive Terminal Emulator

Browser-based shell emulator with virtual filesystem, persistent storage, and Tokyo Night styling.

## Overview

The terminal emulator is a fully interactive, browser-based shell that runs in the hero section of the homepage. Users can explore a virtual filesystem, execute commands, and interact with hidden easter eggs.

**Live Route**: `/` (homepage hero section)  
**Test Route**: `/terminal-test` (standalone test page)

## Features

### Virtual Filesystem
- **Technology**: Filer.js with IndexedDB backend
- **Persistence**: Files survive page reloads
- **Initial Contents**:
  - `README.md` - Welcome message
  - `role.txt` - Professional tagline
  - `whoami` - ASCII art name display
  - `contact.sh` - Contact information
  - `projects/` - Project summaries
  - `.secrets/superpowers.txt` - Technical skills
  - `.secrets/philosophy.md` - Development philosophy
  - `.config/theme.json` - Tokyo Night color scheme

### Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `ls` | List directory contents | `ls -la` |
| `cat` | Display file contents | `cat role.txt` |
| `cd` | Change directory | `cd projects` |
| `pwd` | Print working directory | `pwd` |
| `clear` | Clear terminal output | `clear` |
| `help` | Show available commands | `help` |
| `whoami` | Display ASCII art | `whoami` |

### Command Features

**`ls` flags**:
- `-l` - Long format with details
- `-a` - Show hidden files
- `-la` - Combine flags

**`cd` paths**:
- Relative: `cd projects`
- Absolute: `cd /projects`
- Parent: `cd ..`
- Home: `cd ~`
- Previous: `cd -`

### Keyboard Controls

| Key | Action |
|-----|--------|
| **Enter** | Execute command |
| **↑ / ↓** | Navigate command history |
| **← / →** | Move cursor in input |
| **Ctrl+C** | Cancel current input |
| **Ctrl+L** | Clear screen |
| **Ctrl+A** | Move to start of line |
| **Ctrl+E** | Move to end of line |
| **Ctrl+U** | Clear input line |
| **Tab** | Autocomplete (coming soon) |

## Architecture

### File Structure

```
app/javascript/
├── controllers/
│   └── interactive_terminal_controller.js  # Main controller
└── lib/
    ├── filesystem_service.js               # Filer.js wrapper
    ├── command_parser.js                   # Command execution
    └── commands/
        ├── index.js                        # Barrel export
        ├── ls.js                           # List files
        ├── cat.js                          # Read files
        ├── cd.js                           # Change directory
        ├── pwd.js                          # Print directory
        ├── clear.js                        # Clear output
        ├── help.js                         # Show help
        └── whoami.js                       # ASCII art
```

### Controller: `interactive_terminal_controller.js`

Stimulus controller managing terminal UI and state:

```javascript
import { Controller } from "@hotwired/stimulus"
import filesystemService from "lib/filesystem_service"
import commandParser from "lib/command_parser"

export default class extends Controller {
  static targets = ["output", "input"]
  
  connect() {
    this.history = []
    this.historyIndex = 0
    this.cursorPosition = 0
    this.currentDir = "/"
    
    // Initialize filesystem
    filesystemService.init()
  }
  
  handleKeydown(event) {
    // Handle keyboard input
  }
  
  executeCommand(input) {
    // Parse and execute command
  }
}
```

### Service: `filesystem_service.js`

Wrapper around Filer.js for filesystem operations:

```javascript
let fs = null
let initialized = false

export default {
  async init() {
    if (initialized) return
    
    const Filer = window.Filer
    fs = new Filer.FileSystem()
    
    // Populate initial files
    await this.populateInitialFiles()
    initialized = true
  },
  
  async readFile(path) {
    // Read file contents
  },
  
  async listDirectory(path) {
    // List directory contents
  }
}
```

### Command Parser: `command_parser.js`

Executes commands and returns formatted output:

```javascript
import commands from "lib/commands"

export default {
  async execute(input, context) {
    const parts = input.trim().split(/\s+/)
    const command = parts[0]
    const args = parts.slice(1)
    
    if (!commands[command]) {
      return { error: `Command not found: ${command}` }
    }
    
    return await commands[command](args, context)
  }
}
```

## Styling

### Tokyo Night Colors

```css
/* Terminal colors */
--terminal-bg: #1a1b26;          /* Background */
--terminal-fg: #a9b1d6;          /* Default text */
--terminal-command: #7aa2f7;     /* Commands (blue) */
--terminal-success: #9ece6a;     /* Success (green) */
--terminal-error: #f7768e;       /* Errors (red) */
--terminal-warning: #e0af68;     /* Warnings (yellow) */
--terminal-path: #bb9af7;        /* File paths (purple) */
--terminal-cursor: #bb9af7;      /* Cursor (purple) */
```

### Cursor Animation

```css
.cursor {
  display: inline;
  background: rgba(187, 154, 247, 0.4);
  animation: blink 1.5s ease-in-out infinite;
}

@keyframes blink {
  0%, 49% { opacity: 1; }
  50%, 100% { opacity: 0.3; }
}
```

## Known Issues

### Current Issues

1. **Auto-scroll** - Terminal doesn't scroll to bottom as content grows
2. **Cursor positioning** - Cursor stays at position 0 instead of moving with text
3. **Character offset** - First character appears at position 1

### Working Features

- ✅ Keyboard input capture
- ✅ Command execution
- ✅ Command history (↑/↓ arrows)
- ✅ Ctrl shortcuts (C, L, U, A, E)
- ✅ Tokyo Night colors
- ✅ Filer.js filesystem integration

## Adding New Commands

See [Adding Terminal Commands Guide](../guides/adding-terminal-commands.md) for step-by-step instructions.

### Quick Example

1. Create `app/javascript/lib/commands/echo.js`:

```javascript
export default async function echo(args, context) {
  return {
    output: args.join(" "),
    type: "success"
  }
}
```

2. Import in `app/javascript/lib/commands/index.js`:

```javascript
import echo from "lib/commands/echo"

export default {
  // ... other commands
  echo
}
```

3. Hard refresh browser (`Cmd+Shift+R`)

## Future Enhancements

### Planned Features
- [ ] Tab autocomplete for files and commands
- [ ] Command history persistence (localStorage)
- [ ] Mobile command palette (touch-friendly)
- [ ] Additional commands (mkdir, touch, rm, cp, mv, echo)
- [ ] Man pages (`man ls`)
- [ ] Easter egg commands (neofetch, cowsay, sl)
- [ ] File upload/download
- [ ] Sound effects (toggleable)

### Technical Improvements
- [ ] Fix auto-scroll to bottom
- [ ] Fix cursor positioning bugs
- [ ] Virtual scrolling for long output
- [ ] Performance optimization for large files
- [ ] Accessibility improvements (ARIA labels, screen reader support)

## Testing

### Manual Testing

```bash
# Visit test page
open http://localhost:3000/terminal-test

# Try commands
ls
cat README.md
cd projects
pwd
cd ..
clear
help
whoami
```

### System Tests

```ruby
# spec/system/terminal_spec.rb
RSpec.describe "Interactive Terminal", type: :system do
  it "executes ls command" do
    visit terminal_test_path
    
    fill_in "terminal-input", with: "ls"
    send_keys :enter
    
    expect(page).to have_content("README.md")
  end
end
```

## Debugging

### Check Filesystem Initialization

```javascript
// In browser console
filesystemService.fs
// Should show Filer filesystem object
```

### View IndexedDB

1. Open DevTools → Application
2. IndexedDB → filer
3. Browse stored files

### Console Logging

```javascript
console.log('[Terminal] Command executed:', input)
console.log('[FileSystem] Reading file:', path)
```

## Resources

- [Planning Document](../planning/sessions/terminal-overhaul.md) - Detailed implementation plan
- [Filer.js Documentation](https://github.com/filerjs/filer)
- [Stimulus Handbook](https://stimulus.hotwired.dev/)
