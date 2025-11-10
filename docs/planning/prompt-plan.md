# Rails Personal Developer Landing Page Implementation Blueprint

I'll create a detailed, step-by-step blueprint for building your personal developer landing page, breaking it down into well-sized, manageable chunks that build incrementally.

## Overall Project Blueprint

### Phase 1: Project Setup & Foundation
1. Initialize Rails 7 application with SQLite
2. Configure Tailwind CSS and typography
3. Set up Tokyo Night theme with CSS variables
4. Create basic layout and navigation structure
5. Implement dark/light mode toggle
6. Basic testing setup

### Phase 2: Core Models & Data
1. Create Projects model and migrations
2. Create Posts model and migrations
3. Seed initial data from resume
4. Set up static content controllers
5. Implement markdown processing

### Phase 3: Page Implementation
1. Implement home page with resume information
2. Build About Me section with photo display
3. Create Experience timeline from resume data
4. Develop Projects page with card grid
5. Implement Blog functionality with markdown files

### Phase 4: Refinement & Deployment
1. Optimize SEO and metadata
2. Configure responsive design fine-tuning
3. Implement accessibility features
4. Set up Fly.io deployment configuration
5. Final testing and quality assurance

Now, I'll break these down into more detailed, right-sized steps:

## Detailed Implementation Prompts

### Phase 1: Project Setup & Foundation

#### Prompt 1: Initial Rails Application Setup

```
Create a new Rails 7 application called "developer_landing_page" with the following specifications:
- Use SQLite as the database
- Skip Hotwire installation initially (we'll add it manually)
- Skip test unit (we'll use RSpec)
- Set up with minimal dependencies

After creating the initial app:
1. Add RSpec for testing
2. Configure Git repository
3. Create initial .gitignore file with appropriate entries
4. Create a meaningful README.md describing the project

The initial project structure should be clean and follow Rails conventions. Write a simple test to verify the application boots correctly.
```

#### Prompt 2: Tailwind CSS and Typography Configuration

```
Add Tailwind CSS to the Rails application with the following specifications:
1. Install Tailwind CSS using the cssbundling-rails gem
2. Configure PostCSS for processing
3. Set up the font families we discussed:
   - Montserrat for headings
   - Lato for body text
   - Fira Code for code snippets
4. Create a basic typography.css file with appropriate styling
5. Set up the build process for CSS

Ensure that all styles are properly compiled and available in the application. Create a simple page with typography examples to verify the configuration is working correctly. Include headings (h1-h6), paragraphs, lists, and code blocks in your test page.
```

#### Prompt 3: Tokyo Night Theme Implementation

```
Implement the Tokyo Night color scheme using CSS variables with light and dark variants:

1. Research the official Tokyo Night color palette
2. Create a color variables file with all necessary colors defined as CSS custom properties
3. Set up a basic color scheme system that uses these variables throughout the application
4. Define two sets of colors: one for dark mode and one for light mode
5. Ensure proper contrast ratios for accessibility
6. Create a simple test page showcasing all color variables in use

The colors should be organized logically (primary, secondary, accents, backgrounds, text). Make sure colors work well together and maintain sufficient contrast ratios for accessibility.
```

#### Prompt 4: Basic Layout and Navigation Structure

```
Create the basic layout structure for the application, focusing on the essential components:

1. Implement a header partial with the fixed navigation bar
2. Add navigation links for Home, About, Experience, Projects, and Blog
3. Create a footer partial with minimal content
4. Implement the basic shared layout template that will be used across all pages
5. Add icon links for GitHub, LinkedIn, and email in the navbar
6. Style the navigation to be responsive (mobile-first)
7. Create simple placeholder pages for each main section

The navigation should be clean, professional, and follow the Tokyo Night theme. Test the navigation on various screen sizes to ensure proper responsiveness.
```

#### Prompt 5: Dark/Light Mode Toggle

```
Implement a dark/light mode toggle for the Tokyo Night theme:

1. Create a Stimulus controller for handling theme switching
2. Add a toggle button in the navigation bar with appropriate icons for sun/moon
3. Store the user's preference in localStorage
4. Apply the appropriate CSS classes based on the selected theme
5. Ensure a smooth transition between themes
6. Make sure the theme persists across page loads
7. Default to the system preference for initial load

Write tests to verify that the theme switching works properly, persists between page loads, and correctly applies all theme colors.
```

