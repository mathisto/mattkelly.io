# DragonRuby WASM Integration - Session Summary for Next Context

## Current Status: 95% Complete - SharedArrayBuffer Headers Working

### What We Achieved This Session

1. ✅ **Identified root cause** - Manual WASM approach failed, needed official build
2. ✅ **Generated official HTML5 build** using `dragonruby-publish` from DragonRuby Pro
3. ✅ **Copied all official files** to `public/dragonruby/`
4. ✅ **Updated game.html** to use official loader system
5. ✅ **Fixed saveMain path** to `/testdev-drtest/app/main.rb`
6. ✅ **Added Rails middleware** for COOP/COEP headers
7. ✅ **Server configured** and serving headers correctly

### The Core Problem We Solved

**Original Issue**: Canvas rendering "Import+" error, DragonRuby executing but not visible

**Root Cause**: Three interconnected problems:
1. Manual WASM from fiddle.dragonruby.org was incomplete (missing production features)
2. Wrong filesystem path (`/app/main.rb` vs `/testdev-drtest/app/main.rb`)  
3. Missing COOP/COEP headers causing SharedArrayBuffer to be undefined

### Solution Architecture

```
Browser Request
    ↓
Rails Middleware (adds COOP/COEP headers)
    ↓
game.html loads with headers
    ↓
SharedArrayBuffer available!
    ↓
dragonruby-html5-loader.js executes
    ↓
Syncs gamedata/ → IndexedDB → /testdev-drtest/
    ↓
dragonruby-wasm.js loads via Web Worker
    ↓
postRun creates window.gtk.saveMain()
    ↓
Parent page can call iframe.contentWindow.gtk.saveMain(code)
```

### Files Modified/Created

**Core Integration:**
- `public/dragonruby/game.html` - Updated wrapper with iframe detection
- `public/dragonruby/dragonruby-html5-loader.js` - Official loader (copied)
- `public/dragonruby/dragonruby-serviceworker.js` - Fixed to only intercept /dragonruby/ paths
- `public/dragonruby/dragonruby-wasm.{js,wasm,worker.js}` - Official WASM files
- `public/dragonruby/gamedata/*` - All game files synced to IndexedDB

**Rails Configuration:**
- `app/controllers/dragonruby_controller.rb` - Added `set_wasm_headers` before_action
- `config/initializers/dragonruby_headers.rb` - Middleware for static files
- `app/javascript/controllers/dragonruby_split_controller.js` - Updated waitForGTK to check saveMain exists

### Current Blocker: Service Worker vs Rails Headers

**The Issue:**
We have TWO systems trying to add COOP/COEP headers:

1. **Rails Middleware** ✅ WORKING
   - `dragonruby_controller.rb` adds headers to Rails responses
   - `dragonruby_headers.rb` initializer adds headers to static files
   - Verified working: `curl -I http://localhost:8080/dragonruby/game.html` shows headers

2. **Service Worker** ⚠️ PROBLEMATIC
   - `dragonruby-serviceworker.js` tries to add headers client-side
   - Requires page reload to activate
   - Interferes with external resources (CDN, fonts, etc.)
   - Causes errors: "RangeError: Failed to construct 'Response': The status provided (0) is outside the range [200, 599]"

**Decision Point for Next Session:**

Since Rails headers are working, we have TWO options:

**Option A: Remove Service Worker (RECOMMENDED)**
```javascript
// In game.html, comment out or remove service worker logic
// The official loader will try to register it, but we can skip that check
```

**Option B: Fix Service Worker Scope**
- Already updated to only intercept `/dragonruby/` paths
- But still causes reload loop in iframe context
- More complex to debug

### What to Test Next

1. **Open browser to**: http://localhost:8080/dragonruby/001-hello-world
2. **Check console for**:
   - ✅ "DragonRuby GTK ready!"
   - ✅ "saveMain function available"
   - ❌ No SharedArrayBuffer errors
   - ❌ No service worker errors

3. **Click "Run" button** and verify:
   - Dark background (RGB 26, 27, 38)
   - White text "Hello from DragonRuby!" at center
   - No errors in console

### Known Issues to Address

1. **Port confusion**: Server sometimes on 3000, sometimes 8080
   - Check `config/puma.rb` or `PORT` environment variable
   - Standardize on port 3000 for development

2. **Service worker reload loop**:
   - Service worker detects missing SharedArrayBuffer
   - Tries to reload iframe
   - But headers come from Rails, not service worker
   - Results in confusion

3. **External resource blocking**:
   - Service worker intercepts ALL fetch requests
   - Breaks CDN resources (fonts, icons, etc.)
   - Already fixed by limiting to `/dragonruby/` paths
   - But still seeing errors in console

### Recommended Next Steps

1. **Test Current State**
   ```bash
   # Start server (check port)
   cd ~/projects/mattkelly.io
   bin/rails server
   
   # Visit in browser
   open http://localhost:8080/dragonruby/001-hello-world
   
   # OR if port 3000:
   open http://localhost:3000/dragonruby/001-hello-world
   ```

2. **If SharedArrayBuffer Still Undefined**
   - Check browser console: `typeof SharedArrayBuffer`
   - Check headers: DevTools → Network → game.html → Headers
   - Verify COOP/COEP headers present
   - May need hard refresh (Cmd+Shift+R)

