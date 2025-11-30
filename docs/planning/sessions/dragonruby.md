# DragonRuby Interactive Fiddle - Implementation Plan

**Project Goal:** Create a beautiful, Tokyo Night-themed DragonRuby tutorial and REPL environment integrated into mattkelly.io, featuring split-pane editor, instant hot-reload, and comprehensive tutorials.

**Status:** Planning Phase  
**Started:** 2024-10-23  
**Last Updated:** 2024-10-23

---

## 📋 Table of Contents
- [Implementation Phases](#implementation-phases)
- [Tutorial Curriculum (100 Lessons)](#tutorial-curriculum)
- [Technical Architecture](#technical-architecture)
- [Design Decisions](#design-decisions)

---

## 🎯 Implementation Phases

### Phase 1: Project Setup & Infrastructure ⬜ NOT STARTED
- [ ] Create `/dragonruby` route in `config/routes.rb`
- [ ] Create `DragonrubyController` with `index` and `show` actions
- [ ] Create directory structure: `blog/dragonruby/`
- [ ] Create tutorial markdown template
- [ ] Set up basic view layout with Tokyo Night theme
- [ ] Add navigation link in NavComponent

#### Subtasks:
- [ ] Define route: `get "dragonruby", to: "dragonruby#index"`
- [ ] Define route: `get "dragonruby/:slug", to: "dragonruby#show"`
- [ ] Create `app/controllers/dragonruby_controller.rb`
- [ ] Create `app/views/dragonruby/index.html.erb`
- [ ] Create `app/views/dragonruby/show.html.erb`
- [ ] Create `blog/dragonruby/README.md` (tutorial index)
- [ ] Update `app/components/navigation/nav_component.rb` to include DragonRuby link

### Phase 2: Markdown Tutorial System ⬜ NOT STARTED
- [ ] Create Tutorial Parser Service
  - [ ] Parse YAML frontmatter
  - [ ] Extract code blocks (```ruby)
  - [ ] Support special block types (:starter, :solution, :readonly)
  - [ ] Generate tutorial index from directory
  - [ ] Sort tutorials by `order` field
- [ ] Create Tutorial Model/PORO
  - [ ] Properties: title, description, difficulty, category, code, etc.
  - [ ] Validation logic
  - [ ] Slug generation
- [ ] Create first 5 example tutorials (validate format)
  - [ ] 01-hello-world.md
  - [ ] 02-rendering-sprites.md
  - [ ] 03-player-movement.md
  - [ ] 04-basic-animation.md
  - [ ] 05-simple-game.md

#### Subtasks:
- [ ] Create `app/services/tutorial_parser.rb`
- [ ] Create `app/models/tutorial.rb` (PORO, not ActiveRecord)
- [ ] Add tests for parser in `spec/services/tutorial_parser_spec.rb`
- [ ] Create markdown files in `blog/dragonruby/`
- [ ] Test frontmatter extraction
- [ ] Test code block extraction with regex
- [ ] Implement caching strategy (memoization or Rails.cache)

### Phase 3: Split-Pane Interface ⬜ NOT STARTED
- [ ] Design responsive layout (desktop priority, mobile adaptive)
- [ ] Create container with horizontal split
  - [ ] Left pane: Code editor (60% width)
  - [ ] Right pane: Canvas + controls (40% width)
- [ ] Add resizable divider between panes
- [ ] Mobile responsive: Stack vertically on small screens
- [ ] Tokyo Night theme styling for all UI elements

#### Subtasks:
- [ ] Create `app/components/dragonruby/split_pane_component.rb`
- [ ] Create `app/components/dragonruby/editor_pane_component.rb`
- [ ] Create `app/components/dragonruby/canvas_pane_component.rb`
- [ ] Add CSS for split layout in component stylesheets
- [ ] Implement drag handle for resizing
- [ ] Add localStorage to remember pane sizes
- [ ] Test on mobile (320px, 768px, 1024px, 1920px)

### Phase 4: Code Editor Integration ⬜ NOT STARTED
- [ ] Choose editor: Monaco Editor (VS Code's editor)
- [ ] Install Monaco via importmap or CDN
- [ ] Create Stimulus controller: `dragonruby_editor_controller.js`
- [ ] Configure Ruby syntax highlighting
- [ ] Apply Tokyo Night theme to editor
- [ ] Add line numbers
- [ ] Add auto-indent
- [ ] Implement keyboard shortcuts (Ctrl+Enter to run)
- [ ] Add vim/emacs mode toggle (optional)

#### Subtasks:
- [ ] Pin Monaco Editor in `config/importmap.rb` OR add CDN script tag
- [ ] Create `app/javascript/controllers/dragonruby_editor_controller.js`
- [ ] Configure Monaco options (theme, language, etc.)
- [ ] Map Tokyo Night colors to Monaco theme
- [ ] Add "Run Code" button with loading state
- [ ] Add "Reset Code" button to restore tutorial default
- [ ] Implement auto-save to localStorage
- [ ] Add code snippets/autocomplete (nice to have)

### Phase 5: DragonRuby WASM Runtime ⬜ NOT STARTED
- [ ] Obtain DragonRuby HTML5/WASM files
  - [ ] dragonruby-wasm.js
  - [ ] dragonruby-wasm.wasm
  - [ ] dragonruby-html5-loader.js
- [ ] Place WASM files in `public/dragonruby/` directory
- [ ] Create canvas element with proper dimensions (1280x720 or scaled)
- [ ] Create Stimulus controller: `dragonruby_runner_controller.js`
- [ ] Initialize DragonRuby runtime
- [ ] Implement code execution pipeline
- [ ] Handle errors and display in UI
- [ ] Add loading states and error boundaries

#### Subtasks:
- [ ] Create `public/dragonruby/` directory
- [ ] Add WASM files to `.gitignore` if large (document download source)
- [ ] Create `app/javascript/controllers/dragonruby_runner_controller.js`
- [ ] Initialize canvas with proper pixel ratio
- [ ] Create message passing interface to WASM
- [ ] Implement error parser for Ruby errors
- [ ] Add error display component (red text, Tokyo Night theme)
- [ ] Add console output display
- [ ] Implement hot-reload (run on code change)
- [ ] Add FPS counter (optional debugging tool)

### Phase 6: Tutorial Navigation ⬜ NOT STARTED
- [ ] Create sidebar/navigation component
- [ ] Display tutorial list grouped by difficulty/category
- [ ] Implement search/filter functionality
- [ ] Add "Previous" and "Next" tutorial buttons
- [ ] Track completion progress (localStorage)
- [ ] Add breadcrumb navigation
- [ ] Highlight current tutorial

#### Subtasks:
- [ ] Create `app/components/dragonruby/tutorial_nav_component.rb`
- [ ] Create `app/javascript/controllers/tutorial_nav_controller.js`
- [ ] Add search input with live filtering
- [ ] Add category filter dropdown
- [ ] Add difficulty badge styling
- [ ] Implement localStorage progress tracking
- [ ] Add checkmark icons for completed tutorials
- [ ] Add keyboard navigation (arrow keys for next/prev)

### Phase 7: Tutorial Content Rendering ⬜ NOT STARTED
- [ ] Markdown to HTML rendering
- [ ] Syntax highlighting for inline code
- [ ] Render tutorial steps as collapsible sections
- [ ] Add "Try It" buttons for code examples
- [ ] Implement challenge sections
- [ ] Add hint/solution toggle buttons
- [ ] Create table of contents for long tutorials

#### Subtasks:
- [ ] Use Redcarpet or Kramdown for markdown rendering
- [ ] Configure Prism.js for inline code (already in project)
- [ ] Create `app/components/dragonruby/tutorial_content_component.rb`
- [ ] Add collapse/expand icons for sections
- [ ] Add copy-to-editor buttons for code blocks
- [ ] Style challenge sections distinctly
- [ ] Add smooth scroll to ToC links

### Phase 8: Save/Load/Share Features ⬜ NOT STARTED
- [ ] Implement localStorage auto-save
- [ ] Add "Save" button (user-triggered)
- [ ] Add "Load" button (restore from save)
- [ ] Generate shareable URLs with code embedded
- [ ] Add "Copy Link" button
- [ ] Add "Download" button (save as .rb file)
- [ ] Optional: Backend persistence (user accounts)

#### Subtasks:
- [ ] Create localStorage service for code persistence
- [ ] Implement URL encoding/decoding for code
- [ ] Add base64 or URL-safe encoding
- [ ] Create share modal with copy button
- [ ] Add download functionality (Blob + download link)
- [ ] Add "New Session" to reset everything
- [ ] Consider adding backend API for saving (future)

### Phase 9: Polish & UX Refinements ⬜ NOT STARTED
- [ ] Add loading spinners for WASM initialization
- [ ] Add smooth transitions between tutorials
- [ ] Implement keyboard shortcuts overlay (? key)
- [ ] Add tooltips for buttons
- [ ] Mobile responsive testing and fixes
- [ ] Add dark mode toggle (if not Tokyo Night everywhere)
- [ ] Performance optimization (lazy load tutorials)
- [ ] Add analytics/tracking (optional)

#### Subtasks:
- [ ] Create loading component for WASM
- [ ] Add CSS transitions for navigation
- [ ] Create keyboard shortcuts modal
- [ ] Add tooltips with Tippy.js or native CSS
- [ ] Test on iOS Safari, Android Chrome
- [ ] Optimize image loading (if tutorial images added)
- [ ] Add service worker for offline support (nice to have)
- [ ] Add Google Analytics or Plausible (if desired)

### Phase 10: Testing & Documentation ⬜ NOT STARTED
- [ ] Write RSpec tests for Tutorial Parser
- [ ] Write system tests for navigation
- [ ] Write JavaScript tests for Stimulus controllers
- [ ] Create developer documentation
- [ ] Create contributor guide for new tutorials
- [ ] Add README to `blog/dragonruby/`
- [ ] Performance testing (large tutorials)

#### Subtasks:
- [ ] Create `spec/services/tutorial_parser_spec.rb`
- [ ] Create `spec/system/dragonruby_spec.rb`
- [ ] Add JavaScript tests with Jest or similar
- [ ] Document tutorial markdown format
- [ ] Document code editor API
- [ ] Document WASM runtime interface
- [ ] Create CONTRIBUTING.md for tutorial authors
- [ ] Test with 50+ tutorials loaded

---

## 📚 Tutorial Curriculum (100 Lessons)

**Structure:**
- **Lessons 1-50**: Zero-to-Hero Curriculum (Progressive Learning Path)
- **Lessons 51-100**: DragonRuby Official Samples + Unique Challenges

---

### 🎓 **PART 1: ZERO TO HERO (Lessons 1-50)**

#### **Module 1: Getting Started (1-10)**
- [ ] 001: Hello World - Your First DragonRuby Program
- [ ] 002: Understanding the Tick Method and Game Loop
- [ ] 003: The Coordinate System - X, Y, and You
- [ ] 004: Rendering Labels and Text
- [ ] 005: Working with Colors - RGB and Alpha
- [ ] 006: Loading and Rendering Your First Sprite
- [ ] 007: Sprite Positioning and Sizing
- [ ] 008: Introduction to args.state
- [ ] 009: Using ||= for Initialization
- [ ] 010: Debugging with puts and Console

#### **Module 2: Input Basics (11-18)**
- [ ] 011: Reading Keyboard Input
- [ ] 012: Key Down vs Key Held
- [ ] 013: Moving a Sprite with Arrow Keys
- [ ] 014: WASD Movement Controls
- [ ] 015: Mouse Position and Click Detection
- [ ] 016: Creating Clickable Buttons
- [ ] 017: Reading Gamepad Input
- [ ] 018: Building a Simple Menu System

#### **Module 3: Sprites & Animation (19-28)**
- [ ] 019: Rotating Sprites
- [ ] 020: Sprite Transparency and Tinting
- [ ] 021: Flipping Sprites Horizontally and Vertically
- [ ] 022: Understanding Sprite Sheets
- [ ] 023: Creating a Walking Animation
- [ ] 024: Using frame_index for Animation
- [ ] 025: Animation State Machines
- [ ] 026: Idle, Walk, and Run Animations
- [ ] 027: Animated Tiles
- [ ] 028: Screen Shake Effects

#### **Module 4: Collision Detection (29-35)**
- [ ] 029: Rectangle Intersection Detection
- [ ] 030: Circle Collision Detection
- [ ] 031: Point-in-Rectangle Tests
- [ ] 032: Creating Collision Boundaries
- [ ] 033: Collision Response and Bouncing
- [ ] 034: Sliding Along Walls
- [ ] 035: Tile-Based Collision Maps

#### **Module 5: Physics & Movement (36-42)**
- [ ] 036: Gravity and Falling Objects
- [ ] 037: Velocity and Acceleration
- [ ] 038: Friction and Drag
- [ ] 039: Jump Mechanics with Space Bar
- [ ] 040: Projectile Motion
- [ ] 041: Simple Platformer Physics
- [ ] 042: Camera Follow and Smooth Movement

#### **Module 6: Audio & Polish (43-50)**
- [ ] 043: Playing Sound Effects
- [ ] 044: Background Music and Looping
- [ ] 045: Sound Effect Timing and Triggers
- [ ] 046: Fade In and Fade Out Transitions
- [ ] 047: Creating Simple Particles
- [ ] 048: Particle Systems and Emitters
- [ ] 049: Health and Damage Systems
- [ ] 050: High Score and Leaderboards

---

### 🎮 **PART 2: OFFICIAL SAMPLES & CHALLENGES (Lessons 51-100)**

#### **Official DragonRuby Sample Apps (51-90)**

These tutorials are based on the official DragonRuby sample applications. Each lesson explores a complete working example from the DRGTK samples directory.

##### **Category: Rendering & Display (51-58)**
- [ ] 051: Sample - Labels and Typography
- [ ] 052: Sample - Sprites and Images
- [ ] 053: Sample - Primitives (Solids, Borders, Lines)
- [ ] 054: Sample - Render Targets
- [ ] 055: Sample - Camera and Viewport
- [ ] 056: Sample - Sprite Sheets
- [ ] 057: Sample - Sprite Animation
- [ ] 058: Sample - Blending Modes

##### **Category: Input Handling (59-64)**
- [ ] 059: Sample - Keyboard Input
- [ ] 060: Sample - Mouse Input
- [ ] 061: Sample - Controller Input
- [ ] 062: Sample - Touch Input (Mobile)
- [ ] 063: Sample - Drag and Drop
- [ ] 064: Sample - Virtual Joystick

##### **Category: Game Mechanics (65-75)**
- [ ] 065: Sample - Collision Detection
- [ ] 066: Sample - Pathfinding (A*)
- [ ] 067: Sample - Finite State Machines
- [ ] 068: Sample - Timer and Scheduling
- [ ] 069: Sample - Easing Functions
- [ ] 070: Sample - Tweening and Interpolation
- [ ] 071: Sample - Random Number Generation
- [ ] 072: Sample - Serialization and Save Data
- [ ] 073: Sample - Scene Management
- [ ] 074: Sample - Entity Component System
- [ ] 075: Sample - Object Pooling

##### **Category: Level Design (76-82)**
- [ ] 076: Sample - Tilemap Rendering
- [ ] 077: Sample - Procedural Generation
- [ ] 078: Sample - Scrolling Backgrounds
- [ ] 079: Sample - Parallax Scrolling
- [ ] 080: Sample - Level Editor Basics
- [ ] 081: Sample - Loading Levels from JSON
- [ ] 082: Sample - Multi-Layer Maps

##### **Category: Complete Game Examples (83-90)**
- [ ] 083: Sample - Pong Clone
- [ ] 084: Sample - Breakout/Arkanoid
- [ ] 085: Sample - Flappy Bird Clone
- [ ] 086: Sample - Snake Game
- [ ] 087: Sample - Platformer Basics
- [ ] 088: Sample - Top-Down Shooter
- [ ] 089: Sample - Tower Defense
- [ ] 090: Sample - RPG Battle System

#### **Unique Challenge Projects (91-100)**

Advanced projects that combine multiple concepts and push your skills:

##### **Game Genre Challenges (91-96)**
- [ ] 091: Challenge - Infinite Runner
- [ ] 092: Challenge - Match-3 Puzzle Game
- [ ] 093: Challenge - Roguelike Dungeon Crawler
- [ ] 094: Challenge - Real-Time Strategy (RTS) Basics
- [ ] 095: Challenge - Visual Novel Engine
- [ ] 096: Challenge - Rhythm Game Basics

##### **Advanced Techniques (97-99)**
- [ ] 097: Challenge - Shader Effects (Pro License)
- [ ] 098: Challenge - Networked Multiplayer Basics
- [ ] 099: Challenge - AI and Behavior Trees

##### **Final Capstone (100)**
- [ ] 100: Capstone - Build Your Dream Game

---

---

## 🏗️ Technical Architecture

### File Structure
```
mattkelly.io/
├── app/
│   ├── controllers/
│   │   └── dragonruby_controller.rb
│   ├── components/
│   │   └── dragonruby/
│   │       ├── split_pane_component.rb
│   │       ├── editor_pane_component.rb
│   │       ├── canvas_pane_component.rb
│   │       └── tutorial_nav_component.rb
│   ├── services/
│   │   └── tutorial_parser.rb
│   ├── models/
│   │   └── tutorial.rb (PORO)
│   ├── views/
│   │   └── dragonruby/
│   │       ├── index.html.erb
│   │       └── show.html.erb
│   └── javascript/
│       └── controllers/
│           ├── dragonruby_editor_controller.js
│           ├── dragonruby_runner_controller.js
│           └── tutorial_nav_controller.js
├── blog/
│   └── dragonruby/
│       ├── README.md (tutorial index)
│       ├── 001-hello-world.md
│       ├── 002-tick-method.md
│       └── ... (100 tutorials)
├── public/
│   └── dragonruby/
│       ├── dragonruby-wasm.js
│       ├── dragonruby-wasm.wasm
│       └── dragonruby-html5-loader.js
└── dragonruby.md (this file)
```

### Data Flow
```
User selects tutorial
    ↓
TutorialParser reads markdown file
    ↓
Extract frontmatter (YAML) + code blocks (regex)
    ↓
Render tutorial content (HTML) + populate editor
    ↓
User edits code in Monaco Editor
    ↓
Click "Run" → Send code to WASM runtime
    ↓
WASM executes Ruby code → Renders to canvas
    ↓
Display results or errors in UI
```

### Technology Stack
- **Backend:** Ruby on Rails 8.0
- **Frontend:** Hotwire (Turbo + Stimulus)
- **Editor:** Monaco Editor (VS Code's editor)
- **Runtime:** DragonRuby WASM
- **Styling:** Tailwind CSS + Tokyo Night theme
- **Markdown:** Redcarpet or Kramdown
- **Code Highlighting:** Prism.js (already in project)
- **Storage:** LocalStorage + Optional backend persistence

---

## 🎨 Design Decisions

### Tutorial Markdown Format (FINALIZED)
```markdown
---
title: "Tutorial Title"
description: "Short description"
difficulty: "beginner|intermediate|advanced"
category: "basics|rendering|input|physics|audio"
order: 1
estimated_time: "5 min"
tags: ["tag1", "tag2"]
author: "Matt Kelly"
date: 2024-10-23
status: "published|draft|archived"
dragonruby_version: "5.0+"
---

# Tutorial Title

Introduction text...

## Step 1: First Step
Explanation...

```ruby
def tick args
  # Code here
end
```

## Complete Code

```ruby
# Full working example
def tick args
  # Complete implementation
end
```

## Challenges
**Challenge 1:** Description
**Challenge 2:** Description

## Next Steps
Continue to [Next Tutorial](#)
```

### Code Block Types
- **Default** ````ruby` - Standard code example
- **Starter** ````ruby:starter` - Initial code for editor
- **Solution** ````ruby:solution` - Hidden solution code
- **Readonly** ````ruby:readonly` - Display-only example

### UI Layout Decisions
- **Desktop:** 60% editor / 40% canvas (horizontal split)
- **Mobile:** Vertical stack (editor top, canvas bottom)
- **Theme:** Tokyo Night everywhere (consistent with site)
- **Navigation:** Sidebar with collapsible categories
- **Canvas:** 1280x720 logical pixels, scaled to fit pane

### Performance Considerations
- Lazy load tutorial markdown files (on-demand)
- Cache parsed tutorials in memory
- Use requestAnimationFrame for canvas updates
- Debounce code execution on typing (500ms delay)
- Virtual scrolling for large tutorial lists (if needed)

---

## 📝 Notes & Future Ideas

### Ideas for Later
- [ ] Video walkthroughs for tutorials
- [ ] Community code sharing and remixing
- [ ] Multiplayer coding challenges
- [ ] Achievement badges for completion
- [ ] Tutorial difficulty ratings from users
- [ ] Dark mode toggle (separate from Tokyo Night)
- [ ] Export tutorials as PDF or ebook
- [ ] DragonRuby version switcher

### Technical Debt / Improvements
- Consider TypeScript for Stimulus controllers
- Add E2E tests with Cypress or Playwright
- CDN for WASM files (if large)
- Service worker for offline tutorial access
- GraphQL API for tutorial data (overkill?)

### Community Contributions
- Document how others can submit tutorials
- Create PR template for new tutorials
- Add tutorial review checklist
- Set up automated tests for tutorial code

---

## 🔗 Resources & References

### DragonRuby Documentation
- [Official Docs](https://docs.dragonruby.org/)
- [Sample Apps](https://github.com/DragonRuby/dragonruby-game-toolkit-contrib)
- [DragonRuby Fiddle](https://fiddle.dragonruby.org)

### Monaco Editor
- [Monaco Editor Docs](https://microsoft.github.io/monaco-editor/)
- [Monaco Ruby Language](https://github.com/microsoft/monaco-languages)

### Existing Implementation References
- Fiddle Source: https://github.com/DragonRuby/fiddle.dragonruby.org
- Current terminal implementation in project

---

**End of Implementation Plan**

*Last updated: 2024-10-23*
