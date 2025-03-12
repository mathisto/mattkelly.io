# Developer Landing Page Implementation Checklist

## Phase 1: Project Setup & Foundation

### Project Initialization
- [x] Create new Rails 8 application with SQLite
- [x] Configure Git repository
- [x] Create initial .gitignore file
- [x] Write meaningful README.md
- [x] Add .ruby-version file
- [x] Set up Gemfile with initial dependencies
- [x] Run bundle install
- [x] Make initial commit

### Testing Environment Setup
- [x] Add RSpec
- [x] Configure RSpec initial settings
- [x] Add Capybara for integration testing
- [x] Configure FactoryBot
- [x] Set up DatabaseCleaner
- [x] Add SimpleCov for code coverage
- [x] Configure spec_helper.rb and rails_helper.rb
- [ ] Create sample test to verify setup
- [ ] Verify test suite runs correctly

### Tailwind CSS and Typography
- [x] Install cssbundling-rails gem
- [x] Set up Tailwind CSS configuration
- [x] Configure PostCSS
- [x] Add custom font families:
  - [x] Montserrat for headings
  - [x] Lato for body text
  - [x] Fira Code for code snippets
- [x] Create typography configuration
- [x] Set up build process
- [x] Create script for watching CSS changes
- [x] Create test page for typography
- [x] Test that styles compile correctly
- [x] Test that font families are applied correctly

### Tokyo Night Theme
- [x] Research Tokyo Night color palette
- [x] Create CSS variables for all theme colors
- [x] Set up dark variant colors
- [x] Set up light variant colors
- [x] Create base stylesheet using theme variables
- [x] Create theme showcase page
- [x] Test for proper color application
- [x] Verify contrast ratios for accessibility
- [x] Test colors on various elements

