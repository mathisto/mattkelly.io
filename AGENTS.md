# mattkelly.io - AI Agent Instructions

> **📚 Full Documentation**: Visit `/docs` in development mode for comprehensive wiki-style documentation organized by topic.

## Project Overview
Personal portfolio website built with Rails 8, ViewComponent architecture, and Stimulus controllers. Features include blog, projects showcase, GitHub heatmap integration, and an interactive browser-based terminal emulator.

## Documentation Structure

This file provides quick reference for AI agents. For comprehensive documentation:

- **Development Wiki**: Available at `http://localhost:3000/docs` (development only)
- **Getting Started**: `docs/getting-started/` - Setup and overview
- **Architecture**: `docs/architecture/` - Tech stack and patterns
- **Features**: `docs/features/` - Terminal, DragonRuby, blog system
- **Guides**: `docs/guides/` - How-to guides and debugging
- **Planning**: `docs/planning/` - Specs, todos, and session notes
- **Contributing**: `docs/contributing/agents-guide.md` - This file

## Tech Stack
- **Backend**: Ruby on Rails 8.0.2
- **Frontend**: Hotwire (Turbo + Stimulus), ViewComponents
- **JavaScript**: ES6 modules via importmap-rails (NO build step, NO Node.js required)
- **Styling**: Tailwind CSS with Tokyo Night theme
- **Database**: SQLite with SolidQueue for background jobs
- **Testing**: RSpec with system tests

## Critical Lessons Learned

### JavaScript Module Management with Importmap-Rails

#### What is Importmap?
Rails 7+ uses **importmap-rails** by default instead of Webpack/esbuild/rollup. This means:
- **NO build step** - JavaScript files are served directly from `app/javascript/`
- **NO Node.js required** - Uses browser-native ES6 module imports
- **NO bundling** - Each file is a separate HTTP request (with HTTP/2 this is fine)
- **Automatic digests** - Rails adds content-based hashes to URLs for cache busting

#### How It Works
1. Files in `app/javascript/` are mapped to URL paths in `config/importmap.rb`
2. Rails generates `<script type="importmap">` tags with JSON mappings
3. Browser natively imports modules using these mappings
4. Rails automatically adds digest hashes (e.g., `controller-abc123.js`) based on file content

#### Configuration (`config/importmap.rb`)
```ruby
pin "application", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers", preload: true
pin_all_from "app/javascript/lib", under: "lib", preload: false
```

**Key Points**:
- `pin_all_from` automatically maps ALL files in a directory
- `under: "lib"` means files are imported as `lib/filename` (no extension)
- `preload: true` adds `<link rel="modulepreload">` for faster loading
- File extensions (.js) are **omitted** in import statements

#### Import Syntax
```javascript
// CORRECT - no file extension, uses importmap alias
import filesystemService from "lib/filesystem_service"
import commandParser from "lib/command_parser"
import commands from "lib/commands"

// WRONG - don't use relative paths or extensions with importmap
import filesystemService from "../lib/filesystem_service.js"
```

#### Browser Caching Gotchas

**The Problem We Hit:**
1. Changed JavaScript file content
2. Rails server served updated file with **same digest** (130b20be)
3. Browser cached the old version
4. Hard refresh required to see changes

