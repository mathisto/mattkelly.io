---
title: "Collision Detection"
description: "Detect when game objects collide using bounding boxes"
difficulty: "intermediate"
category: "physics"
order: 20
estimated_time: "15 min"
tags: ["collision", "physics", "game-logic"]
author: "Matt Kelly"
date: 2024-10-24
status: "published"
dragonruby_version: "5.0+"
---

# Collision Detection

Learn to detect when sprites collide - essential for games with player interaction and obstacles.

## Basic Collision Check

```ruby:starter
def tick args
  args.state.player ||= { x: 100, y: 360, w: 64, h: 64 }
  args.state.target ||= { x: 600, y: 360, w: 64, h: 64 }
  
  # Move player with arrow keys
  args.state.player.x += 5 if args.inputs.keyboard.key_held.right
  args.state.player.x -= 5 if args.inputs.keyboard.key_held.left
  
  # Check collision
  collision = args.geometry.intersect_rect?(args.state.player, args.state.target)
  
  # Draw sprites
  args.outputs.sprites << [
    args.state.player.x, args.state.player.y,
    args.state.player.w, args.state.player.h,
    'sprites/square/blue.png'
  ]
  
  color = collision ? 'red' : 'green'
  args.outputs.sprites << [
    args.state.target.x, args.state.target.y,
    args.state.target.w, args.state.target.h,
    "sprites/square/#{color}.png"
  ]
  
  args.outputs.labels << [640, 50, collision ? "COLLISION!" : "Move to touch", 3, 1]
end
```

## Multiple Collisions

```ruby:solution
def tick args
  args.state.player ||= { x: 640, y: 360, w: 50, h: 50 }
  args.state.enemies ||= [
    { x: 200, y: 200, w: 40, h: 40 },
    { x: 800, y: 400, w: 40, h: 40 },
    { x: 400, y: 500, w: 40, h: 40 }
  ]
  
  # Move player
  speed = 3
  args.state.player.x += speed if args.inputs.keyboard.key_held.right
  args.state.player.x -= speed if args.inputs.keyboard.key_held.left
  args.state.player.y += speed if args.inputs.keyboard.key_held.up
  args.state.player.y -= speed if args.inputs.keyboard.key_held.down
  
  # Check collisions with all enemies
  hit_count = 0
  args.state.enemies.each do |enemy|
    if args.geometry.intersect_rect?(args.state.player, enemy)
      hit_count += 1
    end
  end
  
  # Draw player
  player_color = hit_count > 0 ? 'red' : 'blue'
  args.outputs.sprites << [
    args.state.player.x, args.state.player.y,
    args.state.player.w, args.state.player.h,
    "sprites/square/#{player_color}.png"
  ]
  
  # Draw enemies
  args.state.enemies.each do |enemy|
    args.outputs.sprites << [
      enemy.x, enemy.y, enemy.w, enemy.h,
      'sprites/circle/orange.png'
    ]
  end
  
  args.outputs.labels << [640, 50, "Collisions: #{hit_count}", 2, 1]
end
```

## Challenges

**Challenge 1:** Add collision sound effects
**Challenge 2:** Create bouncing balls
**Challenge 3:** Build a maze game with wall collisions

## Next Steps

Continue to [Timers and Cooldowns](021-timers)