### Layout and Navigation
- [x] Create base layout template
- [x] Implement header partial
- [x] Create fixed navigation bar
- [x] Add navigation links
- [ ] Implement footer partial
- [ ] Add placeholder social links:
  - [ ] GitHub (https://github.com/mathisto)
  - [ ] LinkedIn (https://www.linkedin.com/in/themattkellyshow/)
  - [ ] Email (matthew.ryan.kelly@gmail.com)
- [x] Style navigation for mobile responsiveness
- [x] Test navigation for various screen sizes
- [x] Test that all links work correctly

### Dark/Light Mode Toggle
- [x] Add Stimulus to the application
- [x] Create theme-switcher Stimulus controller
- [x] Add toggle button in navigation
- [x] Implement JavaScript for theme switching
- [x] Add localStorage for saving preference
- [x] Implement system preference detection
- [x] Add transition styles for smooth switching
- [x] Test theme switching works correctly
- [x] Test theme preference persistence

## Phase 2: Core Models & Data

### Projects Model
- [ ] Generate Projects model with fields:
  - [ ] title (string, null: false)
  - [ ] description (text)
  - [ ] technologies_used (text)
  - [ ] role (string)
  - [ ] duration (string)
  - [ ] github_url (string)
  - [ ] live_site_url (string)
  - [ ] screenshot_url (string)
  - [ ] highlight (boolean, default: false)
  - [ ] position (integer)
- [ ] Add validations
- [ ] Add scopes for filtering and ordering
- [ ] Create database migration
- [ ] Write model tests
- [ ] Create factory for Projects
- [ ] Run migrations
- [ ] Test all validations and methods

### Posts Model
- [ ] Generate Posts model with fields:
  - [ ] title (string, null: false)
  - [ ] slug (string, null: false)
  - [ ] content (text)
  - [ ] published_at (datetime)
  - [ ] featured_image_url (string)
  - [ ] status (string, default: "draft")
- [ ] Add validations
- [ ] Create unique index on slug
- [ ] Add slug generation callback
- [ ] Add scopes for filtering and ordering
- [ ] Create database migration
- [ ] Write model tests
- [ ] Create factory for Posts
- [ ] Run migrations
- [ ] Test slug generation
- [ ] Test all validations and scopes

### Static Pages Controller
- [ ] Generate Pages controller
- [ ] Add actions for home, about, experience
- [ ] Set up routes
- [ ] Create basic view templates
- [ ] Write controller tests
- [ ] Create integration tests
- [ ] Test all routes and views

### Projects Controller
- [ ] Generate Projects controller
- [ ] Add index and show actions
- [ ] Set up RESTful routes
- [ ] Create view templates
- [ ] Write controller tests
- [ ] Create integration tests
- [ ] Test all routes and views

### Markdown Processing
- [ ] Add Redcarpet gem
- [ ] Create markdown helper module
- [ ] Implement parsing methods
- [ ] Create service for reading markdown files
- [ ] Set up directory for markdown files
- [ ] Write tests for markdown functionality
- [ ] Test markdown rendering
- [ ] Test file reading functionality

### Blog Controller
- [ ] Generate Posts controller
- [ ] Add index and show actions
- [ ] Set up RESTful routes
- [ ] Create view templates
- [ ] Integrate markdown processing
- [ ] Write controller tests
- [ ] Create integration tests
- [ ] Test all routes and views

### Resume Data Seeding
- [ ] Parse resume data
- [ ] Create seed file for projects
- [ ] Create seed file for sample blog posts
- [ ] Make seed process idempotent
- [ ] Write tests for seed data
- [ ] Test seed process
- [ ] Verify data is correctly seeded

## Phase 3: Page Implementation

### Home Page
- [ ] Design home page layout
- [ ] Implement hero section
- [ ] Add introduction section
- [ ] Create skills highlights section
- [ ] Add quick links to other sections
- [ ] Style according to Tokyo Night theme
- [ ] Make responsive
- [ ] Add SEO metadata
- [ ] Write tests for home page
- [ ] Test responsiveness
- [ ] Test all links and sections

### About Me Section
- [ ] Design About page layout
- [ ] Add personal introduction
- [ ] Create photo grid
- [ ] Add placeholder photos
- [ ] Add family and interests information
- [ ] Style according to Tokyo Night theme
- [ ] Make responsive
- [ ] Add SEO metadata
- [ ] Write tests for About page
- [ ] Test photo display
- [ ] Test responsiveness

### Experience Timeline
- [ ] Design timeline layout
- [ ] Extract experience data from resume
- [ ] Create timeline component
- [ ] Populate with work history
- [ ] Style according to Tokyo Night theme
- [ ] Make responsive
- [ ] Add SEO metadata
- [ ] Write tests for Experience page
- [ ] Test timeline display
- [ ] Test responsiveness

### Projects Grid
- [ ] Design project card component
- [ ] Create responsive grid layout
- [ ] Connect to Projects model data
- [ ] Add GitHub and live site links
- [ ] Style according to Tokyo Night theme
- [ ] Make responsive
- [ ] Add SEO metadata
- [ ] Write tests for Projects page
- [ ] Test card display
- [ ] Test all links
- [ ] Test responsiveness

### Blog Implementation
- [ ] Design blog index page
- [ ] Design blog post detail page
- [ ] Implement markdown file reading
- [ ] Display parsed markdown content
- [ ] Add styling for markdown elements
- [ ] Style according to Tokyo Night theme
- [ ] Make responsive
- [ ] Add SEO metadata
- [ ] Write tests for Blog functionality
- [ ] Test markdown display
- [ ] Test responsiveness

## Phase 4: Refinement & Deployment

### SEO and Metadata
- [ ] Create SEO helper module
- [ ] Add methods for meta tags
- [ ] Implement structured data (JSON-LD)
- [ ] Create sitemap
- [ ] Add robots.txt
- [ ] Implement canonical URLs
- [ ] Add meta tags to all pages
- [ ] Test SEO implementation
- [ ] Validate structured data
- [ ] Test all meta tags

### Responsive Design Fine-tuning
- [ ] Review layouts for all screen sizes
- [ ] Optimize for mobile devices
- [ ] Optimize for tablets
- [ ] Optimize for desktops
- [ ] Optimize for large screens
- [ ] Test navigation on small screens
- [ ] Ensure consistent spacing
- [ ] Check typography across devices
- [ ] Test with multiple browsers
- [ ] Write responsive design tests

### Accessibility
- [ ] Add ARIA attributes
- [ ] Implement keyboard navigation
- [ ] Verify color contrast
- [ ] Add skip navigation links
- [ ] Ensure form controls have labels
- [ ] Add focus styles
- [ ] Test with screen readers
- [ ] Run automated accessibility tests
- [ ] Fix any accessibility issues
- [ ] Test with keyboard only

### Fly.io Deployment
- [ ] Create Dockerfile
- [ ] Add fly.toml configuration
- [ ] Configure database handling
- [ ] Set up environment variables
- [ ] Configure asset compilation
- [ ] Set up logging
- [ ] Create deployment scripts
- [ ] Document deployment process
- [ ] Test deployment locally
- [ ] Deploy to Fly.io

### Final Integration and QA
- [ ] Run comprehensive test suite
- [ ] Check for unlinked code
- [ ] Verify all functionality
- [ ] Review for optimizations
- [ ] Test all forms and interactions
- [ ] Check all links
- [ ] Validate HTML
- [ ] Validate CSS
- [ ] Fix any remaining issues
- [ ] Document future enhancements

## Additional Tasks

### Content Development
- [ ] Write personal introduction
- [ ] Create content for About Me section
- [ ] Prepare project descriptions
- [ ] Write sample blog posts
- [ ] Gather and optimize photos
- [ ] Create experience descriptions
- [ ] Write skills descriptions

### Design Inspiration
- [ ] Terminal-style interface elements:
  - [ ] Implement command prompt styling
  - [ ] Add cursor blink animation
  - [ ] Create typewriter text effect
- [ ] Minimalist navigation:
  - [ ] Simple command-like menu structure
  - [ ] Clean typography for commands
  - [ ] Subtle hover effects
- [ ] Create language switcher component
- [ ] Implement clean card layouts for projects
- [ ] Add subtle animations for state changes

### Performance Optimization
- [ ] Optimize asset delivery
- [ ] Add image lazy loading
- [ ] Implement caching where appropriate
- [ ] Optimize CSS and JavaScript
- [ ] Run performance audits
- [ ] Fix any performance issues
- [ ] Test load times

### Version 2.0 Features (Future)
- [ ] Plan admin interface for content management
- [ ] Design project filtering capabilities
- [ ] Plan advanced blog features
- [ ] Document future enhancements