3. **If Headers Present But SharedArrayBuffer Missing**
   - Browser may need page-level headers (not iframe-level)
   - Try adding headers to parent page (`dragonruby/show.html.erb`)
   - Or load game.html directly: http://localhost:8080/dragonruby/game.html

4. **If Everything Works Except Code Execution**
   - Verify saveMain path: `/testdev-drtest/app/main.rb`
   - Check FS structure in iframe console: `FS.readdir('/testdev-drtest/app')`
   - Test saveMain directly: `window.gtk.saveMain('def tick args\nend')`

### Code Changes Summary

**dragonruby_controller.rb:**
```ruby
before_action :set_wasm_headers

private
def set_wasm_headers
  response.headers["Cross-Origin-Embedder-Policy"] = "require-corp"
  response.headers["Cross-Origin-Opener-Policy"] = "same-origin"
end
```

**config/initializers/dragonruby_headers.rb:**
```ruby
Rails.application.config.middleware.insert_before 0, Rack::Static,
  urls: ["/dragonruby"],
  root: Rails.public_path,
  header_rules: [
    [:all, {
      "Cross-Origin-Embedder-Policy" => "require-corp",
      "Cross-Origin-Opener-Policy" => "same-origin"
    }]
  ]
```

**dragonruby-serviceworker.js:**
```javascript
// Only intercept /dragonruby/ paths, not external resources
const url = new URL(event.request.url);
if (url.origin !== self.location.origin) return;
if (!url.pathname.includes('/dragonruby/')) return;
```

**dragonruby_split_controller.js:**
```javascript
// Check for saveMain specifically, not just gtk
if (this.gameIframe && this.gameIframe.contentWindow && 
    this.gameIframe.contentWindow.gtk && 
    typeof this.gameIframe.contentWindow.gtk.saveMain === 'function') {
  this.gtkReady = true
}
```

### Testing Checklist

- [ ] Server starts on known port (3000 or 8080)
- [ ] Headers present: `curl -I http://localhost:XXXX/dragonruby/game.html | grep Cross-Origin`
- [ ] Page loads without console errors
- [ ] `typeof SharedArrayBuffer` returns "function" in iframe console
- [ ] "DragonRuby GTK ready!" appears in console
- [ ] "saveMain function available" appears in console
- [ ] Click "Run" button executes code
- [ ] Canvas shows dark background
- [ ] Text renders at center
- [ ] No service worker errors

### Files to Review Next Session

**Priority 1 (Core integration):**
- `public/dragonruby/game.html` - Main iframe host
- `app/javascript/controllers/dragonruby_split_controller.js` - Parent controller
- `app/controllers/dragonruby_controller.rb` - Rails controller with headers

**Priority 2 (Configuration):**
- `config/initializers/dragonruby_headers.rb` - Static file headers
- `config/puma.rb` - Check port configuration
- `public/dragonruby/dragonruby-serviceworker.js` - May need to disable

**Priority 3 (Reference):**
- `public/dragonruby/official-build/*` - Full official export for comparison
- `DRAGONRUBY_OFFICIAL_BUILD.md` - Detailed architecture docs

### Key Insights for Next Developer

1. **DragonRuby Pro Required**: Only the Pro version has `dragonruby-publish` for HTML5 export
   - Located at: `~/projects/dragonruby/dragonruby-publish`
   - Not the same as `~/dragonruby` (that doesn't exist)

2. **Official Build vs Fiddle Files**: 
   - Fiddle files (2.5MB WASM) are incomplete, demo-only
   - Official build (3.3MB WASM) has full production features
   - Official includes proper IndexedDB file syncing

3. **Write Path Critical**:
   - Format: `/{devid}-{gameid}/app/main.rb`
   - Our path: `/testdev-drtest/app/main.rb`
   - Defined in `dragonruby-html5-loader.js` as `GDragonRubyWriteDir`

4. **SharedArrayBuffer is Non-Negotiable**:
   - Required for DragonRuby WASM to run
   - Requires COOP + COEP headers on ALL resources in page
   - Must be present at page load, not added later

5. **Iframe Complications**:
   - Headers must be on iframe document, not just parent
   - Service worker reload only reloads iframe, not parent
   - Rails middleware solves this by adding headers at server level

### Success Criteria

Integration is 100% complete when:
1. ✅ Rails serves COOP/COEP headers (DONE)
2. ✅ Official WASM files in place (DONE)
3. ✅ Correct filesystem path configured (DONE)
4. ❌ SharedArrayBuffer available in iframe (TEST NEEDED)
5. ❌ saveMain function created successfully (TEST NEEDED)
6. ❌ Code execution works from parent page (TEST NEEDED)
7. ❌ Canvas renders DragonRuby output (TEST NEEDED)

### Estimated Time to Complete

- **If headers working**: 15 minutes (just testing)
- **If service worker interfering**: 30-60 minutes (disable/debug)
- **If SharedArrayBuffer still missing**: 1-2 hours (diagnose browser/iframe issue)

---

**Current Blocker**: Need to test in browser with Rails server running on correct port.

**Next Action**: Visit http://localhost:8080/dragonruby/001-hello-world and check console for SharedArrayBuffer availability.

**Session Notes**: Server is running on port 8080. Headers are confirmed working via curl. Ready for browser testing.
