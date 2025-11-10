---
title: "Mouse Position and Click Detection"
description: "Learn to read mouse position and detect clicks"
difficulty: "beginner"
category: "input"
order: 15
estimated_time: "10 min"
tags: ["input", "mouse", "clicks"]
author: "Matt Kelly"
date: 2024-10-23
status: "published"
dragonruby_version: "5.0+"
---

# Mouse Position and Click Detection

Add mouse support to your game for point-and-click interactions and cursor-based controls.

## Mouse Position

```ruby:starter
def tick args
  # Get mouse coordinates (default to center if no mouse detected yet)
  mouse_x = args.inputs.mouse.x || 640
  mouse_y = args.inputs.mouse.y || 360
  
  # Draw cursor indicator
  args.outputs.sprites << [
    mouse_x - 16,
    mouse_y - 16,
    32, 32,
    'sprites/circle/blue.png'
  ]
  
  # Display coordinates
  args.outputs.labels << [mouse_x + 20, mouse_y + 20, "(#{mouse_x.to_i}, #{mouse_y.to_i})", 2]
end
```

## Click Detection

```ruby:solution
def tick args
  args.state.clicks ||= []
  
  # Detect click (ensure mouse coordinates exist)
  if args.inputs.mouse.click && args.inputs.mouse.x && args.inputs.mouse.y
    args.state.clicks << {
      x: args.inputs.mouse.x,
      y: args.inputs.mouse.y,
      tick: args.tick_count
    }
  end
  
  # Remove old clicks (after 120 frames)
  args.state.clicks.reject! { |c| args.tick_count - c[:tick] > 120 }
  
  # Render click markers
  args.state.clicks.each do |click|
    age = args.tick_count - click[:tick]
    alpha = (255 * (1 - age / 120.0)).to_i
    size = 20 + age / 4
    
    args.outputs.sprites << [
      click[:x] - size / 2,
      click[:y] - size / 2,
      size, size,
      'sprites/circle/red.png',
      0, alpha
    ]
  end
  
  args.outputs.labels << [640, 50, "Click anywhere to create markers", 2, 1]
  args.outputs.labels << [640, 20, "Total clicks: #{args.state.clicks.length}", 2, 1]
end
```

## Challenges

**Challenge 1:** Create clickable buttons
**Challenge 2:** Implement click-and-drag
**Challenge 3:** Build a paint program

## Next Steps

Continue to [Creating Clickable Buttons](016-buttons)
