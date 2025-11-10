---
title: "Rotating Sprites"
description: "Learn to rotate sprites for spinning effects and rotational movement"
difficulty: "intermediate"
category: "sprites"
order: 19
estimated_time: "12 min"
tags: ["sprites", "rotation", "animation"]
author: "Matt Kelly"
date: 2024-10-24
status: "published"
dragonruby_version: "5.0+"
---

# Rotating Sprites

Add rotation to your sprites for spinning effects, directional movement, and dynamic animations.

## Basic Rotation

```ruby:starter
def tick args
  # Sprite: [x, y, width, height, path, angle]
  # Angle is in degrees (0-360)
  args.outputs.sprites << [
    640 - 64, 360 - 64,
    128, 128,
    'sprites/square/blue.png',
    args.tick_count % 360
  ]
  
  args.outputs.labels << [640, 50, "Rotating sprite", 2, 1]
end
```

## Rotation with State

```ruby:solution
def tick args
  args.state.rotation ||= 0
  args.state.rotation_speed ||= 2
  
  # Increase rotation
  args.state.rotation += args.state.rotation_speed
  args.state.rotation %= 360
  
  # Draw rotating sprite
  args.outputs.sprites << [
    640 - 64, 360 - 64,
    128, 128,
    'sprites/square/red.png',
    args.state.rotation
  ]
  
  # Control rotation speed
  if args.inputs.keyboard.key_held.up
    args.state.rotation_speed += 0.5
  elsif args.inputs.keyboard.key_held.down
    args.state.rotation_speed -= 0.5
  end
  
  args.outputs.labels << [640, 50, "Speed: #{args.state.rotation_speed.round(1)}", 2, 1]
  args.outputs.labels << [640, 20, "Use UP/DOWN to control speed", 1, 1]
end
```

## Challenges

**Challenge 1:** Create a spinning propeller
**Challenge 2:** Point sprite toward mouse cursor
**Challenge 3:** Build a rotating platform game

## Next Steps

Continue to [Collision Detection](020-collision-detection)
