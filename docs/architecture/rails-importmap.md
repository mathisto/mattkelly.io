# Rails Importmap Deep Dive

Understanding JavaScript management in Rails 8 without a build step.

## What is Importmap?

Rails 7+ uses **importmap-rails** by default instead of Webpack/esbuild/rollup. This fundamental shift means:

- **NO build step** - JavaScript files served directly from `app/javascript/`
- **NO Node.js required** - Uses browser-native ES6 module imports
- **NO bundling** - Each file is a separate HTTP request (HTTP/2 makes this fine)
- **Automatic digests** - Rails adds content-based hashes to URLs for cache busting

## How It Works

### 1. File Mapping

Files in `app/javascript/` are mapped to URL paths in `config/importmap.rb`:

```ruby
pin "application", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers", preload: true
pin_all_from "app/javascript/lib", under: "lib", preload: false
```

### 2. Browser Import Map

Rails generates `<script type="importmap">` tags with JSON mappings:

```json
{
  "imports": {
    "application": "/assets/application-abc123.js",
    "controllers/terminal": "/assets/controllers/terminal-def456.js",
    "lib/filesystem_service": "/assets/lib/filesystem_service-ghi789.js"
  }
}
```

### 3. Native ES6 Imports

Browser natively imports modules using these mappings:

```javascript
import { Application } from "@hotwired/stimulus"
import filesystemService from "lib/filesystem_service"
import commands from "lib/commands"
```

## Configuration

### Key Configuration Options

**`pin_all_from`**: Automatically maps ALL files in a directory

```ruby
pin_all_from "app/javascript/lib", under: "lib", preload: false
```

- `under: "lib"` - Files imported as `lib/filename` (no extension)
- `preload: true` - Adds `<link rel="modulepreload">` for faster loading
- File extensions (.js) are **omitted** in import statements

### Adding External Packages

```bash
# Download and pin a package
bin/importmap pin package-name

# This downloads to vendor/javascript/ and updates config/importmap.rb
```

## Import Syntax Rules

### ✅ Correct

```javascript
// Use importmap alias, no extension
import filesystemService from "lib/filesystem_service"
import commandParser from "lib/command_parser"
import commands from "lib/commands"
```

### ❌ Wrong

```javascript
// Don't use relative paths or extensions
import filesystemService from "../lib/filesystem_service.js"
import commandParser from "./lib/command_parser.js"
```

## Browser Caching Gotchas

### The Problem

**Common scenario**:
1. Change JavaScript file content
2. Rails serves updated file with **same digest** (if content appears identical to digest algorithm)
3. Browser caches the old version
4. Hard refresh required to see changes

### Why This Happens

- Importmap uses **content-based digests** - identical content = same hash
- Browser aggressively caches JavaScript modules
- Standard refresh (F5) doesn't bypass module cache
- DevTools "Disable cache" only works when DevTools is **open**

### Solutions

1. **Hard Refresh**: `Cmd+Shift+R` (Mac) or `Ctrl+Shift+F5` (Windows)
2. **DevTools Cache Disable**:
   - Open DevTools (F12)
   - Network tab → Check "Disable cache"
   - Keep DevTools open while developing
3. **Clear Cache**: DevTools → Right-click refresh → "Empty Cache and Hard Reload"
4. **Rails Cache Clear**: `bin/rails tmp:clear` (rarely needed)

### Development Workflow

**Best practices**:
- Keep browser DevTools open with "Disable cache" checked
- Or get in habit of `Cmd+Shift+R` instead of `Cmd+R`
- Check console for version logging during development
- Add version logs to verify code updates:

```javascript
console.log('[Terminal] Version 2024-01-23-v2')
```

## UMD Libraries vs ES Modules

### The Problem

Some libraries (like Filer.js) are UMD bundles, incompatible with importmap/ES modules.

### Solution: Script Tag + Global

Load via CDN script tag in HTML, access as global:

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

## File Structure

### Recommended Organization