#### Prompt 6: Testing Environment Setup

```
Set up a comprehensive testing environment for the application:

1. Configure RSpec with appropriate settings
2. Add Capybara for integration testing
3. Set up FactoryBot for test data generation
4. Configure DatabaseCleaner for test database management
5. Add SimpleCov for code coverage tracking
6. Create a basic test helper that includes all necessary configurations
7. Write sample tests for existing functionality

Ensure that tests are fast, reliable, and provide good coverage. Set up CI workflow if applicable.
```

### Phase 2: Core Models & Data

#### Prompt 7: Projects Model Implementation

```
Create the Projects model with the following specifications:

1. Generate the model with appropriate fields:
   - title (string, null: false)
   - description (text)
   - technologies_used (text)
   - role (string)
   - duration (string)
   - github_url (string)
   - live_site_url (string)
   - screenshot_url (string)
   - highlight (boolean, default: false)
   - position (integer)

2. Add validations for required fields
3. Add any necessary scopes (e.g., highlighted, ordered by position)
4. Create the database migration
5. Write comprehensive tests for the model
6. Create a factory for the Projects model

Ensure that the model is fully tested and validates all required fields properly.
```

#### Prompt 8: Posts Model Implementation

```
Create the Posts model with the following specifications:

1. Generate the model with appropriate fields:
   - title (string, null: false)
   - slug (string, null: false)
   - content (text)
   - published_at (datetime)
   - featured_image_url (string)
   - status (string, default: "draft")

2. Add validations for required fields
3. Create a unique index on the slug field
4. Add a callback to generate slugs automatically from titles
5. Add scopes for published posts, draft posts, and ordering by publication date
6. Write comprehensive tests for the model
7. Create a factory for the Posts model

Ensure that the model generates slugs correctly and handles validation properly.
```

#### Prompt 9: Seed Data from Resume

```
Create seed data based on the provided resume information:

1. Parse the resume data to extract relevant information
2. Create seed data for professional experiences
3. Create seed data for skills and technologies
4. Create seed data for sample projects (placeholders that can be updated later)
5. Create seed data for sample blog posts
6. Ensure the seed process is idempotent (can be run multiple times without duplicating data)
7. Write tests to verify that the seed data is loaded correctly

The seed data should accurately reflect the information from the resume and be well-structured.
```

#### Prompt 10: Static Content Controllers

```
Create controllers for the static content pages:

1. Generate a Pages controller for static pages:
   - home
   - about
   - experience
2. Create a Projects controller for the projects display
3. Create a Posts controller for the blog
4. Set up appropriate routes for all controllers
5. Create placeholder view templates for each page
6. Implement controller tests
7. Create basic integration tests for each page

The controllers should follow Rails conventions and be properly tested.
```

#### Prompt 11: Markdown Processing Setup

```
Set up markdown processing for blog posts:

1. Add the Redcarpet gem
2. Create a markdown helper module with necessary parsing methods
3. Set up a mechanism to read markdown files from a directory
4. Create a service object for processing markdown content
5. Add support for basic markdown features:
   - Headers
   - Lists
   - Code blocks with syntax highlighting
   - Links
   - Images
6. Write tests for the markdown parsing functionality
7. Create a sample markdown file for testing

The markdown processing should handle all basic markdown syntax and output clean HTML.
```

### Phase 3: Page Implementation

#### Prompt 12: Home Page Implementation

```
Implement the home page with resume information:

1. Create a controller action for the home page
2. Design the layout for the home page:
   - Hero section with name and title
   - Brief professional introduction
   - Skills highlight section for Ruby, Rails, Kubernetes, DevOps, PostgreSQL, AWS/Cloud Services
   - Quick links to other sections
3. Style the page according to the Tokyo Night theme
4. Ensure the page is responsive
5. Add animations for the hero section if desired
6. Write tests for the home page
7. Optimize the page for SEO

The home page should look professional and provide a good overview of your skills and experience.
```

#### Prompt 13: About Me Section

```
Implement the About Me section:

1. Create a controller action for the About page
2. Design the layout for the About page:
   - Personal introduction
   - Grid for 2-3 photos
   - Information about family and personal interests
3. Add placeholder images with appropriate styling
4. Style the page according to the Tokyo Night theme
5. Ensure the page is responsive
6. Write tests for the About page
7. Add appropriate metadata for SEO

The About Me page should be personal and give insight into who you are outside of your professional life.
```

