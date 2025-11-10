# DragonRuby Fiddle - Quick Start

## 🎯 Current Status
✅ **Ready for WASM files** - Everything else is complete!

## 📥 What You Need to Add

Copy these 2-3 files from DragonRuby GTK to `public/dragonruby/`:
```
dragonruby.wasm    # Required
dragonruby.js      # Required
dragonruby.data    # Optional (if exists)
```

**Where to find them:** Look in DragonRuby GTK for folders named:
- `samples/wasm/`
- `html5/` or `web/`
- `builds/wasm/`

## 🚀 Test It

1. **Before WASM** (current):
   - Visit: http://localhost:3000/dragonruby/001-hello-world
   - See: Ruby syntax highlighted in Tokyo Night colors
   - Run button: Shows preview mode

2. **After WASM** (next):
   - Same URL
   - Run button: Executes DragonRuby code
   - See: Game running in canvas

## 🎨 What's Working Now

✅ Ruby syntax highlighting (purple keywords, green strings)
✅ Tokyo Night theme throughout editor
✅ 50/50 split pane (resizable)
✅ Run/Reset buttons (UI functional)
✅ Literate programming (tutorials as comments)
✅ Keyboard shortcuts (Cmd+Enter to run)

## 📝 Files Changed

**Modified:**
- `app/javascript/controllers/dragonruby_split_controller.js` - Added Ruby syntax + WASM prep
- `app/views/dragonruby/show.html.erb` - Cleaned duplicates
- `config/importmap.rb` - Added Ruby language support
- `.gitignore` - Excluded WASM binaries

**Created:**
- `public/dragonruby/` directory with README
- `DRAGONRUBY_INTEGRATION.md` - Full guide
- `DRAGONRUBY_STATUS.md` - Detailed status
- This file

## 🐛 If Something Breaks

**Hard refresh:** Cmd+Shift+R (Mac) or Ctrl+Shift+F5 (Windows)

**Check console for:**
- "CodeMirror 6 initialized with Ruby syntax" ✅
- "DragonRuby WASM not found" ℹ️ (expected until files added)

## 📚 Full Documentation

See `DRAGONRUBY_INTEGRATION.md` for complete integration guide.
