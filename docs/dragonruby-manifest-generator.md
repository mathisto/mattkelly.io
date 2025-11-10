
# DragonRuby Manifest Generator

The DragonRuby WASM build requires a complete manifest.json that lists all files in the gamedata directory.

## Why This Is Needed

The DragonRuby HTML5 loader fetches `manifest.json` from the root `/dragonruby/` directory, then uses it to download files from `gamedata/` into the virtual filesystem (IndexedDB cache). If files are missing from the manifest, they won't be loaded and sprites will show as the checkerboard "missing texture" pattern.

## Critical Manifest Format

The manifest MUST use these exact field names:
- `filesize` - NOT "size" (WASM loader reads xhr.filesize)
- `filetime` - NOT "timestamp" (WASM loader reads xhr.filetime)

Example correct entry:
```json
{
  "sprites/square/blue.png": {
    "filesize": 329,
    "filetime": 1761338437
  }
}
```

## Regenerating the Manifest

Run this script whenever you add, remove, or modify files in `public/dragonruby/gamedata/`:

```bash
ruby script/generate_dragonruby_manifest.rb
```

This will scan all files in `gamedata/` and generate a complete `manifest.json` with the correct format.

## Cache Busting

After updating the manifest, you must force a fresh download since the WASM loader caches files in IndexedDB:

**Option 1:** Bump the database version in `dragonruby-html5-loader.js`:
```javascript
var GDragonRubyGameId = 'drtest-v3';  // Increment version number
```

**Option 2:** Clear IndexedDB manually in browser DevTools:
1. Open DevTools (F12)
2. Application tab → Storage → IndexedDB
3. Delete the `drtest` (or `drtest-v2`, etc.) database
4. Hard refresh (Cmd+Shift+R)

**Option 3:** Hard refresh with cache clear:
- Chrome: Cmd+Shift+R (Mac) or Ctrl+Shift+F5 (Windows)
- Or DevTools → Network tab → "Disable cache" (keep DevTools open)