#### Prompt 14: Experience Timeline

```
Implement the Experience timeline from resume data:

1. Create a controller action for the Experience page
2. Design a vertical timeline layout for work experiences
3. Populate the timeline with data from the resume:
   - Job titles
   - Companies
   - Dates
   - Responsibilities
   - Key achievements
4. Style the timeline according to the Tokyo Night theme
5. Make the timeline responsive
6. Add micro-interactions for better UX
7. Write tests for the Experience page

The timeline should clearly show your professional progression and highlight key achievements.
```

#### Prompt 15: Projects Page with Card Grid

```
Implement the Projects page with a card grid:

1. Create controller actions for listing projects
2. Design a card component for individual projects
3. Implement a responsive grid layout for the cards
4. Style project cards according to the Tokyo Night theme
5. Include in each card:
   - Project title
   - Description
   - Technologies used
   - Role
   - Duration
   - Links to GitHub and live site
   - Screenshot (if available)
6. Add hover effects for better UX
7. Write tests for the Projects page and components

The Projects page should showcase your work in an attractive and informative way.
```

#### Prompt 16: Blog Functionality

```
Implement the Blog functionality with markdown files:

1. Create controller actions for listing and showing blog posts
2. Design a blog index page with post previews
3. Implement a blog post detail page
4. Set up a mechanism to:
   - Read markdown files from a designated folder
   - Parse them with Redcarpet
   - Display them with proper formatting
5. Create a sample blog post to test the functionality
6. Style both pages according to the Tokyo Night theme
7. Write tests for the Blog functionality

The blog should display posts in a clean, readable format with proper typography.
```

### Phase 4: Refinement & Deployment

#### Prompt 17: SEO and Metadata Optimization

```
Implement SEO and metadata optimization:

1. Create a SEO helper module with methods for:
   - Title tags
   - Meta descriptions
   - Open Graph tags
   - Twitter Card tags
2. Add structured data using JSON-LD for:
   - Person
   - Professional experience
   - Blog posts
3. Create a sitemap
4. Implement canonical URLs
5. Add a robots.txt file
6. Set up appropriate meta tags for each page
7. Test SEO implementation with validation tools

The site should be well-optimized for search engines with appropriate metadata.
```

#### Prompt 18: Responsive Design Fine-tuning

```
Fine-tune the responsive design:

1. Review and refine all page layouts for various screen sizes
2. Implement specific optimizations for:
   - Mobile phones
   - Tablets
   - Desktops
   - Large screens
3. Test navigation behavior on small screens
4. Optimize images for different screen sizes
5. Ensure consistent spacing and typography across all device sizes
6. Test with various browsers
7. Write responsive design tests

The site should look and function well on all screen sizes and common browsers.
```

#### Prompt 19: Accessibility Implementation

```
Implement accessibility features:

1. Add proper ARIA attributes where needed
2. Ensure keyboard navigation works for all interactive elements
3. Verify sufficient color contrast for all text
4. Add skip navigation links
5. Ensure form controls have associated labels
6. Add focus styles for interactive elements
7. Test with screen readers
8. Run automated accessibility tests

The site should be accessible to users with disabilities and comply with WCAG guidelines.
```

#### Prompt 20: Fly.io Deployment Configuration

```
Set up Fly.io deployment configuration:

1. Create a Dockerfile optimized for Rails 7
2. Add a fly.toml configuration file
3. Configure database backups
4. Set up environment variables
5. Configure asset compilation for production
6. Set up logging
7. Create deployment scripts or GitHub Actions workflow
8. Document the deployment process

The deployment configuration should be complete and well-documented, making it easy to deploy the site to Fly.io.
```

#### Prompt 21: Final Integration and Quality Assurance

```
Perform final integration and quality assurance:

1. Review all implemented features
2. Run comprehensive test suite
3. Check for any unlinked or orphaned code
4. Ensure all pages link correctly to each other
5. Verify that all functionality works as expected
6. Review code for potential optimizations
7. Document any remaining issues or future enhancements
8. Create a final pull request that integrates all components

The final integration should bring all components together into a cohesive application without any unconnected parts.
```

## Code Generation Prompts Collection

Let's now organize these detailed steps into a series of code generation prompts for a test-driven implementation approach:

### Prompt 1: Project Initialization

