# Technology Stack

Comprehensive overview of technologies used in mattkelly.io and why they were chosen.

## Core Technologies

### Backend: Ruby on Rails 8.0.2

**Why Rails 8?**
- Mature, stable framework with excellent conventions
- Built-in features eliminate need for complex tooling
- Native support for modern web standards
- Strong ecosystem and community

**Key Rails Features Used**:
- Importmap for JavaScript (no build step)
- Turbo for SPA-like navigation
- Solid Queue for background jobs
- Action Cable for real-time features (future)

### Frontend: Hotwire (Turbo + Stimulus)

**Why Hotwire?**
- Progressive enhancement philosophy
- Less JavaScript to ship and maintain
- Server-rendered HTML for better SEO
- Perfect integration with Rails

**Stimulus Controllers**:
- `interactive_terminal_controller.js` - Terminal emulator
- `github_heatmap_controller.js` - Activity visualization
- `glitch_controller.js` - Text glitch effects
- `dragonruby_split_controller.js` - Split pane editor

### JavaScript: ES6 Modules via Importmap

**Why Importmap?**
- No build step required
- No Node.js dependency
- Browser-native ES6 module loading
- Fast development workflow

**Trade-offs**:
- Can't use TypeScript without extra tooling
- Some libraries unavailable as ES modules
- More HTTP requests (mitigated by HTTP/2)

See [Rails Importmap Guide](rails-importmap.md) for deep dive.

### Styling: Tailwind CSS 3.x

**Why Tailwind?**
- Utility-first approach for rapid development
- Consistent design system
- Tiny production bundles (unused styles purged)
- Great developer experience

**Custom Configuration**:
- Tokyo Night color palette
- Custom typography scale
- Component-specific utilities

### Database: SQLite

**Why SQLite?**
- Simple deployment (single file)
- Fast for read-heavy workloads
- Perfect for small-to-medium sites
- No separate database server needed

**Considerations**:
- Not suitable for high-concurrency writes
- Great for this use case (mostly static content)

## Component Architecture

### ViewComponents

**Why ViewComponents?**
- Testable UI components
- Ruby-based (no separate templating language)
- Built-in preview system
- Better than partials for complex UI

**Example Components**:
- `Hero::TerminalComponent` - Interactive terminal
- `Nav::ItemComponent` - Navigation links
- `Docs::NavigationComponent` - Documentation sidebar

## Testing Stack

### RSpec

**Why RSpec?**
- Expressive syntax
- Rich ecosystem of matchers
- Great for TDD/BDD workflows

**Test Types**:
- Model specs
- Controller specs
- System specs (Capybara)
- Component specs (ViewComponent)

### Capybara

**Why Capybara?**
- Browser automation for integration tests
- Tests actual user interactions
- Catches JavaScript issues

## Development Tools

### Background Jobs: Solid Queue

**Why Solid Queue?**
- SQLite-backed (no Redis needed)
- Built into Rails 8
- Reliable and performant
- Simple deployment

### Code Quality

**Tools**:
- **RuboCop** - Ruby linter and formatter
- **Brakeman** - Security scanner
- **SimpleCov** - Code coverage

### Deployment

**Fly.io**
- Simple deployment (single command)
- Global edge network
- Automatic SSL certificates
- Git-based deploys via GitHub Actions

## External Libraries

### Via Importmap (JavaScript)
- `@hotwired/stimulus` - Frontend controllers
- `@hotwired/turbo-rails` - SPA-like navigation

### Via CDN (JavaScript)
- `filer.js` - Virtual filesystem (UMD bundle)

### Ruby Gems
See `Gemfile` for complete list:
- `importmap-rails` - JavaScript module management
- `stimulus-rails` - Stimulus integration
- `turbo-rails` - Turbo integration
- `view_component` - Component architecture
- `redcarpet` - Markdown parsing
- `tailwindcss-rails` - Tailwind CSS integration

## Performance Optimizations

### Asset Delivery
- Importmap with content digests
- Browser caching with proper headers
- HTTP/2 for parallel requests
- CDN for external libraries

### Database
- SQLite with appropriate indexes
- Fragment caching where needed
- Query optimization

### Rendering
- Server-side rendering (fast initial load)
- Turbo navigation (no full page reloads)
- Minimal JavaScript execution

## Development Philosophy

### Boring Technology

We choose proven, stable technologies over trendy ones:
- Rails over microservices
- SQLite over complex database setups
- Importmap over complex build tools
- Server rendering over client-side frameworks

### Progressive Enhancement

Start with HTML that works, then enhance:
1. Server-rendered HTML (works without JavaScript)
2. Turbo for smooth navigation
3. Stimulus for interactive features
4. WebAssembly for specialized features (DragonRuby)

### Developer Experience

Optimize for:
- Fast feedback loops (no build step)
- Easy onboarding (few dependencies)
- Clear conventions (Rails defaults)
- Good documentation (you're reading it!)

## Technology Decisions

### Why Not Node.js?
- Rails importmap eliminates need
- Simpler deployment (single runtime)
- Less tooling complexity

### Why Not React/Vue?
- Server rendering is faster
- Less JavaScript to maintain
- Stimulus covers our needs
- Better SEO out of the box

### Why Not PostgreSQL?
- SQLite is simpler for this scale
- Single file backup
- Fast for read-heavy workload
- Can migrate later if needed

### Why Not Docker for Development?
- Native Rails dev server is fast
- Fewer layers of abstraction
- Easier debugging
- Docker used for production deployment

## Future Considerations

### Potential Additions
- Action Cable for real-time features
- Background jobs for heavy processing
- Service workers for offline support
- WebRTC for multiplayer DragonRuby games

### Migration Paths
- SQLite → PostgreSQL (if write concurrency becomes issue)
- Single server → Multi-region (Fly.io makes this easy)
- Monolith → API (if needed for mobile apps)

## Resources

### Documentation
- [Rails Guides](https://guides.rubyonrails.org/)
- [Stimulus Handbook](https://stimulus.hotwired.dev/)
- [Tailwind CSS Docs](https://tailwindcss.com/docs)
- [ViewComponent Guide](https://viewcomponent.org/)

### This Project
- [Rails Importmap Deep Dive](rails-importmap.md)
- [Stimulus Patterns](stimulus-patterns.md)
- [ViewComponents Guide](viewcomponents.md)
