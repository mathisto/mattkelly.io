# Personal Developer Landing Page Specification

## Project Overview
Create a personal developer landing page that serves as a living resume, implemented with Rails 7 using modern practices and a minimalist design aesthetic.

## Design & UX Requirements

### Visual Design
- **Color Scheme**: Tokyo Night (with light/dark variants)
- **Typography**:
  - Headings: Montserrat
  - Body Text: Lato
  - Code Snippets: Fira Code
- **Layout**: Mobile-first, responsive design
- **Style**: Minimalist developer aesthetic with clean typography
- **Theme Toggle**: Dark/light mode using Tokyo Night variants

### Navigation & Structure
- **Navigation Type**: Fixed top navbar
- **Main Sections**:
  1. Home (landing page with key info)
  2. About Me (personal info and family)
  3. Experience (work history)
  4. Projects (portfolio cards)
  5. Blog (markdown-based posts)
- **Social Links**: GitHub, LinkedIn, and email as icon links in navbar

## Technical Specifications

### Framework & Libraries
- **Backend**: Rails 7.x (latest stable version)
- **Database**: SQLite
- **Frontend**:
  - Hotwire (Turbo & Stimulus) for SPA-like experience
  - Tailwind CSS for styling
  - CSS variables for theme management
- **Markdown Parser**: Redcarpet for blog posts

### Data Models

#### Projects Model
```ruby
create_table "projects", force: :cascade do |t|
  t.string "title", null: false
  t.text "description"
  t.text "technologies_used"
  t.string "role"
  t.string "duration"
  t.string "github_url"
  t.string "live_site_url"
  t.string "screenshot_url"
  t.boolean "highlight", default: false
  t.integer "position"
  t.timestamps
end
```

#### Posts Model
```ruby
create_table "posts", force: :cascade do |t|
  t.string "title", null: false
  t.string "slug", null: false
  t.text "content"
  t.datetime "published_at"
  t.string "featured_image_url"
  t.string "status", default: "draft"
  t.timestamps
  t.index ["slug"], name: "index_posts_on_slug", unique: true
end
```

### Key Features

#### Home Page
- Resume information populated from attached document
- Highlight key skills: Ruby, Rails, Kubernetes, DevOps, PostgreSQL, AWS/Cloud Services
- Professional introduction derived from LinkedIn profile

#### About Me Section
- Personal information about you and your family
- 2-3 photos displayed in a grid layout
- Styled text content

#### Experience Timeline
- Professional experience pulled from resume
- Chronological layout
- Emphasis on key achievements

#### Projects Display
- Grid-based layout with cards
- Each card includes:
  - Project name
  - Description
  - Technologies used
  - Your role
  - Duration
  - Screenshots/demos
  - Links to GitHub/live sites

#### Blog Implementation
- Simple implementation using Redcarpet to parse Markdown
- Blog posts stored as .md files in a designated folder
- No tags/categories, search, or comments required
- Posts displayed in reverse chronological order

### Technical Implementation Details

#### Asset Management
- Images stored and served via the Rails asset pipeline
- Favicon using lambda symbol
- Static design without animations

#### Accessibility
- Semantic HTML structure
- ARIA attributes where needed
- Keyboard navigation support
- Sufficient color contrast ratios

#### SEO
- Appropriate metadata tags
- Structured data for better search engine understanding
- Canonical URLs for all pages

#### Responsive Design
- Mobile-first approach
- Flexible grid layouts using CSS Grid and Flexbox
- Appropriate breakpoints for different device sizes

#### Theme Implementation
- CSS variables for Tokyo Night color palette
- JavaScript toggle for switching between light/dark modes
- Local storage to remember user preference

## Deployment

### Hosting
- Setup for deployment to Fly.io
- Configuration files included in the repo

### Required Files
- `fly.toml` configuration
- Dockerfile optimized for Rails 7
- Appropriate GitHub Actions workflow (optional)

## Error Handling
- Custom 404 and 500 error pages
- Graceful fallbacks for images/assets
- Proper validation for form inputs
- Logging for debugging purposes

## Testing Strategy
- Model tests for database operations
- System tests for critical user flows
- View component tests for UI elements
- Accessibility testing

## Future Enhancements (Version 2.0)
- Admin interface for updating resume information
- More advanced blog features (tags, search)
- Project filtering capabilities
- Content management system

## Data Population
- Resume information hardcoded from the provided document
- GitHub: https://github.com/mathisto
- LinkedIn: https://www.linkedin.com/in/themattkellyshow/
- Email: matthew.ryan.kelly@gmail.com

## Development Environment Setup
- Ruby version: 3.2.x or higher
- Bundle install for dependencies
- Database creation and migration
- Asset compilation instructions
