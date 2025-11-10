# Documentation Location

## Quick Links

- **Development Wiki**: `http://localhost:3000/docs` (when running `bin/dev`)
- **Quick Start**: `docs/getting-started/quick-start.md`
- **Tech Stack**: `docs/architecture/tech-stack.md`
- **Contributing**: `docs/contributing/agents-guide.md`

## What Happened?

Documentation has been consolidated into an organized wiki structure under `docs/` directory. The wiki is accessible at `/docs` when running in development mode.

### Old Files (Now in Archive)

Original documentation files remain in root for reference but are no longer the canonical source:

- `AGENTS.md` → `docs/contributing/agents-guide.md` (this file is still updated as quick reference)
- `hero-terminal-overhaul.md` → `docs/planning/sessions/terminal-overhaul.md`
- `DRAGONRUBY_*.md` → `docs/planning/sessions/dragonruby-wasm.md`
- `VIEWCOMPONENT_MIGRATION.md` → `docs/planning/sessions/viewcomponent-migration.md`
- `QUICK_START.md` → `docs/getting-started/quick-start.md`
- `docs/spec.md` → `docs/planning/spec.md`
- `docs/todo.md` → `docs/planning/todo.md`
- `docs/prompt_plan.md` → `docs/planning/prompt-plan.md`

### New Documentation Structure

```
docs/
├── README.md (Wiki home)
├── getting-started/
│   ├── quick-start.md
│   ├── project-overview.md
│   └── development-setup.md
├── architecture/
│   ├── tech-stack.md
│   ├── rails-importmap.md
│   ├── stimulus-patterns.md (TODO)
│   └── viewcomponents.md (TODO)
├── features/
│   ├── terminal-emulator.md
│   ├── dragonruby-integration.md (TODO)
│   ├── blog-system.md (TODO)
│   └── github-heatmap.md (TODO)
├── guides/
│   ├── adding-terminal-commands.md (TODO)
│   ├── debugging-javascript.md (TODO)
│   ├── tokyo-night-theme.md (TODO)
│   └── deployment.md (TODO)
├── planning/
│   ├── spec.md
│   ├── todo.md
│   ├── prompt-plan.md
│   └── sessions/
│       ├── terminal-overhaul.md
│       ├── dragonruby-wasm.md
│       └── viewcomponent-migration.md
└── contributing/
    └── agents-guide.md
```

## Why the Change?

1. **Organization**: Scattered markdown files made it hard to find information
2. **Discoverability**: Wiki-style navigation makes docs easier to browse
3. **Consistency**: Same markdown rendering as blog
4. **Security**: Development-only (not exposed in production)
5. **Maintainability**: Clear structure for future docs

## Accessing Documentation

### Development Mode (Local)

```bash
bin/dev
# Visit http://localhost:3000/docs
```

### Production Mode

Documentation wiki is NOT accessible in production. This is by design to prevent exposing internal documentation publicly. Access via:

1. GitHub repository source
2. Local development environment
3. Clone and run locally

## Contributing to Docs

1. Edit markdown files in `docs/` directory
2. Organize new docs into appropriate category
3. Update `docs/README.md` if adding new sections
4. Test locally at `/docs`
5. Commit changes

### Adding New Documentation

1. Choose appropriate category (or create new one)
2. Create markdown file with descriptive name
3. Use kebab-case for filenames (`my-new-doc.md`)
4. Add link in `docs/README.md` index
5. Add internal links to related docs

## Questions?

- Check `docs/README.md` for comprehensive index
- Browse categories at `http://localhost:3000/docs`
- Read `docs/contributing/agents-guide.md` for AI agent instructions
