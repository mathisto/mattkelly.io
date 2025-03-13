---
title: "Building mattkelly.io: A Journey Through Tokyo Night ✨"
description: "A deep dive into building a modern, static personal website with Rails, Tailwind, and the Tokyo Night theme - from initial concept to production deployment."
date: 2024-03-24
author: "Matt Kelly"
tags: ["ruby", "rails", "tailwind", "web-design", "ui-ux", "static-site"]
category: "Technical"
cover_image: "/images/blog/tokyo-night-cover.png"
status: "published"
---

# Building mattkelly.io: A Journey Through Tokyo Night ✨

What started as a simple Rails application has evolved into a sophisticated, static personal website that combines modern design principles with optimal performance. This post chronicles our journey from initial concept to production deployment, exploring the technical decisions and design choices that make this site unique.

## The Evolution 🌱

Looking through our git history tells an interesting story:
```bash
3380472 - Init rails 8 app with SQLite3
# ... many iterations of refinement ...
c743d71 - Make site static. Remove db.
2212509 - Add ALL the specs
79b2cc4 - Add GitHub contributions heatmap to homepage
```

Each commit represents a step forward in our mission to create a performant, beautiful, and maintainable personal space on the web.

## The Tech Stack 🛠️

Our foundation is built on:
- Ruby on Rails 7.1 (now as a static site generator)
- Tailwind CSS for utility-first styling
- Stimulus.js for JavaScript interactions
- Font Awesome for iconography
- Prism.js for code syntax highlighting
- GitHub API integration for contribution visualization

What sets this site apart is its aesthetic - inspired by the Tokyo Night theme, a color palette that perfectly balances cyberpunk energy with elegant minimalism.

## The Tokyo Night Palette 🎨

```css
--tokyo-bg: #1a1b26;
--tokyo-bg-darker: #16161e;
--tokyo-fg: #a9b1d6;
--tokyo-blue: #7aa2f7;
--tokyo-purple: #bb9af7;
--tokyo-cyan: #7dcfff;
--tokyo-green: #9ece6a;
--tokyo-orange: #ff9e64;
--tokyo-red: #f7768e;
```

This carefully chosen color scheme creates a cohesive, high-contrast experience that's both modern and easy on the eyes. The dark background with carefully selected accent colors gives the site a professional yet distinctive look.

## Modern Features & Components 💫

### GitHub Contribution Heatmap
One of our latest additions is the GitHub contribution heatmap on the homepage, providing a visual representation of coding activity:

```ruby
# Fetching GitHub contributions
def fetch_contributions
  client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
  user_events = client.user_events('mathisto')
  process_events(user_events)
end
```

### Interactive Blog Cards
Each blog post card features sophisticated hover effects:

```css
.post-card {
  /* Base styles */
  background: rgba(31, 35, 53, 0.8);
  border-radius: 1rem;
  backdrop-filter: blur(8px);
  
  /* Rainbow border animation */
  &::before {
    content: '';
    position: absolute;
    background: linear-gradient(
      90deg,
      var(--tokyo-blue) 0%,
      var(--tokyo-purple) 33%,
      var(--tokyo-red) 66%,
      var(--tokyo-blue) 100%
    );
    /* ... animation properties ... */
  }
}
```

### Responsive CV Timeline
The CV section implements a modern timeline with:
- Animated entry transitions
- Interactive skill tags
- Responsive layout adjustments
- Elegant date positioning

## Performance Optimizations ⚡

We've implemented several optimizations:
- Static site generation for blazing-fast load times
- Lazy-loaded images with blur placeholders
- Efficient CSS organization
- Minimal JavaScript footprint
- Optimized asset delivery

## CSS Architecture 📐

Our CSS is organized into logical modules:
```scss
styles/
  ├── base/
  │   ├── variables.scss
  │   ├── typography.scss
  │   └── animations.scss
  ├── components/
  │   ├── cards.scss
  │   ├── timeline.scss
  │   └── heatmap.scss
  └── layouts/
      ├── grid.scss
      └── responsive.scss
```

## Testing & CI/CD 🔄

We maintain high code quality through:
- Comprehensive RSpec test suite
- GitHub Actions for CI/CD
- Automated deployment pipeline
- Code quality checks

## Mobile-First Approach 📱

Recent updates have focused on mobile optimization:
- Responsive breakpoints
- Touch-friendly interactions
- Optimized spacing and typography
- Improved card layouts

## What's Next? 🎯

We're continuing to evolve the site with:
- Enhanced performance metrics
- Improved accessibility features
- Additional interactive components
- Extended blog functionality
- Expanded project showcases

## Conclusion

Building mattkelly.io has been an exercise in balancing aesthetics with performance, and modern features with maintainability. The site serves as both a personal portfolio and a testament to thoughtful web development practices.

Stay tuned for more updates as we continue to refine and enhance this digital space. Feel free to check out the [source code](https://github.com/mathisto/mattkelly.io) to see how it all comes together.

---

*Last updated: March 24, 2024*
