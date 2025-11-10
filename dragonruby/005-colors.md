---
title: "Working with Colors - RGB and Alpha"
description: "Learn how to use colors and transparency in DragonRuby"
difficulty: "beginner"
category: "getting-started"
order: 5
estimated_time: "10 min"
tags: ["rendering", "colors", "rgb", "alpha"]
author: "Matt Kelly"
date: 2024-10-23
status: "published"
dragonruby_version: "5.0+"
---

# Working with Colors - RGB and Alpha

Colors bring your game to life! Learn how to use RGB values and alpha transparency to create vibrant visuals.

## RGB Color Model

Colors in DragonRuby use RGB (Red, Green, Blue) with values from **0 to 255**:
- `[255, 0, 0]` - Pure Red
- `[0, 255, 0]` - Pure Green
- `[0, 0, 255]` - Pure Blue
- `[255, 255, 255]` - White
- `[0, 0, 0]` - Black

```ruby:starter
def tick args
  # Red box
  args.outputs.solids << [100, 500, 200, 100, 255, 0, 0]
  
  # Green box
  args.outputs.solids << [350, 500, 200, 100, 0, 255, 0]
  
  # Blue box
  args.outputs.solids << [600, 500, 200, 100, 0, 0, 255]
end
```

## Alpha Transparency

Add a fourth value (0-255) for transparency:
- **255** - Fully opaque (solid)
- **128** - 50% transparent
- **0** - Fully transparent (invisible)

```ruby:readonly
def tick args
  # Solid red
  args.outputs.solids << [100, 400, 150, 150, 255, 0, 0, 255]
  
  # Semi-transparent red
  args.outputs.solids << [200, 400, 150, 150, 255, 0, 0, 128]
  
  # Very transparent red
  args.outputs.solids << [300, 400, 150, 150, 255, 0, 0, 64]
end
```

## Color Mixing

Combine RGB values to create any color:

```ruby:solution
def tick args
  args.state.hue ||= 0
  args.state.hue += 1
  
  # Convert hue to RGB (simple rainbow)
  r = (Math.sin(args.state.hue * 0.01) * 127 + 128).to_i
  g = (Math.sin(args.state.hue * 0.01 + 2) * 127 + 128).to_i
  b = (Math.sin(args.state.hue * 0.01 + 4) * 127 + 128).to_i
  
  # Animated rainbow box
  args.outputs.solids << [440, 260, 400, 200, r, g, b]
  
  # Display RGB values
  args.outputs.labels << [640, 500, "R: #{r} G: #{g} B: #{b}", 3, 1, r, g, b]
end
```

## Tokyo Night Color Palette

Here are some colors from the Tokyo Night theme:

```ruby:readonly
def tick args
  colors = {
    blue: [122, 162, 247],
    purple: [187, 154, 247],
    cyan: [125, 207, 255],
    green: [158, 206, 106],
    orange: [255, 158, 100],
    red: [247, 118, 142]
  }
  
  x = 100
  colors.each do |name, rgb|
    args.outputs.solids << [x, 300, 150, 100, *rgb]
    args.outputs.labels << [x + 75, 250, name.to_s, 2, 1]
    x += 180
  end
end
```

## Challenges

**Challenge 1:** Create a gradient effect using multiple overlapping rectangles

**Challenge 2:** Make a pulsing effect by animating alpha values

**Challenge 3:** Display a color picker showing R, G, B sliders

## Next Steps

Continue to [Loading and Rendering Sprites](006-sprites)
