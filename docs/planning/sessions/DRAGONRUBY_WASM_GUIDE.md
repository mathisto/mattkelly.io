# DragonRuby WASM Files Needed

## Required Files from DragonRuby GTK

### Core Files:
1. **dragonruby.wasm** - The WebAssembly binary (DragonRuby runtime)
2. **dragonruby.js** - JavaScript loader/glue code for WASM
3. **dragonruby.data** - Pre-loaded data file (if it exists)

### Where to Find Them:
Look in your DragonRuby GTK installation for:
- `/samples/wasm/` directory
- `/html5/` or `/web/` directory
- `/builds/wasm/` directory
- `/samples/html5_helloworld/` directory
- Root directory documentation on web/HTML5 export

### What to Do:
1. Download/extract DragonRuby GTK
2. Search for directories containing "wasm", "html5", "web"
3. Look for `.wasm`, `.js`, and example `.html` files
4. Find any README about "HTML5 export" or "browser deployment"

### Copy Files To:
```
public/dragonruby/
├── dragonruby.wasm
├── dragonruby.js
└── dragonruby.data (if exists)
```

Then I'll integrate them with the CodeMirror editor!