```
app/javascript/
├── application.js              # Entry point
├── controllers/                # Stimulus controllers
│   ├── interactive_terminal_controller.js
│   ├── github_heatmap_controller.js
│   └── ...
└── lib/                        # Utility libraries
    ├── filesystem_service.js
    ├── command_parser.js
    └── commands/
        ├── index.js            # Barrel export
        ├── ls.js
        ├── cat.js
        └── ...
```

### Barrel Exports

Use `index.js` to export multiple modules:

```javascript
// lib/commands/index.js
import ls from "lib/commands/ls"
import cat from "lib/commands/cat"
import cd from "lib/commands/cd"

export default {
  ls,
  cat,
  cd
}
```

Then import all at once:

```javascript
import commands from "lib/commands"

// Use as: commands.ls(), commands.cat(), etc.
```

## Common Pitfalls

### 1. Using Relative Imports

❌ **Don't**:
```javascript
import x from "../lib/file.js"
```

✅ **Do**:
```javascript
import x from "lib/file"
```

### 2. Including .js Extensions

❌ **Don't**:
```javascript
import x from "lib/file.js"
```

✅ **Do**:
```javascript
import x from "lib/file"
```

### 3. Assuming Refresh Shows Changes

❌ **Don't**: Press F5 and expect to see JavaScript changes

✅ **Do**: Hard refresh (`Cmd+Shift+R`) or keep DevTools cache disabled

### 4. Trying to Importmap UMD Libraries

❌ **Don't**: Try to pin and import UMD bundles

✅ **Do**: Use `<script>` tag and access as `window.LibraryName`

## Performance Considerations

### HTTP/2 Advantage

- Multiple files = multiple HTTP requests
- HTTP/2 multiplexes requests over single connection
- Parallel downloads, minimal overhead
- Often faster than bundling!

### Preloading

```ruby
# Preload critical modules
pin "application", preload: true
pin "@hotwired/stimulus", preload: true
```

Generates:
```html
<link rel="modulepreload" href="/assets/application-abc123.js">
```

Browser downloads modules before they're requested.

### Code Splitting

No need for complex webpack configurations:
- Each file is naturally code-split
- Lazy load with dynamic imports:

```javascript
// Load command on first use
const ls = await import("lib/commands/ls")
```

## Debugging

### Check Import Map

View generated import map in browser DevTools:
1. Open DevTools → Sources
2. Look for `<script type="importmap">`
3. Verify your modules are mapped correctly

### Network Tab

Check if modules are loading:
1. DevTools → Network
2. Filter by JS
3. Look for files with digest hashes
4. Check response status (200 = good, 304 = cached)

### Console Errors

Common errors:

```
Failed to resolve module specifier "lib/file"
```
→ File not pinned in importmap.rb

```
Unexpected token 'export'
```
→ Trying to load UMD module as ES module

## Migration from Webpack

If migrating from webpack-based Rails app:

1. Remove webpacker gem
2. Add importmap-rails gem
3. Run `bin/importmap install`
4. Update import statements (remove extensions, use aliases)
5. Pin external packages with `bin/importmap pin`
6. Load UMD libraries via script tags

## Advantages

- **Simplicity**: No build configuration
- **Speed**: No compilation during development
- **Transparency**: See exactly what browser loads
- **Standards**: Uses web platform features
- **Debugging**: Source maps not needed (serving actual source)

## Trade-offs

- **No TypeScript**: Without adding build step
- **No JSX**: React/Vue need compilation
- **Library compatibility**: Some libraries only available as UMD
- **More requests**: Could be issue on HTTP/1.1 connections

## Best Practices

1. **Organize by feature**: Group related modules together
2. **Use barrel exports**: Simplify imports with index.js files
3. **Disable cache in DevTools**: While actively developing
4. **Version your modules**: Add console.log for cache debugging
5. **Prefer ES modules**: Choose libraries with ES module support
6. **Document UMD exceptions**: When you must use script tags

## Resources

- [Importmap Rails GitHub](https://github.com/rails/importmap-rails)
- [Browser Import Maps Spec](https://github.com/WICG/import-maps)
- [Rails Guide: Asset Pipeline](https://guides.rubyonrails.org/asset_pipeline.html)
