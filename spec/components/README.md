# Component Library Documentation

Tokyo Night themed ViewComponent library with Lookbook previews.

## Accessing Lookbook

**Development:** Visit `/lookbook` in your browser after starting the Rails server

```bash
bin/dev
# Then navigate to http://localhost:3000/lookbook
```

## Structure

```
spec/components/
├── docs/              # Lookbook documentation pages
│   ├── 00_welcome.md.erb
│   ├── 01_overview.md.erb
│   ├── 02_ui_components.md.erb
│   ├── 03_card_components.md.erb
│   ├── 04_terminal_components.md.erb
│   ├── 05_layout_components.md.erb
│   ├── 06_animation_components.md.erb
│   └── 07_contributing.md.erb
└── previews/          # Component previews
    ├── animations/    # Animation component previews
    ├── card/          # Card component previews
    ├── layout/        # Layout component previews
    ├── terminal/      # Terminal component previews
    └── ui/            # UI component previews
```

## Tokyo Night Theme

Lookbook is configured with Tokyo Night colors in `config/application.rb`:

**Primary Colors:**
- Blue: `#7aa2f7` (primary actions, links)
- Purple: `#bb9af7` (accents)
- Cyan: `#7dcfff` (info states)
- Green: `#9ece6a` (success)

**Backgrounds:**
- Main: `#1a1b26`
- Dark: `#16161e`
- Float: `#1f2335`

**Text:**
- Primary: `#a9b1d6`
- Secondary: `#787c99`
- Comments: `#565f89`

## Component Categories

### UI Components (5 previews)
- ButtonComponent - Primary, ghost, link variants
- BadgeComponent - Default, skill, tag variants
- IconComponent - Solid, brands, devicons
- LinkComponent - Default and external links

### Card Components (3 previews)
- BaseComponent - Foundation with slots
- PostComponent - Blog post cards
- ProjectComponent - Project showcase cards

### Terminal Components (1 preview)
- Terminal::Component - Terminal UI with prompts

### Layout Components (2 previews)
- ContainerComponent - Max-width containers
- GridComponent - Responsive grids

### Animation Components (2 previews)
- FadeInComponent - Fade in on scroll
- SlideUpComponent - Slide up on scroll

## Creating New Previews

### 1. Create Preview File
Location: `spec/components/previews/namespace/component_name_component_preview.rb`

```ruby
class Namespace::ComponentNameComponentPreview < Lookbook::Preview
  # Scenario title
  # ---------------
  # Brief description
  # @param name type "Description"
  def scenario_name(name: "default")
    render Namespace::ComponentNameComponent.new(param: name)
  end
end
```

### 2. Create Preview Template (Optional)
Location: `spec/components/previews/namespace/component_name_component_preview/scenario.html.erb`

```erb
<div class="grid grid-cols-3 gap-4">
  <%= render ComponentName.new(variant: :primary) %>
  <%= render ComponentName.new(variant: :secondary) %>
</div>
```

### 3. Document in Lookbook Pages
Add usage examples and documentation to relevant page in `spec/components/docs/`

## Preview Best Practices

**Multiple Scenarios:** Show all variants and use cases
**Documentation:** Use comments to describe each scenario
**Parameters:** Use `@param` tags for dynamic previews
**Templates:** Use `render_with_template` for complex layouts
**Naming:** Use descriptive scenario names

## Documentation Pages

Pages support:
- **Markdown** - Full CommonMark syntax
- **ERB** - Embedded Ruby templates
- **Frontmatter** - YAML metadata
- **Preview Embeds** - `<%= embed "path/to/preview" %>`

### Creating New Pages

Location: `spec/components/docs/NN_page_name.md.erb`

```markdown
---
title: Page Title
label: Nav Label
---

# Page Content

Regular markdown with ERB support.

<%= embed "ui/button/primary" %>
```

## Theming

Tokyo Night theme configured in `config/application.rb`:

```ruby
config.lookbook.ui_theme_overrides = {
  accent_200: "#7aa2f7",  # Tokyo Night blue
  base_900: "#1a1b26",    # Tokyo Night bg
  # ... full configuration in application.rb
}
```

## Resources

- [Lookbook Documentation](https://lookbook.build)
- [ViewComponent Guide](https://viewcomponent.org)
- [Tokyo Night Theme](https://github.com/enkia/tokyo-night-vscode-theme)
