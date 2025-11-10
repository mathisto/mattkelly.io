---
title: "WASD Movement Controls"
description: "Implement WASD controls for keyboard-friendly gameplay"
difficulty: "beginner"
category: "input"
order: 14
estimated_time: "8 min"
tags: ["movement", "input", "wasd"]
author: "Matt Kelly"
date: 2024-10-23
status: "published"
dragonruby_version: "5.0+"
---

# WASD Movement Controls

WASD is the standard for PC gaming. Learn to implement these controls alongside arrow keys.

## WASD vs Arrow Keys

```ruby:starter
def tick args
  args.state.player ||= { x: 640, y: 360 }
  speed = 5
  
  # WASD controls
  if args.inputs.keyboard.a
    args.state.player.x -= speed
  end
  
  if args.inputs.keyboard.d
    args.state.player.x += speed
  end
  
  if args.inputs.keyboard.w
    args.state.player.y += speed
  end
  
  if args.inputs.keyboard.s
    args.state.player.y -= speed
  end
  
  # Render
  args.outputs.sprites << [
    args.state.player.x - 32,
    args.state.player.y - 32,
    64, 64,
    'sprites/square/blue.png'
  ]
  
  args.outputs.labels << [640, 50, "Use WASD keys to move", 2, 1]
end
```

## Combined WASD + Arrows

```ruby:solution
def tick args
  args.state.player ||= { x: 640, y: 360 }
  speed = 5
  
  # Support both control schemes
  if args.inputs.keyboard.a || args.inputs.keyboard.left
    args.state.player.x -= speed
  end
  
  if args.inputs.keyboard.d || args.inputs.keyboard.right
    args.state.player.x += speed
  end
  
  if args.inputs.keyboard.w || args.inputs.keyboard.up
    args.state.player.y += speed
  end
  
  if args.inputs.keyboard.s || args.inputs.keyboard.down
    args.state.player.y -= speed
  end
  
  # Bounds
  args.state.player.x = args.state.player.x.clamp(0, 1216)
  args.state.player.y = args.state.player.y.clamp(0, 656)
  
  # Render
  args.outputs.sprites << [
    args.state.player.x,
    args.state.player.y,
    64, 64,
    'sprites/square/blue.png'
  ]
  
  args.outputs.labels << [640, 50, "WASD or Arrow Keys", 2, 1]
end
```

## Challenges

**Challenge 1:** Add shift to sprint
**Challenge 2:** Implement diagonal movement normalization
**Challenge 3:** Create two-player controls (WASD + Arrows)

## Next Steps

Continue to [Mouse Position and Click Detection](015-mouse-input)
