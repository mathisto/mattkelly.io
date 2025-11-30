# DragonRuby WASM Files

Place your DragonRuby WASM files here:

## Required Files:
- `dragonruby.wasm` - The WebAssembly binary
- `dragonruby.js` - JavaScript loader
- `dragonruby.data` - Data file (if exists)

## Where to Get Them:
From your DragonRuby GTK installation, look in:
- `/samples/wasm/`
- `/html5/` or `/web/`
- `/builds/wasm/`
- `/samples/html5_helloworld/`

## Current Status:
Files not yet added - editor will show preview mode until WASM is available.

## Integration Notes:
The Stimulus controller expects:
- Files served from `/dragonruby/*` path
- Standard DragonRuby WASM API (init, eval, start methods)
- Canvas element with 1280x720 resolution
