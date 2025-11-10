# OpenMemory Usage Guidelines

## For Global OpenCode Configuration

**Note**: Add this section to `~/.config/opencode/AGENTS.md` for global AI agent behavior.

### OpenMemory Integration

All AI agent interactions should intelligently use the OpenMemory MCP server to maintain a persistent knowledge graph across sessions.

#### When to Use OpenMemory

1. **Learning Project Knowledge**: When discovering new information about:
   - Architecture decisions and their rationale
   - Critical patterns and anti-patterns
   - Common debugging scenarios and solutions
   - Technology stack choices and tradeoffs
   - Project-specific conventions

2. **Before Starting Tasks**: Intelligently prefetch relevant knowledge:
   - Search for similar past work
   - Retrieve context about related features
   - Check for documented patterns
   - Review previous decisions

3. **After Completing Tasks**: Store learnings for future reference:
   - Document solution approaches
   - Record bug fixes and root causes
   - Save architectural decisions
   - Capture gotchas and edge cases

4. **When Explicitly Requested**: User asks to "remember" or "store" information

#### How to Use OpenMemory

**Search Before Acting**:
```javascript
// Before implementing a new feature
openmemory_search_memory("terminal commands implementation")
openmemory_search_memory("Stimulus controller patterns")
```

**Store After Learning**:
```javascript
// After discovering something important
openmemory_add_memories("Browser cache must be hard-refreshed (Cmd+Shift+R) when JavaScript changes with importmap-rails. DevTools cache disable only works when DevTools is open.")

openmemory_add_memories("Terminal cursor positioning bug was caused by incrementing cursorPosition AFTER setInput() instead of BEFORE. State must be updated before rendering.")
```

**Organize as Graph**:
- Create connections between related concepts
- Use consistent naming for entities
- Link decisions to their context
- Build searchable knowledge network

#### Best Practices

1. **Be Specific**: Store concrete, actionable information
   - ✅ "Rails importmap cache issues require Cmd+Shift+R hard refresh"
   - ❌ "Caching can be problematic"

2. **Include Context**: Explain WHY, not just WHAT
   - ✅ "Use Filer.js via script tag because it's a UMD bundle incompatible with ES modules"
   - ❌ "Use Filer.js via script tag"

3. **Link Related Concepts**: Build knowledge graph
   - Technology choices → Rationale
   - Problems → Solutions → Prevention
   - Features → Implementation patterns

4. **Update, Don't Duplicate**: Search before storing
   - Check if knowledge already exists
   - Update existing memories instead of creating duplicates
   - Maintain single source of truth

5. **Categorize Effectively**: Use consistent categories
   - Architecture decisions
   - Technology patterns
   - Debugging solutions
   - Implementation gotchas
   - Performance optimizations

#### Example Workflow

```javascript
// 1. Starting new terminal command implementation
const memories = await openmemory_search_memory("terminal commands how to add")

// 2. Review existing patterns
console.log("Found existing command patterns:", memories)

// 3. Implement feature using established patterns
// ...

// 4. Encountered and solved a new issue
await openmemory_add_memories(
  "When adding terminal commands with importmap-rails: " +
  "1. Create file in app/javascript/lib/commands/mycommand.js " +
  "2. Export default async function " +
  "3. Import in lib/commands/index.js " +
  "4. Add to exports object " +
  "5. CRITICAL: Hard refresh browser (Cmd+Shift+R), standard refresh won't load new module"
)

// 5. Link to related knowledge
await openmemory_add_memories(
  "This terminal command pattern connects to importmap-rails caching behavior. " +
  "Browser aggressively caches ES modules, so all code changes require hard refresh. " +
  "Related: stimulus controller updates, any JavaScript changes."
)
```

## Project-Specific Usage

For this project (mattkelly.io), priority areas for OpenMemory:

1. **JavaScript/Importmap Issues**: Cache behavior, UMD vs ES modules
2. **Terminal Emulator**: Command implementation patterns, Filer.js usage
3. **DragonRuby Integration**: WASM loading, editor communication
4. **Rails 8 Patterns**: Hotwire, Stimulus, ViewComponents
5. **Tokyo Night Theme**: Color palette, styling conventions
6. **Deployment**: Fly.io configuration, environment setup

## Verifying OpenMemory

Check if OpenMemory MCP server is installed and working:

```bash
# In OpenCode
/mcp

# Should show openmemory_* tools available
```

If not installed, add to `~/.config/opencode/opencode.json`:

```json
{
  "mcp": {
    "openmemory": {
      "type": "local",
      "command": ["npx", "-y", "@openmemory/mcp-server"],
      "enabled": true
    }
  }
}
```

## Knowledge Graph Organization

Suggested graph structure for this project:

```
mattkelly.io
├── Technologies
│   ├── Rails 8
│   │   ├── Importmap
│   │   ├── Hotwire (Turbo + Stimulus)
│   │   └── ViewComponents
│   ├── JavaScript
│   │   ├── ES6 Modules
│   │   ├── Browser Caching
│   │   └── UMD Libraries
│   └── DragonRuby WASM
├── Features
│   ├── Terminal Emulator
│   │   ├── Commands
│   │   ├── Filesystem (Filer.js)
│   │   └── Known Issues
│   ├── Blog System
│   └── DragonRuby Tutorials
├── Patterns
│   ├── Stimulus Controller Patterns
│   ├── Command Implementation
│   └── ViewComponent Usage
└── Solutions
    ├── Cache Issues → Hard Refresh
    ├── Cursor Positioning → State Before Render
    └── UMD Modules → Script Tag + Global
```

## Maintenance

Periodically review and clean up the knowledge graph:

```bash
# List all memories
openmemory_list_memories

# Delete outdated or duplicate memories
openmemory_delete_memories(["id1", "id2"])
```

Keep the graph focused, accurate, and useful.
