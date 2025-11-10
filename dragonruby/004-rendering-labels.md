---
title: "Rendering Labels and Text"
description: "Master text rendering with different sizes, colors, and alignments"
difficulty: "beginner"
category: "getting-started"
order: 4
estimated_time: "8 min"
tags: ["rendering", "labels", "text", "fonts"]
author: "Matt Kelly"
date: 2024-10-23
status: "published"
dragonruby_version: "5.0+"
---

# Rendering Labels and Text

Text is crucial for UI, scores, dialogue, and more. Let's explore all the ways to render text in DragonRuby.

## Basic Label Syntax

```ruby:starter
def tick args
  # Simple label: [x, y, text]
  args.outputs.labels << [100, 600, "Simple Text"]
  
  # With size: [x, y, text, size]
  args.outputs.labels << [100, 500, "Bigger Text", 5]
  
  # With alignment: [x, y, text, size, alignment]
  args.outputs.labels << [640, 400, "Centered Text", 3, 1]
end
```

## Font Sizes

DragonRuby supports font sizes from **-10 to 10**:
- Negative values: smaller than default
- 0: default size
- Positive values: larger than default

```ruby:readonly
def tick args
  sizes = [-5, -2, 0, 2, 5, 10]
  y = 600
  
  sizes.each do |size|
    args.outputs.labels << [100, y, "Size: #{size}", size]
    y -= 80
  end
end
```

## Text Alignment

Three alignment options:
- **0** - Left aligned
- **1** - Center aligned
- **2** - Right aligned

```ruby:solution
def tick args
  center_x = 640
  y = 600
  
  # Left aligned at center
  args.outputs.labels << [center_x, y, "Left (0)", 3, 0]
  
  # Center aligned
  args.outputs.labels << [center_x, y - 100, "Center (1)", 3, 1]
  
  # Right aligned at center
  args.outputs.labels << [center_x, y - 200, "Right (2)", 3, 2]
  
  # Draw alignment line
  args.outputs.lines << [center_x, 0, center_x, 720, 255, 255, 0, 128]
end
```

## Advanced Label Hash

For more control, use hash syntax:

```ruby:readonly
def tick args
  args.outputs.labels << {
    x: 640,
    y: 360,
    text: "Advanced Label",
    size_enum: 5,
    alignment_enum: 1,
    r: 122,  # Red
    g: 162,  # Green
    b: 247,  # Blue
    a: 255,  # Alpha (transparency)
    font: "fonts/custom.ttf"  # Custom font
  }
end
```

## Challenges

**Challenge 1:** Create a title screen with large centered text

**Challenge 2:** Display a score counter in the top-right corner

**Challenge 3:** Make rainbow text by varying RGB values each tick

## Next Steps

Continue to [Working with Colors](005-colors)
