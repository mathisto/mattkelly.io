# DragonRuby WASM Integration Guide

## Current Status ✅

### Completed:
1. ✅ **Clean UI** - Removed duplicate HTML, streamlined view template
2. ✅ **Ruby Syntax Highlighting** - CodeMirror 6 with Ruby language support
3. ✅ **Tokyo Night Theme** - Enhanced with Ruby-specific syntax colors
4. ✅ **WASM Integration Prep** - Controller ready to load DragonRuby runtime
5. ✅ **Public Directory** - `/public/dragonruby/` created for WASM files

### Next Step:
**Add DragonRuby WASM files** to `/public/dragonruby/`

---

## DragonRuby WASM Files Needed

### Required Files:
```
public/dragonruby/
├── dragonruby.wasm    # Core runtime (WebAssembly binary)
├── dragonruby.js      # JavaScript loader/glue code
└── dragonruby.data    # Preloaded data (if exists)
```

### Where to Find in DragonRuby GTK:
Look for these directories in your DragonRuby GTK installation:
- `/samples/wasm/`
- `/html5/` or `/web/`
- `/builds/wasm/`
- `/samples/html5_helloworld/`
- Root directory (check docs for "HTML5 export")

### Copy Files:
Once found, copy to:
```bash
cp /path/to/dragonruby-gtk/samples/wasm/* public/dragonruby/
```

---

## Tokyo Night Syntax Colors

The editor now has proper Ruby syntax highlighting with Tokyo Night colors:

| Element | Color | Example |
|---------|-------|---------|
| **Keywords** | Purple `#bb9af7` | `def`, `end`, `class`, `if` |
| **Functions** | Blue `#7aa2f7` | `tick`, `args.outputs` |
| **Strings** | Green `#9ece6a` | `"Hello, DragonRuby!"` |
| **Numbers** | Orange `#ff9e64` | `640`, `360`, `5` |
| **Comments** | Dark Gray `#565f89` | `# This is a comment` |
| **Operators** | Cyan `#89ddff` | `<<`, `+`, `=` |
| **Constants** | Yellow `#e0af68` | `CONSTANT_NAME` |
| **Self** | Red `#f7768e` | `self` |

---

## How the Integration Works

### 1. Editor Initialization
```javascript
// app/javascript/controllers/dragonruby_split_controller.js
connect() {
  this.initializeEditor()      // CodeMirror 6 with Ruby syntax
  this.setupResizeHandle()     // 50/50 split pane
  this.loadDragonRuby()        // Check for WASM files
}
```

### 2. WASM Loading (Auto-Detection)
```javascript
loadDragonRuby() {
  // Attempts to load /dragonruby/dragonruby.js
  // If found: Initializes runtime
  // If not found: Shows preview mode
}
```

### 3. Code Execution
```javascript
async run() {
  const code = this.editor.state.doc.toString()
  
  if (this.dragonRubyModule) {
    // WASM loaded: Execute with DragonRuby
    await this.dragonRubyModule.eval(code)
    this.dragonRubyModule.start(canvas)
  } else {
    // WASM not loaded: Show preview with code
  }
}
```

---

## Expected DragonRuby WASM API

The controller expects this API (based on standard WASM patterns):

```javascript
window.DragonRuby = {
  // Initialize the runtime
  init: async (config) => {
    // config: { canvas, wasmPath, dataPath }
    return moduleInstance
  },
  
  // Module instance methods
  moduleInstance: {
    // Evaluate Ruby code
    eval: async (code) => { /* ... */ },
    
    // Start game loop on canvas
    start: (canvas) => { /* ... */ }
  }
}
```

**Note:** Actual API may differ - will need to adapt based on real DragonRuby WASM implementation.

---

## Testing the Integration

### Before WASM Files (Current State):
1. Visit: `http://localhost:3000/dragonruby/001-hello-world`
2. See: CodeMirror editor with Ruby syntax highlighting
3. Click "Run": Shows preview mode message
4. **Expected**: Purple keywords, green strings, blue functions

### After WASM Files Added:
1. Copy WASM files to `/public/dragonruby/`
2. Refresh page
3. Click "Run": Should execute Ruby code
4. **Expected**: Game renders in canvas (1280x720)

### Keyboard Shortcuts:
- `Cmd+Enter` (Mac) / `Ctrl+Enter` (Windows): Run code
- Standard editor shortcuts (Cmd+A, Cmd+C, etc.)

---

## Current File Structure

```
app/
├── javascript/
│   └── controllers/
│       └── dragonruby_split_controller.js   # Main controller
├── models/
│   └── tutorial.rb                          # literate_code method
└── views/
    └── dragonruby/
        └── show.html.erb                    # Clean template

config/
└── importmap.rb                             # CodeMirror + Ruby support

public/
└── dragonruby/                              # WASM files go here
    ├── .gitkeep
    └── README.md

dragonruby/                                  # Tutorial content
├── 001-hello-world.md
├── 002-tick-method.md
└── ...
```

---

## Troubleshooting

### Editor Not Loading:
1. Check browser console for errors
2. Verify importmap loaded: Network tab → `application-*.js`
3. Hard refresh: `Cmd+Shift+R` (Mac) or `Ctrl+Shift+F5` (Windows)

### Ruby Syntax Not Colored:
1. Check `@codemirror/legacy-modes` loaded in Network tab
2. Verify Tokyo Night theme applied (look for purple keywords)
3. Check console for: `"CodeMirror 6 initialized with Ruby syntax"`

### WASM Not Loading:
1. Verify files in `/public/dragonruby/`:
   ```bash
   ls -lh public/dragonruby/
   ```
2. Check browser console for load errors
3. Verify files served: `curl -I http://localhost:3000/dragonruby/dragonruby.js`

### Canvas Not Rendering:
1. Check console for DragonRuby initialization errors
2. Verify canvas created: Inspect element in DevTools
3. Check WASM API matches expected interface

---

## Next Steps After WASM Integration

Once WASM files are added and working:

### Phase 1: Core Functionality
- [ ] Test basic code execution
- [ ] Verify game loop runs at 60 FPS
- [ ] Test error handling and display
- [ ] Implement "Reset" button (reload canvas)

### Phase 2: Enhanced Features
- [ ] Add tutorial navigation (prev/next)
- [ ] Show tutorial challenges/exercises
- [ ] Add code completion hints
- [ ] Implement save/restore code

### Phase 3: Advanced Features
- [ ] Multi-file support (if needed)
- [ ] Asset uploading (images, sounds)
- [ ] Share code via URL
- [ ] Export game as standalone

---

## References

- **CodeMirror 6**: https://codemirror.net/
- **DragonRuby GTK**: https://dragonruby.org/
- **Tokyo Night Theme**: https://github.com/enkia/tokyo-night-vscode-theme
- **Project Summary**: `hero-terminal-overhaul.md`
