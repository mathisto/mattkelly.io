---
title: "Building mattkelly.io: A Journey Through Tokyo Night"
description: "A deep dive into building a modern personal website with Rails, Tailwind, and the Tokyo Night theme - from initial setup to polished UI."
date: 2024-03-10
author: "Matt Kelly"
tags: ["ruby", "rails", "tailwind", "web-design", "ui-ux"]
category: "Technical"
status: "published"
cover_image: "/images/blog/tokyo-night-cover.png"
---

# Building mattkelly.io: A Journey Through Tokyo Night

In a single evening, we transformed a basic Rails application into a sleek, modern personal website with a distinctive Tokyo Night theme. This post chronicles our journey from initial setup to polished UI, exploring the technical decisions and design choices that make this site special.

## The Tech Stack

Our foundation is built on:
- Ruby on Rails 7.1
- Tailwind CSS for styling
- Stimulus.js for JavaScript interactions
- Font Awesome for iconography
- Prism.js for code highlighting

But what really sets this site apart is its aesthetic - inspired by the Tokyo Night theme, a color palette that perfectly balances cyberpunk energy with elegant minimalism.

## The Tokyo Night Palette

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

## Blog Posts: Animated Cards with Style

The blog index page showcases our attention to detail with elegantly designed post cards. Each card features a subtle yet eye-catching animated rainbow border on hover:

```css
.post-card {
  display: flex;
  flex-direction: column;
  background: rgba(31, 35, 53, 0.8);
  border-radius: 1rem;
  position: relative;
  isolation: isolate;
}

.post-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 4px;
  right: 4px;
  height: 2px;
  background: linear-gradient(
    90deg,
    #7aa2f7 0%,     /* Tokyo Night blue */
    #bb9af7 16.67%, /* Tokyo Night purple */
    #7dcfff 33.33%, /* Tokyo Night cyan */
    #9ece6a 50%,    /* Tokyo Night green */
    #ff9e64 66.67%, /* Tokyo Night orange */
    #f7768e 83.33%, /* Tokyo Night red */
    #9d7cd8 91.67%, /* Transition purple */
    #7aa2f7 100%    /* Back to blue */
  );
  background-size: 200% 100%;
  opacity: 0;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  transform: scaleX(0.98);
  transform-origin: center;
}

.post-card:hover::before {
  opacity: 1;
  animation: borderGradient 6s linear infinite;
}
```

The cards feature:
- A subtle top rainbow border that animates on hover
- Smooth elevation transition with shadow effects
- Backdrop blur for depth
- Carefully crafted spacing and typography
- Responsive layout with maximum width constraints

### Interactive Elements

Each blog card contains multiple interactive elements:

Tags with hover effects:
```css
.post-card .tag {
  display: inline-flex;
  align-items: center;
  background: rgba(122, 162, 247, 0.1);
  border: 1px solid rgba(122, 162, 247, 0.2);
  border-radius: 9999px;
  transition: all 0.3s ease;
}

.post-card .tag:hover {
  transform: translateY(-2px);
  background: rgba(187, 154, 247, 0.15);
  border-color: rgba(187, 154, 247, 0.3);
}
```

"Read More" link with animated underline:
```css
.post-card .card-link span::after {
  content: '';
  position: absolute;
  width: 100%;
  height: 1px;
  bottom: -2px;
  left: 0;
  background-color: #f7768e;
  transform: scaleX(0);
  transition: transform 0.3s ease;
}

.post-card .card-link:hover span::after {
  transform: scaleX(1);
}
```

## Animations and Transitions

Throughout the site, we've implemented smooth animations:
- Rainbow border gradient animation on card hover
- Elevation transitions for cards
- Scale and translate transforms for interactive elements
- Underline animations for links
- Icon scale effects

All animations use carefully chosen cubic-bezier timing functions for natural movement:

```css
transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
```

## Modular Design

We've structured the site using a modular approach:
- Scoped CSS within components
- Reusable card patterns
- Consistent spacing and color variables
- Isolated animation keyframes
- Component-specific style organization

This modular approach makes the code:
- Easy to maintain
- Simple to update
- Reusable across different sections
- Consistent in styling

## The Result

What started as a basic Rails application evolved into a polished, professional website that stands out for its:
- Distinctive Tokyo Night theme
- Subtle yet engaging animations
- Modern UI components
- Consistent design language
- Attention to detail

The site now serves as both a portfolio and a testament to modern web design practices, all while maintaining excellent performance and accessibility.

## What's Next?

We're continuing to evolve the site with:
- Enhanced blog functionality
- Projects showcase
- Additional UI polish
- Performance optimizations
- Improved mobile experience

Stay tuned for more updates as we continue to refine this digital space.
