---
title: "The Coordinate System - X, Y, and You"
description: "Understand how positioning works in DragonRuby's coordinate system"
difficulty: "beginner"
category: "getting-started"
order: 3
estimated_time: "10 min"
tags: ["basics", "coordinates", "positioning"]
author: "Matt Kelly"
date: 2024-10-23
status: "published"
dragonruby_version: "5.0+"
---

# The Coordinate System - X, Y, and You

Understanding coordinates is essential for positioning everything in your game. Let's explore how DragonRuby's coordinate system works.

## Screen Dimensions

DragonRuby uses a logical resolution of **1280x720 pixels**:
- X axis: 0 (left) to 1280 (right)
- Y axis: 0 (bottom) to 720 (top)
- Origin (0, 0) is at the **bottom-left** corner

## Key Positions

```ruby:starter
def tick args
  # Four corners
  args.outputs.labels << [0, 720, "Top Left (0, 720)", 2]
  args.outputs.labels << [1280, 720, "Top Right (1280, 720)", 2, 2]
  args.outputs.labels << [0, 0, "Bottom Left (0, 0)", 2]
  args.outputs.labels << [1280, 0, "Bottom Right (1280, 0)", 2, 2]
  
  # Center
  args.outputs.labels << [640, 360, "Center (640, 360)", 5, 1]
  
  # Draw crosshair at center
  args.outputs.lines << [640, 0, 640, 720, 255, 255, 255, 128]
  args.outputs.lines << [0, 360, 1280, 360, 255, 255, 255, 128]
end
```

## Drawing Primitives

DragonRuby provides several drawing primitives:

```ruby:readonly
# Labels (text)
args.outputs.labels << [x, y, "Text", size, alignment]

# Lines
args.outputs.lines << [x1, y1, x2, y2, r, g, b, a]

# Solids (filled rectangles)
args.outputs.solids << [x, y, width, height, r, g, b, a]

# Borders (hollow rectangles)
args.outputs.borders << [x, y, width, height, r, g, b, a]
```

## Interactive Example

```ruby:solution
def tick args
  # Draw grid
  12.times do |i|
    x = i * 100
    args.outputs.lines << [x, 0, x, 720, 100, 100, 100, 50]
  end
  
  7.times do |i|
    y = i * 100
    args.outputs.lines << [0, y, 1280, y, 100, 100, 100, 50]
  end
  
  # Draw mouse position
  mouse_x = args.inputs.mouse.x.to_i
  mouse_y = args.inputs.mouse.y.to_i
  
  args.outputs.labels << [mouse_x + 10, mouse_y + 10, "(#{mouse_x}, #{mouse_y})", 2]
  args.outputs.solids << [mouse_x - 5, mouse_y - 5, 10, 10, 122, 162, 247]
end
```

## Challenges

**Challenge 1:** Draw a box in each corner of the screen

**Challenge 2:** Create a grid pattern using lines

**Challenge 3:** Make a crosshair that follows the mouse cursor

## Next Steps

Continue to [Rendering Labels and Text](004-rendering-labels)
