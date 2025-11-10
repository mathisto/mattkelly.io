---
title: "Sprite Positioning and Sizing"
description: "Master sprite placement and scaling techniques"
difficulty: "beginner"
category: "getting-started"
order: 7
estimated_time: "8 min"
tags: ["sprites", "positioning", "scaling"]
author: "Matt Kelly"
date: 2024-10-23
status: "published"
dragonruby_version: "5.0+"
---

# Sprite Positioning and Sizing

Learn how to position and scale sprites with precision for perfect layouts.

## Anchor Points

Understanding where sprites anchor is crucial:

```ruby:starter
def tick args
  # Bottom-left anchor (default)
  args.outputs.sprites << [100, 400, 80, 80, 'sprites/square/blue.png']
  
  # Mark the anchor point
  args.outputs.solids << [100 - 2, 400 - 2, 4, 4, 255, 0, 0]
  args.outputs.labels << [100, 380, "Anchor (100, 400)", 1]
end
```

## Relative Positioning

Position sprites relative to screen or other sprites:

```ruby:readonly
def tick args
  # Relative to screen edges
  margin = 50
  sprite_size = 100
  
  # Top-left corner
  args.outputs.sprites << [margin, 720 - margin - sprite_size, sprite_size, sprite_size, 'sprites/square/red.png']
  
  # Top-right corner
  args.outputs.sprites << [1280 - margin - sprite_size, 720 - margin - sprite_size, sprite_size, sprite_size, 'sprites/square/blue.png']
  
  # Bottom-left corner
  args.outputs.sprites << [margin, margin, sprite_size, sprite_size, 'sprites/square/green.png']
  
  # Bottom-right corner
  args.outputs.sprites << [1280 - margin - sprite_size, margin, sprite_size, sprite_size, 'sprites/square/orange.png']
end
```

## Dynamic Sizing

Scale sprites based on calculations:

```ruby:solution
def tick args
  args.state.pulse ||= 0
  args.state.pulse += 1
  
  # Pulsing effect using sine wave
  scale = 1.0 + Math.sin(args.state.pulse * 0.05) * 0.5
  base_size = 100
  size = (base_size * scale).to_i
  
  # Center the pulsing sprite
  x = 640 - size / 2
  y = 360 - size / 2
  
  args.outputs.sprites << [x, y, size, size, 'sprites/square/blue.png']
  
  # Display scale value
  args.outputs.labels << [640, 100, "Scale: #{scale.round(2)}", 3, 1]
end
```

## Aspect Ratio

Maintain aspect ratio when scaling:

```ruby:readonly
def tick args
  # Original dimensions
  original_width = 128
  original_height = 128
  aspect_ratio = original_width.to_f / original_height
  
  # Scale to specific width
  new_width = 200
  new_height = (new_width / aspect_ratio).to_i
  
  args.outputs.sprites << [100, 300, new_width, new_height, 'sprites/square/blue.png']
  
  # Scale to specific height
  new_height = 150
  new_width = (new_height * aspect_ratio).to_i
  
  args.outputs.sprites << [400, 300, new_width, new_height, 'sprites/square/red.png']
end
```

## Grid Layout

Position sprites in a grid pattern:

```ruby:solution
def tick args
  sprite_size = 64
  padding = 20
  columns = 8
  rows = 4
  
  rows.times do |row|
    columns.times do |col|
      x = 200 + col * (sprite_size + padding)
      y = 200 + row * (sprite_size + padding)
      
      # Alternate colors
      color = (row + col).even? ? 'blue' : 'red'
      
      args.outputs.sprites << [x, y, sprite_size, sprite_size, "sprites/square/#{color}.png"]
    end
  end
end
```

## Challenges

**Challenge 1:** Create a 3x3 grid of sprites with different sizes

**Challenge 2:** Make sprites orbit around the screen center

**Challenge 3:** Build a sprite that bounces when it hits screen edges

## Next Steps

Continue to [Introduction to args.state](008-args-state)
