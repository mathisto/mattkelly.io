---
title: "Camera Systems"
description: "Implement camera follow, zoom, and screen shake effects"
difficulty: "advanced"
category: "rendering"
order: 24
estimated_time: "20 min"
tags: ["camera", "viewport", "effects"]
author: "Matt Kelly"
date: 2024-10-24
status: "published"
dragonruby_version: "5.0+"
---

# Camera Systems

Create dynamic camera systems for smooth following, zoom effects, and screen shake.

## Camera Follow

```ruby:starter
def tick args
  args.state.player ||= { x: 640, y: 360 }
  args.state.camera ||= { x: 0, y: 0 }
  
  # Move player
  speed = 5
  args.state.player.x += speed if args.inputs.keyboard.key_held.right
  args.state.player.x -= speed if args.inputs.keyboard.key_held.left
  args.state.player.y += speed if args.inputs.keyboard.key_held.up
  args.state.player.y -= speed if args.inputs.keyboard.key_held.down
  
  # Camera follows player
  args.state.camera.x = args.state.player.x - 640
  args.state.camera.y = args.state.player.y - 360
  
  # Render world (offset by camera)
  render_x = args.state.player.x - args.state.camera.x
  render_y = args.state.player.y - args.state.camera.y
  
  args.outputs.sprites << [
    render_x - 25, render_y - 25,
    50, 50, 'sprites/square/blue.png'
  ]
  
  # Render grid to show movement
  10.times do |i|
    x = (i * 200) - args.state.camera.x
    args.outputs.lines << [x, 0, x, 720, 100, 100, 100]
  end
  
  args.outputs.labels << [10, 710, "Player: (#{args.state.player.x.to_i}, #{args.state.player.y.to_i})", 2]
end
```

## Advanced Camera with Shake

```ruby:solution
def tick args
  args.state.player ||= { x: 640, y: 360 }
  args.state.camera ||= { x: 0, y: 0, shake: 0 }
  
  # Move player
  speed = 5
  args.state.player.x += speed if args.inputs.keyboard.key_held.right
  args.state.player.x -= speed if args.inputs.keyboard.key_held.left
  args.state.player.y += speed if args.inputs.keyboard.key_held.up
  args.state.player.y -= speed if args.inputs.keyboard.key_held.down
  
  # Trigger shake on spacebar
  if args.inputs.keyboard.key_down.space
    args.state.camera.shake = 20
  end
  
  # Smooth camera follow (lerp)
  target_x = args.state.player.x - 640
  target_y = args.state.player.y - 360
  
  args.state.camera.x += (target_x - args.state.camera.x) * 0.1
  args.state.camera.y += (target_y - args.state.camera.y) * 0.1
  
  # Apply shake
  shake_x = 0
  shake_y = 0
  
  if args.state.camera.shake > 0
    shake_x = rand(-args.state.camera.shake..args.state.camera.shake)
    shake_y = rand(-args.state.camera.shake..args.state.camera.shake)
    args.state.camera.shake *= 0.9
    args.state.camera.shake = 0 if args.state.camera.shake < 0.5
  end
  
  # Final camera position with shake
  final_x = args.state.camera.x + shake_x
  final_y = args.state.camera.y + shake_y
  
  # Render player
  render_x = args.state.player.x - final_x
  render_y = args.state.player.y - final_y
  
  args.outputs.sprites << [
    render_x - 25, render_y - 25,
    50, 50, 'sprites/square/blue.png'
  ]
  
  # Render world elements
  obstacles = [
    { x: 800, y: 400, w: 100, h: 100 },
    { x: 1200, y: 300, w: 80, h: 80 },
    { x: 400, y: 500, w: 60, h: 60 }
  ]
  
  obstacles.each do |obs|
    args.outputs.sprites << [
      obs[:x] - final_x, obs[:y] - final_y,
      obs[:w], obs[:h], 'sprites/square/red.png'
    ]
  end
  
  # Grid
  20.times do |i|
    x = (i * 200) - final_x
    args.outputs.lines << [x, 0, x, 720, 50, 50, 50] if x >= 0 && x <= 1280
  end
  
  args.outputs.labels << [10, 710, "Pos: (#{args.state.player.x.to_i}, #{args.state.player.y.to_i})", 2]
  args.outputs.labels << [10, 20, "SPACE for shake effect", 1]
end
```

## Challenges

**Challenge 1:** Add camera zoom
**Challenge 2:** Create camera boundaries
**Challenge 3:** Build split-screen multiplayer

## Next Steps

You've completed the DragonRuby tutorial series! Keep building and experimenting!