**Why This Happened:**
- Importmap uses **content-based digests** - if content appears identical (to Ruby's digest algorithm), hash stays same
- Browser aggressively caches JavaScript modules
- Standard refresh (F5) doesn't bypass module cache
- DevTools "Disable cache" only works when DevTools is **open**

**Solutions:**
1. **Hard Refresh**: Cmd+Shift+R (Mac) or Ctrl+Shift+F5 (Windows)
2. **DevTools Cache Disable**: 
   - Open DevTools (F12)
   - Network tab → Check "Disable cache"
   - Keep DevTools open while developing
3. **Clear Cache**: DevTools → Right-click refresh → "Empty Cache and Hard Reload"
4. **Rails Cache Clear**: `bin/rails tmp:clear` (though usually not needed)

**Development Workflow:**
- Keep browser DevTools open with "Disable cache" checked
- Or get in habit of Cmd+Shift+R instead of Cmd+R
- Check console for version logging during development

### UMD Libraries vs ES Modules

**Problem**: Filer.js is a UMD bundle, incompatible with importmap/ES modules

**Solution**: Load via CDN script tag in HTML, access as global `window.Filer`

```html
<!-- In layout file -->
<script src="https://cdn.jsdelivr.net/npm/filer@1.4.1/dist/filer.min.js"></script>
```

```javascript
// In JavaScript - access as global
const Filer = window.Filer
const fs = new Filer.FileSystem()
```

**Rule**: If library is UMD/CommonJS and not available as ES module, use script tag + global access.

### Stimulus Controller Patterns

#### State Management
**Problem**: Using DOM (`textContent`) as source of truth causes issues when rendering HTML (like cursor spans)

**Solution**: Store state separately from rendered output

```javascript
// BAD - DOM is source of truth
getCurrentInput() {
  return this.inputTarget.textContent || ""  // Breaks with HTML inside
}

// GOOD - Separate state variable
connect() {
  this.inputText = ""  // Pure text state
}

getCurrentInput() {
  return this.inputText || ""  // Always returns clean text
}

setInput(text) {
  this.inputText = text  // Update state
  // Render with HTML decorations
  this.inputTarget.innerHTML = /* render with cursor span */
}
```

#### Rendering Order Matters
**Problem**: Cursor appeared at wrong position after typing

**Solution**: Update state/position BEFORE rendering

```javascript
// BAD - increment after render
this.setInput(newInput)
this.cursorPosition++  // Renders with old position!

// GOOD - increment before render  
this.cursorPosition++
this.setInput(newInput)  // Renders with new position
```

#### Scroll Management
**Problem**: Tried to scroll `this.element` (container) instead of scrollable child

**Solution**: Scroll the element that has `overflow-y: auto`

```javascript
// BAD - scrolling wrong element
appendOutput(html) {
  this.outputTarget.appendChild(line)
  this.element.scrollTop = this.element.scrollHeight  // Container doesn't scroll!
}

// GOOD - scroll the output div
appendOutput(html) {
  this.outputTarget.appendChild(line)
  requestAnimationFrame(() => {
    this.outputTarget.scrollTop = this.outputTarget.scrollHeight
  })
}
```

**Why `requestAnimationFrame`?** Ensures scroll happens after DOM update completes.

### CSS Cursor Implementation

**Evolution of Cursor Design:**

1. **First Attempt**: Empty span with width
```css
.cursor {
  width: 8px;  /* Takes up space, pushes text aside! */
  background: #bb9af7;
}
```
**Problem**: Cursor pushes characters to the right

2. **Second Attempt**: Zero-width border
```css
.cursor {
  width: 0;
  border-left: 2px solid #bb9af7;
}
```
**Problem**: Cursor appears between characters, not on them

3. **Final Solution**: Transparent overlay
```css
.cursor {
  display: inline;
  background: rgba(187, 154, 247, 0.4);  /* Semi-transparent */
  animation: blink 1.5s ease-in-out infinite;
}

.cursor:empty::before {
  content: '\00a0';  /* Non-breaking space when at end of line */
}
```

```javascript
setInput(text) {
  const beforeCursor = text.slice(0, this.cursorPosition)
  const charAtCursor = text.charAt(this.cursorPosition) || ' '
  const afterCursor = text.slice(this.cursorPosition + 1)  // Skip wrapped char
  
  this.inputTarget.innerHTML = 
    beforeCursor + 
    '<span class="cursor">' + charAtCursor + '</span>' +  // Wrap current char
    afterCursor
}
```

**Key Insight**: Don't insert cursor, **wrap** the character at cursor position.

## File Structure

### JavaScript Organization
```
app/javascript/
├── application.js                    # Entry point
├── controllers/
│   ├── interactive_terminal_controller.js  # Main terminal controller
│   ├── github_heatmap_controller.js
│   ├── glitch_controller.js
│   └── ...
└── lib/
    ├── filesystem_service.js         # Filer.js wrapper
    ├── command_parser.js             # Command execution engine
    └── commands/
        ├── index.js                  # Exports all commands
        ├── ls.js
        ├── cat.js
        ├── cd.js
        ├── pwd.js
        ├── clear.js
        ├── help.js
        └── whoami.js
```

### Import Pattern in `lib/commands/index.js`
```javascript
import ls from "lib/commands/ls"
import cat from "lib/commands/cat"
import cd from "lib/commands/cd"
// ... etc

export default {
  ls,
  cat,
  cd,
  // ... etc
}
```

## Development Workflow

### Starting Development
```bash
bin/rails server        # Importmap serves files directly, no build needed
```

### Making JavaScript Changes
1. Edit file in `app/javascript/`
2. **Hard refresh** browser (Cmd+Shift+R) or keep DevTools cache disabled
3. Check console for errors
4. No restart needed - files served directly

### Adding New npm Packages
```bash
bin/importmap pin package-name
```

This downloads the package to `vendor/javascript/` and updates `config/importmap.rb`.

**Exception**: UMD-only packages - use CDN script tag instead.

### Testing
```bash
bundle exec rspec                    # All tests
bundle exec rspec spec/system/       # System tests (terminal functionality)
```

## Common Pitfalls to Avoid

1. ❌ **Don't use relative imports**: `import x from "../lib/file.js"`
   ✅ **Use importmap aliases**: `import x from "lib/file"`

2. ❌ **Don't include .js extensions** in imports with importmap
   ✅ **Omit extensions**: Rails handles mapping

3. ❌ **Don't assume refresh shows changes**
   ✅ **Hard refresh or disable cache** in DevTools

4. ❌ **Don't use DOM as state storage** when rendering HTML
   ✅ **Separate state variables** from rendered output

5. ❌ **Don't update UI then update position**
   ✅ **Update position/state THEN render**

6. ❌ **Don't try to importmap UMD libraries**
   ✅ **Use script tag + window.LibraryName**

## Architecture Decisions

### Why Importmap vs Bundler?
- **Simplicity**: No build step, no Node.js dependency
- **Speed**: No compilation during development
- **Modern**: Uses browser-native ES6 modules
- **Rails Default**: Works out of the box with Rails 7+

**Trade-offs**:
- Can't use TypeScript/JSX without build step
- Some libraries not available as ES modules
- More HTTP requests (mitigated by HTTP/2)

### Why ViewComponent?
- Testable components with RSpec
- Ruby-based (no separate templating language)
- Preview system for component development
- Better than partials for complex UI

### Why Stimulus over React/Vue?
- Server-rendered HTML (fast initial load)
- Progressive enhancement
- Less JavaScript to ship
- Integrates perfectly with Rails/Turbo

## Quick Reference

### Add New Terminal Command
1. Create `app/javascript/lib/commands/mycommand.js`
2. Export handler function that takes `(args, context)`
3. Import in `app/javascript/lib/commands/index.js`
4. Add to export object
5. Hard refresh browser

### Debug JavaScript Issues
1. Check browser console for errors
2. Verify importmap loaded: Check Network tab for `application-*.js`
3. Check if cache issue: Hard refresh (Cmd+Shift+R)
4. Add `console.log()` for debugging (will be in controller files directly)
5. Check `config/importmap.rb` for correct pin paths

### Routes
- `/terminal-test` - Standalone terminal test page
- `/` - Home with hero terminal (when integrated)
- `/blog` - Blog index
- `/blog/:slug` - Individual posts

## External Dependencies

### Via Importmap
- `@hotwired/stimulus`
- `@hotwired/turbo-rails`

### Via CDN Script Tag
- `filer.js` - Browser filesystem (UMD bundle)

### Ruby Gems (see Gemfile)
- `importmap-rails` - JavaScript module management
- `stimulus-rails` - Stimulus integration
- `turbo-rails` - Hotwire Turbo
- `view_component` - Component architecture
- Many others (see Gemfile for full list)

## Performance Considerations

### Terminal Rendering
- Use `requestAnimationFrame` for scroll operations
- Minimize DOM manipulation - update once per keystroke
- Use `innerHTML` for complex rendering (cursor + text)
- Store state separately from rendered DOM

### Filesystem (Filer.js)
- Uses IndexedDB (async) - always await operations
- Cache filesystem instance after init
- Pre-populate on first init only (check flag)
- Files persist across page reloads

## Code Style

### JavaScript
- ES6+ syntax (classes, arrow functions, async/await)
- No semicolons (Rails/Ruby style)
- 2-space indentation
- Descriptive variable names
- Console logging prefixed with `[ComponentName]`

### Ruby
- Follow Rubocop rules (`.rubocop.yml`)
- 2-space indentation
- Prefer `do...end` over `{...}` for multi-line blocks

### CSS
- Tokyo Night color palette (see theme config)
- BEM-style class names for components
- Utility classes from Tailwind
- Component-specific styles in ViewComponent CSS

## Resources

### Documentation
- [Rails Importmap Guide](https://github.com/rails/importmap-rails)
- [Stimulus Handbook](https://stimulus.hotwired.dev/handbook/introduction)
- [ViewComponent Guide](https://viewcomponent.org/)
- [Filer.js API](https://github.com/filerjs/filer)

### Project Docs
- **Documentation Wiki** - Visit `/docs` in development (comprehensive, organized)
- `docs/contributing/agents-guide.md` - Full copy of this file
- `docs/planning/sessions/` - Implementation session notes
- This file (`AGENTS.md`) - Quick reference for AI agents

## Documentation Wiki (Development Only)

A comprehensive, wiki-style documentation system is available at `/docs` when running in development mode:

```bash
bin/dev
# Visit http://localhost:3000/docs
```

The wiki organizes all project documentation into searchable, cross-linked pages:
- Getting started guides
- Architecture deep-dives
- Feature documentation
- Implementation guides
- Planning documents
- Session notes

**Note**: The `/docs` route is automatically disabled in production for security.
