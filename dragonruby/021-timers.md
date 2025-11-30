---
title: "Timers and Cooldowns"
description: "Implement time-based events and cooldown systems"
difficulty: "intermediate"
category: "game-logic"
order: 21
estimated_time: "12 min"
tags: ["timers", "cooldowns", "time"]
author: "Matt Kelly"
date: 2024-10-24
status: "published"
dragonruby_version: "5.0+"
---

# Timers and Cooldowns

Master time-based events for weapon cooldowns, spawn timers, and timed challenges.

## Simple Timer

```ruby:starter
def tick args
  args.state.timer ||= 180
  
  # Countdown
  args.state.timer -= 1 if args.state.timer > 0
  
  # Convert to seconds
  seconds = (args.state.timer / 60.0).ceil
  
  # Visual feedback
  args.outputs.solids << [0, 0, 1280, 720, 26, 27, 38]
  
  if args.state.timer > 0
    args.outputs.labels << [640, 360, "Time: #{seconds}s", 10, 1]
  else
    args.outputs.labels << [640, 360, "TIME'S UP!", 10, 1, 255, 100, 100]
  end
end
```

## Ability Cooldown

```ruby:solution
def tick args
  args.state.last_shot ||= 0
  args.state.cooldown_frames ||= 60
  args.state.projectiles ||= []
  
  # Calculate frames since last shot
  frames_since_shot = args.tick_count - args.state.last_shot
  can_shoot = frames_since_shot >= args.state.cooldown_frames
  
  # Shoot on spacebar (if cooldown ready)
  if args.inputs.keyboard.key_down.space && can_shoot
    args.state.projectiles << {
      x: 640,
      y: 360,
      speed: 5
    }
    args.state.last_shot = args.tick_count
  end
  
  # Update projectiles
  args.state.projectiles.each do |proj|
    proj[:x] += proj[:speed]
  end
  
  # Remove off-screen projectiles
  args.state.projectiles.reject! { |p| p[:x] > 1280 }
  
  # Draw projectiles
  args.state.projectiles.each do |proj|
    args.outputs.sprites << [
      proj[:x], proj[:y], 20, 20,
      'sprites/circle/yellow.png'
    ]
  end
  
  # Draw cooldown bar
  cooldown_percent = frames_since_shot.fdiv(args.state.cooldown_frames)
  bar_width = (200 * [cooldown_percent, 1.0].min).to_i
  
  args.outputs.solids << [540, 50, 200, 20, 40, 40, 50]
  args.outputs.solids << [540, 50, bar_width, 20, 122, 162, 247]
  
  status = can_shoot ? "READY" : "RECHARGING"
  args.outputs.labels << [640, 100, status, 2, 1]
  args.outputs.labels << [640, 20, "Press SPACE to shoot", 1, 1]
end
```

## Challenges

**Challenge 1:** Create a wave spawner
**Challenge 2:** Add multiple ability cooldowns
**Challenge 3:** Build a timer-based puzzle

## Next Steps

Continue to [Particle Systems](022-particles)