```
Create a new Rails 7 application called "developer_landing_page" with SQLite as the database.

1. Generate a new Rails 7 application with minimal dependencies
2. Configure RSpec for testing
3. Set up a basic .gitignore and README.md
4. Create an initial commit

Ensure the application boots correctly and write a simple test to verify this. Focus on creating a clean, minimal starting point for the project.
```

### Prompt 2: Testing Environment Setup

```
Building on the initialized Rails application, set up a comprehensive testing environment:

1. Add and configure the following gems:
   - rspec-rails
   - capybara
   - factory_bot_rails
   - database_cleaner-active_record
   - simplecov

2. Create a spec_helper.rb and rails_helper.rb with appropriate configurations
3. Create a sample test to verify the setup

Ensure that tests are properly configured to run quickly and provide meaningful feedback.
```

### Prompt 3: Tailwind CSS and Typography Setup

```
Add Tailwind CSS to the application and configure typography:

1. Install the cssbundling-rails gem and set up Tailwind CSS
2. Configure PostCSS and any necessary plugins
3. Add custom font families:
   - Montserrat for headings
   - Lato for body text
   - Fira Code for code snippets
4. Create a basic typography configuration in Tailwind
5. Set up the build process and add necessary scripts
6. Create a simple page to test the typography

Write tests to verify that the styles are being applied correctly. Ensure the build process works without errors.
```

### Prompt 4: Tokyo Night Theme Implementation

```
Implement the Tokyo Night color scheme using CSS variables:

1. Research the Tokyo Night color palette and create CSS variables for all colors
2. Set up dark and light variants of the theme
3. Create a basic stylesheet that uses these variables
4. Add a simple page to showcase the theme
5. Ensure proper contrast ratios for accessibility

Write tests to verify that the theme colors are applied correctly and meet accessibility standards.
```

### Prompt 5: Layout and Navigation Structure

```
Create the basic layout and navigation structure:

1. Implement a header partial with a fixed navigation bar
2. Add navigation links for all main sections
3. Create a footer partial
4. Implement the basic shared layout template
5. Add placeholders for social media and contact links in the navbar
6. Style the navigation to be responsive

Write tests to verify that the navigation works correctly and is responsive across different screen sizes.
```

### Prompt 6: Dark/Light Mode Toggle with Stimulus

```
Implement a dark/light mode toggle using Stimulus:

1. Add Stimulus to the application if not already present
2. Create a theme-switcher Stimulus controller
3. Add a toggle button in the navigation bar
4. Implement theme switching functionality
5. Store the preference in localStorage
6. Apply the appropriate CSS classes for theme switching
7. Default to system preference

Write tests to verify that the theme switching works correctly and persists between page loads.
```

### Prompt 7: Core Models Implementation

```
Create the core models for the application:

1. Generate the Projects model with all required fields and validations
2. Generate the Posts model with all required fields and validations
3. Add appropriate scopes and methods to both models
4. Create database migrations
5. Write comprehensive tests for both models

Ensure that the models validate data correctly and provide all necessary functionality.
```

### Prompt 8: Static Pages Controller

```
Implement controllers for static pages:

1. Generate a Pages controller with actions:
   - home
   - about
   - experience
2. Set up routes for these actions
3. Create basic view templates for each page
4. Add controller tests
5. Add simple integration tests for each page

The controller should follow Rails conventions and be properly tested.
```

### Prompt 9: Projects Controller and Views

```
Implement the Projects controller and views:

1. Generate a Projects controller with index and show actions
2. Set up routes for project listings and details
3. Create view templates for listing projects and showing project details
4. Add controller tests
5. Add integration tests for project pages

Focus on creating a clean, RESTful interface for working with projects.
```

### Prompt 10: Markdown Processing for Blog

```
Set up markdown processing for blog content:

1. Add the Redcarpet gem
2. Create a markdown helper module
3. Implement methods to parse markdown content
4. Create a service to read markdown files from a directory
5. Write tests for markdown parsing functionality

Ensure that markdown is properly parsed and rendered as HTML with appropriate styling.
```

### Prompt 11: Blog Controller and Views

```
Implement the Blog controller and views:

1. Generate a Posts controller with index and show actions
2. Set up routes for blog listings and post details
3. Create view templates for listing posts and showing post content
4. Integrate the markdown processing functionality
5. Add controller tests
6. Add integration tests for blog pages

The blog should display posts in a clean, readable format with proper typography.
```

