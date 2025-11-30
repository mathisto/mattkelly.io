# Development Setup

Complete guide to setting up your local development environment for mattkelly.io.

## Prerequisites

### Required
- **Ruby 3.3.0+** - Check with `ruby -v`
- **Bundler** - Check with `bundle -v`
- **SQLite3** - Check with `sqlite3 --version`

### Optional but Recommended
- **mise** - Runtime version manager (see `mise.toml`)
- **Git** - For version control

## Initial Setup

### 1. Clone the Repository

```bash
git clone https://github.com/mathisto/mattkelly.io.git
cd mattkelly.io
```

### 2. Install Dependencies

```bash
# Install Ruby gems
bundle install

# Note: No npm install needed! 
# This project uses importmap-rails (no Node.js required)
```

### 3. Setup Database

```bash
# Create and migrate database
bin/rails db:create
bin/rails db:migrate

# Optional: Load seed data
bin/rails db:seed
```

### 4. Start Development Server

```bash
# Start the Rails server with all dependencies
bin/dev

# Your site will be available at:
# http://localhost:3000
```

## Development Workflow

### Running the Server

The `bin/dev` command starts:
- Rails server (port 3000)
- Tailwind CSS watcher (auto-compiles styles)
- Any other necessary processes

### Making JavaScript Changes

**Important**: This project uses importmap-rails, NOT a build step!

1. Edit files in `app/javascript/`
2. **Hard refresh** your browser: `Cmd+Shift+R` (Mac) or `Ctrl+Shift+F5` (Windows)
3. Or keep DevTools open with "Disable cache" checked

See [Rails Importmap Guide](../architecture/rails-importmap.md) for details.

### Running Tests

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/tutorial_spec.rb

# Run system tests
bundle exec rspec spec/system/
```

### Code Quality

```bash
# Run Rubocop linter
bundle exec rubocop

# Auto-fix issues
bundle exec rubocop -a
```

## Troubleshooting

### JavaScript Changes Not Appearing

**Problem**: Changed JavaScript but browser still shows old code.

**Solution**:
1. Hard refresh: `Cmd+Shift+R` (Mac) or `Ctrl+Shift+F5` (Windows)
2. Or disable cache in DevTools (keep DevTools open)
3. See [Debugging JavaScript](../guides/debugging-javascript.md)

### Asset Compilation Issues

**Problem**: Styles not loading or outdated.

**Solution**:
```bash
# Clear Rails cache
bin/rails tmp:clear

# Restart dev server
bin/dev
```

### Database Issues

**Problem**: Migration errors or database locked.

**Solution**:
```bash
# Reset database (WARNING: destroys data)
bin/rails db:reset

# Or just rollback and re-migrate
bin/rails db:rollback
bin/rails db:migrate
```

### Port Already in Use

**Problem**: Can't start server, port 3000 in use.

**Solution**:
```bash
# Find process using port 3000
lsof -i :3000

# Kill the process
kill -9 <PID>

# Or use different port
bin/rails server -p 3001
```

## Environment Variables

Create a `.env` file for local configuration:

```bash
# Copy example env file
cp .env.example .env

# Edit with your values
# GITHUB_TOKEN=your_token_here
```

See `.env.example` for all available options.

## Useful Commands

```bash
# Rails console
bin/rails console

# Database console
bin/rails dbconsole

# View routes
bin/rails routes

# Run migrations
bin/rails db:migrate

# Rollback migration
bin/rails db:rollback

# Generate controller
bin/rails generate controller ControllerName

# Generate model
bin/rails generate model ModelName
```

## IDE Setup

### VS Code
Recommended extensions:
- Ruby LSP
- ERB Formatter/Beautify
- Tailwind CSS IntelliSense
- Stimulus LSP

### RubyMine
Project should work out of the box with default Rails configuration.

## Next Steps

- Explore the [Architecture](../architecture/) to understand the codebase
- Read [Adding Terminal Commands](../guides/adding-terminal-commands.md) to extend features
- Check out [Contributing Guide](../contributing/agents-guide.md) for AI agents
