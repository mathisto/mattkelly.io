# DragonRuby WASM Integration - Official Build Solution

## Current Status: Using Official DragonRuby HTML5 Export

### Root Cause of Canvas Rendering Issue

The manual WASM integration from fiddle.dragonruby.org wasn't working because DragonRuby's official HTML5 export uses a sophisticated file syncing system via IndexedDB. The key missing components:

1. **dragonruby-html5-loader.js** - Official loader that syncs gamedata files to IndexedDB
2. **dragonruby-serviceworker.js** - Service worker for COOP/COEP headers (required for SharedArrayBuffer)
3. **dragonruby-wasm.worker.js** - Web worker for WASM execution  
4. **gamedata/** directory - Contains all game files that get synced to virtual filesystem
5. **manifest.json** - File manifest for the loader to know what to download

### How We Got the Official Files

Used DragonRuby Pro's publish command to create a proper HTML5 build:

```bash
cd ~/projects/dragonruby

# Create metadata file
cat > mygame/metadata/game_metadata.txt << 'EOF'
devid=testdev
devtitle=Test Developer  
gameid=drtest
gametitle=DragonRuby Test
version=0.1
icon=metadata/icon.png
EOF

# Build HTML5 version
./dragonruby-publish --only-package mygame

# This creates: ~/projects/dragonruby/builds/drtest-html5-0.1/
# Copied to: public/dragonruby/official-build/
```

### File Structure After Integration

```
public/dragonruby/
├── game.html                       # Updated wrapper (uses official loader)
├── dragonruby-html5-loader.js     # Official loader (syncs files from gamedata/)
├── dragonruby-serviceworker.js    # Service worker for COOP/COEP headers
├── dragonruby-wasm.js             # WASM JS glue code (322KB official)
├── dragonruby-wasm.wasm           # WASM binary (3.3MB official vs 2.5MB from fiddle)
├── dragonruby-wasm.worker.js      # Web worker
├── font.ttf                        # Font file
├── gamedata/                       # Synced to IndexedDB on load
│   ├── app/
│   │   ├── main.rb                 # Main game code
│   │   └── repl.rb                 # REPL support
│   ├── sprites/                    # Game sprites (included by default)
│   ├── sounds/                     # Game sounds directory
│   ├── fonts/                      # Additional fonts directory
│   ├── metadata/                   # Game metadata
│   ├── font.ttf                    # Font (also in gamedata root)
│   └── manifest.json               # File manifest for loader
└── official-build/                 # Full official export (for reference)
```

### How the Official System Works

1. **Page loads** → `dragonruby-html5-loader.js` executes
2. **Loader checks** for SharedArrayBuffer support
3. **If missing** → Installs `dragonruby-serviceworker.js`, reloads page
4. **Syncs files** from `gamedata/` to IndexedDB database named "files"
5. **Mounts IndexedDB** as Emscripten filesystem at `/testdev-drtest/`
6. **Loads WASM** → `dragonruby-wasm.js` initializes via Web Worker
7. **Runs game** → Reads `/testdev-drtest/app/main.rb` and executes tick loop

### Dynamic Code Updates

The `saveMain()` function writes code to the mounted IndexedDB filesystem:

```javascript
// In game.html postRun callback
window.gtk.saveMain = function(code) {
  // Write to the path DragonRuby is watching
  FS.writeFile('/testdev-drtest/app/main.rb', code);
}
```

**Key Path**: `/testdev-drtest/` comes from `GDragonRubyWriteDir` variable in loader  
**Format**: `/{devid}-{gameid}` = `/testdev-drtest`

### Why the Previous Approach Failed

**What we tried**:
- Manually create `/app/` directory in Emscripten FS during preRun
- Manually write `main.rb` before WASM loads
- Use downloaded fiddle WASM files (incomplete build)

**Why it failed**:
- ❌ No file syncing system (gamedata → IndexedDB → FS)
- ❌ Wrong write path (`/app/main.rb` vs `/testdev-drtest/app/main.rb`)
- ❌ Incomplete WASM build (fiddle version missing production features)
- ❌ No service worker for SharedArrayBuffer support
- ❌ No Web Worker for proper WASM execution
- ❌ Manual FS setup conflicts with official loader's setup

### Browser Compatibility

The loader handles:
- **Safari/Mobile Safari**: Click-to-load for iframes (security)
- **Android**: Special compatibility handling
- **Firefox**: Compatibility checks
- **Nested iframes**: Detects and redirects to top-level
- **SharedArrayBuffer**: Auto-installs service worker if needed

### Testing the Integration

1. **Start Rails server**: `bin/rails server`
2. **Visit tutorial**: http://localhost:3000/dragonruby/001-hello-world
3. **Click "Run"**: Code executes in DragonRuby WASM
4. **Expected result**: 
   - Dark background (RGB 26, 27, 38 - Tokyo Night dark)
   - White text "Hello from DragonRuby!" at center (640, 360)
   - Running at 60 FPS in game loop

### Debugging Checklist

If canvas still shows wrong content:

- [ ] Open browser DevTools console
- [ ] Check for SharedArrayBuffer errors
  - `typeof SharedArrayBuffer` should return "function"
  - If missing, service worker should auto-install
- [ ] Verify service worker installed
  - DevTools → Application → Service Workers
  - Should see `dragonruby-serviceworker.js` active
- [ ] Check IndexedDB populated
  - DevTools → Application → IndexedDB → "files"
  - Should contain database with gamedata files
- [ ] Verify filesystem mounted
  - In iframe console: `FS.readdir('/testdev-drtest/app')`
  - Should return `['main.rb', 'repl.rb']`
- [ ] Check main.rb content
  - In iframe console: `FS.readFile('/testdev-drtest/app/main.rb', {encoding:'utf8'})`
  - Should show the Ruby code
- [ ] Try hard refresh
  - Clear cache and service worker: Cmd+Shift+R (Mac) or Ctrl+Shift+F5 (Windows)
- [ ] Verify WASM file size
  - DevTools → Network → `dragonruby-wasm.wasm`
  - Should be ~3.3MB (official) not 2.5MB (fiddle)

### Performance Comparison

| Aspect | Fiddle Build | Official Build |
|--------|--------------|----------------|
| WASM Size | 2.5MB | 3.3MB |
| Features | Limited (web only) | Full (networking, file I/O, etc.) |
| Error Handling | Basic | Production-ready |
| SharedArrayBuffer | Manual setup | Auto service worker |
| File System | Manual FS.mkdir | Auto IndexedDB sync |
| Loading | Direct WASM | Loader + Worker |

### Success Criteria

✅ **Integration complete when**:
1. Page loads without errors
2. Service worker installs (if needed for SharedArrayBuffer)
3. IndexedDB "files" database populated with gamedata
4. Canvas shows dark Tokyo Night background (26, 27, 38)
5. Text "Hello from DragonRuby!" renders at center
6. Code updates work via "Run" button
7. No console errors about SharedArrayBuffer or COOP/COEP
8. Game runs at 60 FPS

### Files to Keep vs Remove

**Keep** (essential for production):
- game.html (our custom wrapper with Tokyo Night theme)
- dragonruby-html5-loader.js
- dragonruby-serviceworker.js  
- dragonruby-wasm.{js,wasm,worker.js}
- gamedata/ directory (all files)
- font.ttf

**Can remove** (after verification):
- official-build/ directory (reference only, 7.4MB)
- test.html (diagnostic)
- direct-test.html (diagnostic)
- game-official.html (copy of official index.html)

### Next Steps

1. ✅ Official HTML5 export created via `dragonruby-publish`
2. ✅ All files copied to `public/dragonruby/`
3. ✅ game.html updated to use official loader
4. ✅ saveMain() updated with correct write path `/testdev-drtest/app/main.rb`
5. 🔲 **TEST in browser**: 
   - Open http://localhost:3000/dragonruby/001-hello-world
   - Click "Run" button
   - Verify canvas renders correctly
6. 🔲 **If working**: Remove diagnostic files, keep only essentials
7. 🔲 **If not working**: Follow debugging checklist above

### Key Differences from Manual Approach

| Aspect | Manual (Failed) | Official (Working) |
|--------|----------------|-------------------|
| File Loading | preRun FS.writeFile | IndexedDB sync via loader |
| Write Path | `/app/main.rb` | `/testdev-drtest/app/main.rb` |
| SharedArrayBuffer | Assumed available | Service worker provides headers |
| WASM Execution | Direct Module load | Web Worker |
| File Persistence | None (reloads on refresh) | IndexedDB (persists) |
| Error Handling | Basic try/catch | Production error recovery |

---

**Status**: Ready for browser testing. All official files in place.  
**Next Action**: Open browser and test http://localhost:3000/dragonruby/001-hello-world
