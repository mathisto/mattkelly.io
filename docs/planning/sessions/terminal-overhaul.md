# Hero Terminal Overhaul

## Overview
Transform the static terminal display in the hero section into a fully interactive, browser-based shell emulator with a virtual filesystem, command execution, and persistent storage. Inspired by [browser-shell](https://humphd.github.io/browser-shell/) but optimized for speed and Tokyo Night aesthetic.

## Design Goals
- ✨ **Interactive**: Users can type commands and explore a virtual filesystem
- 🎨 **Beautiful**: Strict Tokyo Night aesthetic with smooth animations
- ⚡ **Fast**: Lightweight implementation (<100KB), instant boot
- 💾 **Persistent**: Files survive page reloads via IndexedDB
- 📱 **Accessible**: Works on mobile with touch-friendly command palette
- 🚀 **Progressive**: Server-rendered fallback, enhanced with JS

---

## Phase 1: Interactive Shell Emulator with Filer.js

### 1.1 Filer.js Integration
**Status**: ✅ Complete

- [x] Add Filer.js to project dependencies
  - [x] Research latest stable version of [Filer](https://github.com/filerjs/filer) - v1.4.1
  - [x] Load via CDN script tag (UMD bundle incompatible with ES modules)
  - [x] Configure Filer to use IndexedDB backend
- [x] Create filesystem initialization service
  - [x] Create `app/javascript/lib/filesystem_service.js`
  - [x] Initialize Filer filesystem on first load
  - [x] Populate initial files and directories
  - [x] Export singleton filesystem instance
- [x] Populate initial virtual filesystem:
  - [x] `README.md` - Welcome message with available commands
  - [x] `role.txt` - Current tagline: "Polyglot problem solver..."
  - [x] `whoami` - Executable script displaying ASCII art name
  - [x] `contact.sh` - Executable displaying contact info (email, CV links)
  - [x] `projects/` - Directory with project summaries
  - [x] `.secrets/superpowers.txt` - Hidden file with technical skills
  - [x] `.secrets/philosophy.md` - Development philosophy easter egg
  - [x] `.config/theme.json` - Tokyo Night color scheme reference
- [x] Test filesystem persistence - WORKING!

**CRITICAL LESSON LEARNED**: Filer.js is a UMD bundle that cannot be imported via importmap/ES modules. Must load via `<script>` tag and access as `window.Filer` global.

**Dependencies**: Filer.js v1.4.1 via CDN  
**Estimated Size**: ~264KB (loaded via CDN, not counted in bundle)  
**Files Created**:
- `app/javascript/lib/filesystem_service.js` (singleton service)
- `app/views/layouts/terminal_test.html.erb` (test layout)
- `app/views/pages/terminal_test.html.erb` (test page)

### 1.2 Command Parser & Executor
**Status**: ✅ Complete - All 7 commands working!

- [ ] Create `app/javascript/lib/command_parser.js`
  - [ ] Parse user input into command + arguments
  - [ ] Support quoted arguments ("file name with spaces.txt")
  - [ ] Handle pipes and redirects (future enhancement)
  - [ ] Export command execution function
- [ ] Create `app/javascript/lib/commands/` directory
  - [ ] `ls.js` - List directory contents
    - [ ] Support `-l` flag (long format)
    - [ ] Support `-a` flag (show hidden files)
    - [ ] Support `-la` combined flags
    - [ ] Color-code files by type (dirs, executables, files)
  - [ ] `cat.js` - Display file contents
    - [ ] Handle text files
    - [ ] Handle special file types (show metadata)
    - [ ] Error on binary files
  - [ ] `cd.js` - Change directory
    - [ ] Support relative paths (`cd projects`)
    - [ ] Support absolute paths (`cd /projects`)
    - [ ] Support `..` parent directory
    - [ ] Support `~` home directory
    - [ ] Support `cd -` (previous directory)
  - [ ] `pwd.js` - Print working directory
  - [ ] `clear.js` - Clear terminal output
  - [ ] `help.js` - Display available commands with descriptions
  - [ ] `whoami.js` - Run whoami script, display ASCII art
  - [ ] `history.js` - Show command history
  - [ ] `man.js` - Display manual pages for commands
  - [ ] `mkdir.js` - Create directory
  - [ ] `touch.js` - Create empty file
  - [ ] `rm.js` - Remove files/directories
  - [ ] `cp.js` - Copy files
  - [ ] `mv.js` - Move/rename files
  - [ ] `echo.js` - Print text to output
  - [ ] `curl.js` - Fetch resume (easter egg: `curl mattkelly.io/resume`)
- [ ] Handle command errors gracefully
  - [ ] "Command not found" for unknown commands
  - [ ] "No such file or directory" with helpful suggestions
  - [ ] "Permission denied" for protected operations
  - [ ] Colorize error messages (Tokyo Night red: #f7768e)

**Dependencies**: Filer.js filesystem instance  
**Estimated Size**: ~15-20KB

### 1.3 Terminal Input/Output Controller
**Status**: ⚠️ Working but needs fixes

**Known Issues**:
1. ❌ Terminal doesn't auto-scroll to bottom as content grows
2. ❌ Cursor stays at position 0 instead of moving with typed text
3. ❌ First character appears at position 1 (cursor takes position 0)

**Working**:
- ✅ Keyboard input capture
- ✅ Command execution
- ✅ Command history (↑/↓ arrows)
- ✅ Ctrl shortcuts (C, L, U, A, E)
- ✅ Tokyo Night colors
- ✅ Filer.js filesystem integration

- [ ] Create `app/javascript/controllers/interactive_terminal_controller.js`
  - [ ] Initialize Stimulus controller
  - [ ] Connect to Filer.js filesystem
  - [ ] Initialize command history buffer
  - [ ] Set up keyboard event listeners
- [ ] Implement keyboard input handling
  - [ ] Capture printable characters
  - [ ] Handle backspace/delete (remove character)
  - [ ] Handle arrow keys:
    - [ ] Up arrow - previous command in history
    - [ ] Down arrow - next command in history
    - [ ] Left arrow - move cursor left in input line
    - [ ] Right arrow - move cursor right in input line
  - [ ] Handle Tab key - autocomplete files/commands
  - [ ] Handle Enter key - execute command
  - [ ] Handle Ctrl+C - cancel current input, new prompt
  - [ ] Handle Ctrl+L - clear screen (same as `clear` command)
  - [ ] Handle Ctrl+A - move cursor to start of line
  - [ ] Handle Ctrl+E - move cursor to end of line
  - [ ] Handle Ctrl+U - clear input line
- [ ] Implement command execution flow
  - [ ] Parse command input
  - [ ] Add to history buffer
  - [ ] Execute command via command parser
  - [ ] Render output to terminal
  - [ ] Scroll to bottom
  - [ ] Display new prompt
- [ ] Implement autocomplete logic
  - [ ] Detect partial command/filename
  - [ ] Query filesystem for matches
  - [ ] Show autocomplete suggestions
  - [ ] Cycle through suggestions on repeated Tab
- [ ] Handle terminal output rendering
  - [ ] Append command to output history
  - [ ] Append command result with proper formatting
  - [ ] Support ANSI color codes (Tokyo Night palette)
  - [ ] Auto-scroll to bottom on new output
  - [ ] Limit output history (keep last 1000 lines for performance)
- [ ] Focus management
  - [ ] Auto-focus terminal on page load
  - [ ] Refocus on terminal click
  - [ ] Handle blur events (keep terminal accessible)

**Dependencies**: Filer.js, command_parser.js  
**Estimated Size**: ~20-25KB

### 1.4 Terminal State Management
**Status**: 🔲 Not Started

- [ ] Create `app/javascript/lib/terminal_state.js`
  - [ ] Track current working directory
  - [ ] Track command history (persist to localStorage)
  - [ ] Track environment variables (PATH, HOME, etc.)
  - [ ] Track previous directory (for `cd -`)
  - [ ] Export state getter/setter methods
- [ ] Implement localStorage persistence
  - [ ] Save command history on each command
  - [ ] Save current directory on change
  - [ ] Load state on terminal initialization
  - [ ] Clear state on explicit user action (future: `reset` command)

**Dependencies**: None  
**Estimated Size**: ~5KB

### 1.5 Component Updates
**Status**: 🔲 Not Started

- [ ] Update `app/components/hero/terminal_component.rb`
  - [ ] Add `interactive: true` parameter (default false for backward compatibility)
  - [ ] Add Stimulus controller data attributes when interactive
  - [ ] Keep existing static rendering for non-interactive mode
  - [ ] Add helper methods for rendering interactive vs static
- [ ] Update `app/components/hero/terminal_component.html.erb`
  - [ ] Conditionally add `data-controller="interactive-terminal"`
  - [ ] Add output container div for command results
  - [ ] Add hidden input field for keyboard capture
  - [ ] Render initial static content as first commands
  - [ ] Add initial prompt line with cursor
- [ ] Update hero section in `app/views/home/index.html.erb`
  - [ ] Switch terminal to interactive mode: `interactive: true`
  - [ ] Keep existing entrance animation controller
  - [ ] Ensure proper z-index layering

**Dependencies**: interactive_terminal_controller.js  
**Files Changed**: 3

### 1.6 Tokyo Night Styling
**Status**: 🔲 Not Started

- [ ] Create `app/assets/stylesheets/components/interactive_terminal.css`
  - [ ] Terminal container styles
  - [ ] Command input line styles
  - [ ] Output text styles with Tokyo Night colors:
    - [ ] Default text: `#a9b1d6` (foreground)
    - [ ] Command text: `#7aa2f7` (blue)
    - [ ] Success text: `#9ece6a` (green)
    - [ ] Error text: `#f7768e` (red)
    - [ ] Warning text: `#e0af68` (yellow)
    - [ ] Comment/dim text: `#565f89` (comment)
    - [ ] File paths: `#bb9af7` (purple)
    - [ ] Executables: `#9ece6a` (green)
    - [ ] Directories: `#7aa2f7` (blue)
  - [ ] Cursor styles:
    - [ ] Tokyo Night purple: `#bb9af7`
    - [ ] Slow fade pulse animation (2s cycle)
    - [ ] Smooth opacity transition
  - [ ] Input caret positioning
  - [ ] Scrollbar styling (Tokyo Night dark theme)
  - [ ] Selection highlighting (Tokyo Night selection color)
- [ ] Mobile-specific styles
  - [ ] Touch target sizing (44px minimum)
  - [ ] Virtual keyboard handling
  - [ ] Prevent zoom on input focus
  - [ ] Adjusted font sizes for readability
- [ ] Ensure consistency with existing terminal styles
  - [ ] Match terminal header stoplight buttons
  - [ ] Match terminal window border and shadow
  - [ ] Match background transparency/blur

**Dependencies**: None  
**Estimated Size**: ~5-8KB

### 1.7 Command Autocomplete
**Status**: 🔲 Not Started

- [ ] Create `app/javascript/lib/autocomplete.js`
  - [ ] Detect Tab key press on partial input
  - [ ] Determine context (command vs file path)
  - [ ] Query filesystem for matching files/directories
  - [ ] Match against available commands
  - [ ] Return array of suggestions
- [ ] Implement autocomplete UI
  - [ ] Show inline suggestion (gray text)
  - [ ] Cycle through multiple matches on repeated Tab
  - [ ] Display all matches if too many (more than 1)
  - [ ] Clear autocomplete on character input
- [ ] Handle edge cases
  - [ ] Autocomplete paths with spaces
  - [ ] Autocomplete hidden files (starting with `.`)
  - [ ] Autocomplete command flags (`ls -` → suggest `-l`, `-a`, `-la`)

**Dependencies**: Filer.js, command list  
**Estimated Size**: ~8-10KB

### 1.8 Easter Eggs & Polish
**Status**: 🔲 Not Started

- [ ] Hidden `.secrets/` directory
  - [ ] Create `superpowers.txt` with technical skills list
  - [ ] Create `philosophy.md` with development philosophy
  - [ ] Create `.secrets/README.md` explaining easter eggs
- [ ] Special commands
  - [ ] `curl mattkelly.io/resume` - Display ASCII resume
  - [ ] `neofetch` - Display system info (browser, OS, etc.)
  - [ ] `cowsay` - ASCII cow with message (fun easter egg)
  - [ ] `fortune` - Random tech quotes
  - [ ] `sl` - ASCII train animation (classic typo easter egg)
- [ ] Fake command history
  - [ ] Pre-populate history with interesting commands
  - [ ] Show creative exploration path
- [ ] `man` pages
  - [ ] Create formatted help text for each command
  - [ ] Tokyo Night syntax highlighting
  - [ ] Example usage for each command
- [ ] Welcome message
  - [ ] Display on first terminal load
  - [ ] Hint at easter eggs
  - [ ] Show `help` command availability
- [ ] Sound effects (optional, toggleable)
  - [ ] Subtle keypress sounds
  - [ ] Command execution confirmation
  - [ ] Error sound for failed commands
  - [ ] Must respect `prefers-reduced-motion`

**Dependencies**: All previous Phase 1 tasks  
**Estimated Size**: ~10-15KB

---

## Phase 2: Mobile & Accessibility

### 2.1 Mobile Experience
**Status**: 🔲 Not Started

- [ ] Touch-friendly command palette
  - [ ] Create floating action button (FAB) with common commands
  - [ ] Commands: `ls`, `cat role.txt`, `help`, `clear`
  - [ ] Slide-up drawer UI with Tokyo Night styling
  - [ ] Quick-tap to execute commands
- [ ] Virtual keyboard handling
  - [ ] Auto-show keyboard on terminal tap
  - [ ] Prevent page zoom on input focus (`user-scalable=no` for terminal)
  - [ ] Handle keyboard show/hide events
  - [ ] Adjust viewport on keyboard open
- [ ] Touch gestures
  - [ ] Swipe up/down for command history
  - [ ] Long-press for autocomplete
  - [ ] Double-tap to select word
- [ ] Responsive terminal sizing
  - [ ] Reduce font size on small screens (clamp values)
  - [ ] Horizontal scroll for wide output (tables, ASCII art)
  - [ ] Adjust padding and spacing for mobile

**Dependencies**: Phase 1 complete  
**Estimated Size**: ~10KB

### 2.2 Accessibility
**Status**: 🔲 Not Started

- [ ] ARIA labels and roles
  - [ ] `role="log"` for terminal output
  - [ ] `aria-live="polite"` for new output announcements
  - [ ] `aria-label` for terminal regions
  - [ ] `aria-describedby` for command input
- [ ] Screen reader support
  - [ ] Announce command execution
  - [ ] Announce command output
  - [ ] Provide alternative text for ASCII art
  - [ ] Skip to content link above terminal
- [ ] Keyboard-only navigation
  - [ ] Ensure all features work without mouse
  - [ ] Focus visible indicators
  - [ ] Tab navigation through interactive elements
  - [ ] Document keyboard shortcuts in `help` command
- [ ] Accessibility preferences
  - [ ] Respect `prefers-reduced-motion` (disable animations)
  - [ ] Respect `prefers-color-scheme` (future: light mode)
  - [ ] Respect `prefers-contrast` (increase contrast if needed)
- [ ] Focus management
  - [ ] Trap focus within terminal when active
  - [ ] Announce focus changes
  - [ ] Return focus on modal close

**Dependencies**: Phase 1 complete  
**Estimated Size**: ~5KB

---

## Phase 3: Performance & SEO

### 3.1 Progressive Enhancement
**Status**: 🔲 Not Started

- [ ] Server-side rendering (SSR)
  - [ ] Render static terminal content on server
  - [ ] Show initial `whoami` and `cat role.txt` commands
  - [ ] Ensure content is crawlable by search engines
- [ ] JavaScript hydration
  - [ ] Detect JavaScript availability
  - [ ] Gracefully enhance static terminal with interactivity
  - [ ] Show "Enable JavaScript for interactive terminal" message if JS disabled
- [ ] Lazy loading
  - [ ] Load Filer.js on first user interaction (click/tap)
  - [ ] Defer interactive controller initialization until needed
  - [ ] Show loading state during initialization
- [ ] Code splitting
  - [ ] Split command implementations into separate chunks
  - [ ] Load commands on-demand (dynamic imports)
  - [ ] Reduce initial bundle size

**Dependencies**: Phase 1 complete  
**Estimated Size**: No change (optimizations)

### 3.2 Performance Optimization
**Status**: 🔲 Not Started

- [ ] Optimize rendering
  - [ ] Use requestAnimationFrame for smooth animations
  - [ ] Debounce rapid keyboard input
  - [ ] Virtual scrolling for long output histories
  - [ ] Limit DOM nodes (remove old output after threshold)
- [ ] IndexedDB optimization
  - [ ] Batch filesystem operations
  - [ ] Cache frequently accessed files in memory
  - [ ] Compress large files before storage
- [ ] Bundle size optimization
  - [ ] Tree-shake unused Filer.js code
  - [ ] Minify and compress all JS assets
  - [ ] Use dynamic imports for optional features
- [ ] Core Web Vitals
  - [ ] Measure and optimize LCP (Largest Contentful Paint)
  - [ ] Minimize CLS (Cumulative Layout Shift) - terminal should not shift on load
  - [ ] Optimize FID (First Input Delay) - terminal should be interactive quickly
  - [ ] Monitor INP (Interaction to Next Paint) - commands should execute fast

**Dependencies**: Phase 1 complete  
**Tools**: Lighthouse, WebPageTest, Chrome DevTools

### 3.3 SEO Considerations
**Status**: 🔲 Not Started

- [ ] Semantic HTML
  - [ ] Use proper heading hierarchy
  - [ ] Maintain accessible landmarks
  - [ ] Ensure static content is indexable
- [ ] Structured data
  - [ ] Add JSON-LD for personal profile
  - [ ] Add schema.org markup for developer role
  - [ ] Include social media links with proper metadata
- [ ] Meta tags
  - [ ] Update Open Graph tags
  - [ ] Update Twitter Card tags
  - [ ] Add relevant keywords
- [ ] Content optimization
  - [ ] Ensure key content (name, role) is in static HTML
  - [ ] Provide text alternative for ASCII art (alt text)
  - [ ] Include semantic description of terminal interaction

**Dependencies**: None  
**Impact**: Search engine ranking

---

## Technical Stack

### Core Dependencies
| Library | Purpose | Size (gzipped) | Status |
|---------|---------|----------------|--------|
| **Filer.js** | Virtual filesystem with IndexedDB backend | ~40-50KB | 🔲 To Add |
| **Stimulus** | Terminal controller framework | Already installed | ✅ Installed |
| **LocalStorage API** | Command history persistence | Built-in | ✅ Available |
| **IndexedDB API** | Filesystem persistence (via Filer) | Built-in | ✅ Available |

### Estimated Bundle Sizes
- **Phase 1** (Shell Emulator): ~80-100KB gzipped
- **Phase 2** (Mobile/A11y): +15KB gzipped
- **Phase 3** (Optimizations): Bundle size reductions expected

---

## Implementation Order

### Sprint 1: Foundation (Core Shell)
1. ✅ Create planning document (this file)
2. ✅ Add Filer.js dependency and test integration
3. ✅ Create filesystem initialization service with initial files
4. ✅ Build command parser and basic command implementations (ls, cat, cd, pwd, clear, help)
5. ✅ Create interactive terminal Stimulus controller

### Sprint 2: Interactivity
6. ⏭️ Implement keyboard input handling (character input, navigation, history)
7. ⏭️ Add terminal state management (working directory, history persistence)
8. ⏭️ Update hero component for interactive mode
9. ⏭️ Add Tokyo Night styling for interactive terminal

### Sprint 3: Features & Polish
10. ⏭️ Implement command autocomplete
11. ⏭️ Add remaining commands (mkdir, touch, rm, cp, mv, echo, man)
12. ⏭️ Create easter eggs and hidden files
13. ⏭️ Test and debug core functionality

### Sprint 4: Mobile & Accessibility
14. ⏭️ Build mobile command palette
15. ⏭️ Add touch gesture support
16. ⏭️ Implement ARIA labels and screen reader support
17. ⏭️ Test accessibility with keyboard-only navigation

### Sprint 5: Performance & Launch
18. ⏭️ Progressive enhancement (SSR fallback)
19. ⏭️ Performance optimizations (lazy loading, code splitting)
20. ⏭️ SEO improvements (structured data, meta tags)
21. ⏭️ Final testing and deployment

---

## Success Criteria

### Must Have (MVP)
- [x] Users can type commands in the terminal
- [ ] Virtual filesystem supports navigation (cd, ls, pwd)
- [ ] Files can be read (cat) and displayed
- [ ] Command history works (up/down arrows)
- [ ] Files persist across page reloads (IndexedDB)
- [ ] Tokyo Night color scheme is consistent
- [ ] Works on desktop browsers (Chrome, Firefox, Safari)
- [ ] Graceful fallback when JavaScript is disabled

### Should Have
- [ ] Tab autocomplete for files and commands
- [ ] Mobile-friendly command palette
- [ ] Screen reader compatibility
- [ ] Easter eggs are discoverable and fun
- [ ] Performance: <100ms command execution time
- [ ] No layout shift on terminal load (CLS = 0)

### Nice to Have
- [ ] Touch gestures for mobile (swipe for history)
- [ ] Sound effects (toggleable)
- [ ] File upload/download via drag-and-drop
- [ ] Terminal sharing (export session as text)

---

## Testing Plan

### Manual Testing Checklist
- [ ] Desktop browsers (Chrome, Firefox, Safari, Edge)
- [ ] Mobile browsers (iOS Safari, Chrome Android)
- [ ] Keyboard-only navigation
- [ ] Screen reader testing (NVDA, JAWS, VoiceOver)
- [ ] JavaScript disabled (static fallback)
- [ ] Slow network (3G throttling)
- [ ] IndexedDB persistence across sessions
- [ ] All commands execute correctly
- [ ] Error handling for invalid commands/paths
- [ ] Tab autocomplete works for files and commands
- [ ] Command history navigation (up/down arrows)

### Automated Testing (Future)
- [ ] Stimulus controller unit tests
- [ ] Filesystem service tests (Filer.js wrapper)
- [ ] Command parser tests (input parsing, argument handling)
- [ ] Autocomplete logic tests
- [ ] Accessibility audits (axe-core, Lighthouse)
- [ ] Performance regression tests (Lighthouse CI)

### Browser Compatibility
| Browser | Version | Status | Notes |
|---------|---------|--------|-------|
| Chrome | Latest | 🔲 To Test | Primary development browser |
| Firefox | Latest | 🔲 To Test | IndexedDB support required |
| Safari | Latest | 🔲 To Test | iOS primary mobile browser |
| Edge | Latest | 🔲 To Test | Chromium-based, should work |
| Mobile Safari | iOS 14+ | 🔲 To Test | Virtual keyboard handling critical |
| Chrome Android | Latest | 🔲 To Test | Touch gesture support |

---

## Design References

### Inspiration
- **browser-shell**: https://humphd.github.io/browser-shell/
  - Virtual filesystem (Filer.js)
  - IndexedDB persistence
  - Real terminal aesthetic
- **Tokyo Night Theme**: https://github.com/tokyo-night/tokyo-night-vscode-theme
  - Color palette reference
  - Syntax highlighting inspiration

### Tokyo Night Color Palette
```css
/* Background */
--bg-primary: #1a1b26;
--bg-secondary: #1f2335;
--bg-tertiary: #24283b;

/* Foreground */
--fg-primary: #a9b1d6;
--fg-secondary: #565f89;

/* Accent Colors */
--red: #f7768e;
--orange: #ff9e64;
--yellow: #e0af68;
--green: #9ece6a;
--cyan: #7dcfff;
--blue: #7aa2f7;
--purple: #bb9af7;
--magenta: #bb9af7;

/* UI Elements */
--border: #29293f;
--selection: #364a82;
--comment: #565f89;
```

---

## Known Issues & Future Work

### Known Limitations
- [ ] Large file handling (performance degradation with >1MB files)
- [ ] Binary file support (currently text-only)
- [ ] Network commands (curl, wget) limited to predefined responses
- [ ] No true process management (all commands execute synchronously)

### Future Enhancements
- [ ] Service Worker web server (serve files at `/fs/` route like browser-shell)
- [ ] File drag-and-drop upload to virtual filesystem
- [ ] Terminal session export (download as text/JSON)
- [ ] Vim/Nano text editor in terminal (complex but amazing)
- [ ] Git integration (gitlet.js or similar)
- [ ] Multiple terminal tabs/panes
- [ ] Terminal themes (switch between Tokyo Night, Dracula, Nord, etc.)
- [ ] Custom commands via user scripts in filesystem

---

## Resources

### Documentation
- **Filer.js**: https://github.com/filerjs/filer
- **Stimulus**: https://stimulus.hotwired.dev/
- **IndexedDB API**: https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API
- **Web Accessibility**: https://www.w3.org/WAI/WCAG21/quickref/

### Tutorials & Articles
- **browser-shell writeup**: https://humphd.github.io/browser-shell/
- **Building a terminal in the browser**: https://blog.logrocket.com/building-a-terminal-emulator-in-react/
- **Filer.js examples**: https://github.com/filerjs/filer#examples

---

## Notes & Decisions

### Architecture Decisions
- **Why Filer.js over custom filesystem?** Battle-tested, IndexedDB-backed, node.js fs API compatibility
- **Why lightweight shell over v86 Linux VM?** Speed (<100ms boot vs 3-5s), size (<100KB vs 10-20MB), control
- **Why Stimulus over vanilla JS?** Rails integration, organized lifecycle hooks, data binding
- **Why IndexedDB over localStorage?** Storage quota (50MB+ vs 5-10MB), async API, better for large filesystems

### Tokyo Night Commitment
- All colors must map to Tokyo Night palette (no exceptions)
- Cursor must be Tokyo Night purple (#bb9af7) with slow fade pulse
- Terminal background must use Tokyo Night backgrounds (#1f2335, #1a1b26)
- Syntax highlighting must use Tokyo Night semantic colors

### Performance Budget
- **Initial bundle**: <100KB gzipped
- **Time to Interactive**: <1s on 4G
- **Command execution**: <100ms average
- **Filesystem operations**: <50ms (IndexedDB read)
- **Memory usage**: <50MB for filesystem + terminal

---

**Last Updated**: 2025-01-23  
**Status**: 🚀 Ready to Start Implementation  
**Next Task**: Add Filer.js dependency and test integration