### Prompt 12: Resume Data Extraction and Seeding

```
Create seed data from the provided resume:

1. Parse the resume data
2. Create seed data for projects based on your past work
3. Create seed data for sample blog posts
4. Make the seed process idempotent
5. Write tests for the seed data

Ensure that the seed data accurately reflects your resume information and is properly structured.
```

### Prompt 13: Home Page Implementation

```
Implement the home page:

1. Design and style the home page layout according to the Tokyo Night theme
2. Add sections for:
   - Hero with name and title
   - Brief introduction
   - Skills highlights
   - Quick links to other sections
3. Make the page responsive
4. Write tests for the home page

Focus on creating an attractive, informative landing page that showcases your skills.
```

### Prompt 14: About Me Section Implementation

```
Implement the About Me section:

1. Design and style the About page layout
2. Add sections for:
   - Personal introduction
   - Photo grid
   - Information about family and interests
3. Make the page responsive
4. Write tests for the About page

Create a personal, engaging page that gives insight into who you are beyond your professional life.
```

### Prompt 15: Experience Timeline Implementation

```
Implement the Experience timeline:

1. Design a vertical timeline layout
2. Populate it with your work history
3. Style it according to the Tokyo Night theme
4. Make it responsive
5. Write tests for the Experience page

Create a clear visualization of your professional progression and key achievements.
```

### Prompt 16: Projects Grid Implementation

```
Implement the Projects grid:

1. Design a card component for projects
2. Create a responsive grid layout
3. Populate it with project data from the database
4. Style it according to the Tokyo Night theme
5. Add links to GitHub and live sites
6. Write tests for the Projects page

Create an attractive showcase for your portfolio projects.
```

### Prompt 17: Blog Implementation with Markdown Files

```
Complete the Blog implementation:

1. Finalize the design for blog index and detail pages
2. Implement functionality to read and display markdown files
3. Style the blog according to the Tokyo Night theme
4. Make it responsive
5. Write tests for the Blog functionality

Create a clean, readable blog with proper typography and formatting.
```

### Prompt 18: SEO and Metadata Implementation

```
Implement SEO and metadata:

1. Create helper methods for meta tags
2. Add structured data using JSON-LD
3. Create a sitemap and robots.txt
4. Set up canonical URLs
5. Add appropriate meta tags to all pages
6. Test the implementation

Optimize the site for search engines with appropriate metadata and structured data.
```

### Prompt 19: Responsive Design Fine-tuning

```
Fine-tune the responsive design:

1. Review and adjust layouts for different screen sizes
2. Optimize navigation for mobile devices
3. Ensure consistent spacing and typography
4. Test with various browsers
5. Write responsive design tests

Make sure the site looks and functions well on all devices and browsers.
```

### Prompt 20: Accessibility Enhancements

```
Implement accessibility features:

1. Add ARIA attributes
2. Set up keyboard navigation
3. Ensure sufficient color contrast
4. Add skip navigation links
5. Test with screen readers
6. Run automated accessibility tests

Make the site accessible to users with disabilities and compliant with WCAG guidelines.
```

### Prompt 21: Fly.io Deployment Configuration

```
Set up deployment configuration:

1. Create a Dockerfile
2. Add a fly.toml configuration file
3. Configure database handling
4. Set up environment variables
5. Configure asset compilation
6. Create deployment scripts
7. Document the deployment process

Prepare the application for deployment to Fly.io with proper configuration and documentation.
```

### Prompt 22: Final Integration and QA

```
Perform final integration and quality assurance:

1. Review all implemented features
2. Run comprehensive tests
3. Check for any unlinked code
4. Verify all functionality
5. Review code for optimizations
6. Document any issues or future enhancements

Ensure all components are properly integrated and the application works as a cohesive whole.
```

## Conclusion

This implementation plan breaks down the development of your personal developer landing page into 22 well-sized, incremental steps. Each step builds on the previous ones and focuses on specific functionality, following best practices for Rails development.

The steps are small enough to be implemented with strong testing but substantial enough to move the project forward meaningfully. The test-driven approach ensures quality at each stage of development.

By following these prompts in sequence, a developer (or code-generation LLM) can systematically build the complete application without any orphaned code or functionality gaps. The final result will be a polished, professional personal landing page that showcases your skills and experience using modern Rails practices.
