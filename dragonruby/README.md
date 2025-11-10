# DragonRuby Tutorials

Welcome to the DragonRuby Interactive Fiddle! This directory contains all the tutorial files for learning game development with DragonRuby Game Toolkit.

## Current Status

**Phase 1 Complete:** ✅ Project Setup & Infrastructure
- Routes configured for `/dragonruby` and `/dragonruby/:slug`
- DragonrubyController with index and show actions
- Tutorial model for parsing markdown files
- Split-pane UI with editor and canvas areas
- Navigation link added to main site
- 5 starter tutorials created (001-005)
- Full test coverage with RSpec

## Available Tutorials

### Module 1: Getting Started (001-010) ✅ COMPLETE
1. ✅ **001-hello-world.md** - Display your first message
2. ✅ **002-tick-method.md** - Understanding the 60 FPS game loop
3. ✅ **003-coordinate-system.md** - X, Y positioning and screen coordinates
4. ✅ **004-rendering-labels.md** - Text rendering with sizes and alignment
5. ✅ **005-colors.md** - RGB colors and alpha transparency
6. ✅ **006-sprites.md** - Loading and rendering your first sprite
7. ✅ **007-sprite-positioning.md** - Sprite placement and scaling techniques
8. ✅ **008-args-state.md** - Introduction to game state management
9. ✅ **009-initialization.md** - Using ||= for clean initialization
10. ✅ **010-debugging.md** - Debugging with puts and console

### Module 2: Input Basics (011-018) ✅ COMPLETE
11. ✅ **011-keyboard-input.md** - Reading keyboard input
12. ✅ **012-key-states.md** - Key down vs key held
13. ✅ **013-arrow-movement.md** - Moving sprites with arrow keys
14. ✅ **014-wasd-movement.md** - WASD movement controls
15. ✅ **015-mouse-input.md** - Mouse position and click detection
16. ✅ **016-buttons.md** - Creating clickable buttons
17. ✅ **017-gamepad-input.md** - Reading gamepad/controller input
18. ✅ **018-menu-system.md** - Building a simple menu system

**Progress: 18/100 tutorials (18%)**

## Tutorial Structure

Each tutorial is a markdown file with YAML frontmatter containing metadata and Ruby code blocks for interactive learning.

### Frontmatter Fields

- `title`: Tutorial title
- `description`: Short description
- `difficulty`: beginner | intermediate | advanced
- `category`: Module category (basics, rendering, input, physics, etc.)
- `order`: Numeric order for sorting
- `estimated_time`: Estimated completion time
- `tags`: Array of relevant tags
- `author`: Tutorial author
- `date`: Publication date
- `status`: published | draft | archived
- `dragonruby_version`: Minimum DragonRuby version

### Code Block Types

- ````ruby` - Standard code example
- ````ruby:starter` - Initial code loaded in editor
- ````ruby:solution` - Hidden solution code
- ````ruby:readonly` - Display-only code example

## Next Steps

**Phase 2:** Markdown Tutorial System
- Continue creating tutorials (006-050)
- Add tutorial categories and filtering
- Implement search functionality

**Phase 3-4:** Editor Integration  
- Integrate Monaco Editor with Ruby syntax highlighting
- Apply Tokyo Night theme to editor
- Add keyboard shortcuts (Ctrl+Enter to run)

**Phase 5:** DragonRuby WASM Runtime
- Obtain DragonRuby HTML5/WASM files
- Implement code execution pipeline
- Display game canvas output

## Tutorial Curriculum

See `/dragonruby.md` in the project root for the full 100-lesson curriculum plan.

## Contributing

To add a new tutorial:

1. Create a new `.md` file with format: `###-tutorial-name.md`
2. Follow the template structure in existing tutorials
3. Include appropriate frontmatter with all required fields
4. Add interactive code blocks with proper types (:starter, :solution, :readonly)
5. Test tutorial loads correctly at `/dragonruby`
