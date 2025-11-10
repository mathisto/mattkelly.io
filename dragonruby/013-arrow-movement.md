---
title: "Moving a Sprite with Arrow Keys"
description: "Create smooth, responsive movement with arrow key controls"
difficulty: "beginner"
category: "input"
order: 13
estimated_time: "10 min"
tags: ["movement", "input", "arrow-keys"]
author: "Matt Kelly"
date: 2024-10-23
status: "published"
dragonruby_version: "5.0+"
---

# Moving a Sprite with Arrow Keys

Create responsive player movement using arrow keys. Learn techniques for smooth, natural-feeling controls.

## Basic Movement

```ruby:starter
def tick args
  # Initialize player position
  args.state.player_x ||= 640
  args.state.player_y ||= 360
  speed = 5
  
  # Arrow key movement
  if args.inputs.keyboard.left
    args.state.player_x -= speed
  end
  
  if args.inputs.keyboard.right
    args.state.player_x += speed
  end
  
  if args.inputs.keyboard.up
    args.state.player_y += speed
  end
  
  if args.inputs.keyboard.down
    args.state.player_y -= speed
  end
  
  # Render player
  args.outputs.sprites << [
    args.state.player_x - 32,
    args.state.player_y - 32,
    64, 64,
    'sprites/square/blue.png'
  ]
end
```

## Screen Boundaries

```ruby:solution
def tick args
  args.state.player ||= { x: 640, y: 360, size: 64 }
  speed = 5
  
  # Movement
  if args.inputs.keyboard.left
    args.state.player.x -= speed
  end
  
  if args.inputs.keyboard.right
    args.state.player.x += speed
  end
  
  if args.inputs.keyboard.up
    args.state.player.y += speed
  end
  
  if args.inputs.keyboard.down
    args.state.player.y -= speed
  end
  
  # Clamp to screen bounds
  args.state.player.x = args.state.player.x.clamp(0, 1280 - args.state.player.size)
  args.state.player.y = args.state.player.y.clamp(0, 720 - args.state.player.size)
  
  # Render
  args.outputs.sprites << [
    args.state.player.x,
    args.state.player.y,
    args.state.player.size,
    args.state.player.size,
    'sprites/square/blue.png'
  ]
  
  # Show bounds
  args.outputs.borders << [0, 0, 1280, 720, 122, 162, 247]
end
```

## Challenges

**Challenge 1:** Add acceleration and deceleration for smoother movement
**Challenge 2:** Make player leave a trail as they move
**Challenge 3:** Create screen wrapping (exit right, appear left)

## Next Steps

Continue to [WASD Movement Controls](014-wasd-movement)
