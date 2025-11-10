---
title: "Key Down vs Key Held"
description: "Understand the difference between key states for precise control"
difficulty: "beginner"
category: "input"
order: 12
estimated_time: "12 min"
tags: ["input", "keyboard", "key-states"]
author: "Matt Kelly"
date: 2024-10-23
status: "published"
dragonruby_version: "5.0+"
---

# Key Down vs Key Held

Understanding key states is crucial for responsive controls. Learn the difference between one-time presses and continuous holds.

## Three Key States

DragonRuby provides three ways to check keyboard input:

```ruby:starter
def tick args
  args.state.press_count ||= 0
  args.state.held_count ||= 0
  args.state.up_count ||= 0
  
  # key_down - Triggers ONCE when key first pressed
  if args.inputs.keyboard.key_down.space
    args.state.press_count += 1
  end
  
  # key_held - Triggers EVERY FRAME while held
  if args.inputs.keyboard.key_held.space
    args.state.held_count += 1
  end
  
  # key_up - Triggers ONCE when key released
  if args.inputs.keyboard.key_up.space
    args.state.up_count += 1
  end
  
  args.outputs.labels << [640, 500, "Hold SPACE to see the difference", 3, 1]
  args.outputs.labels << [640, 400, "key_down (press): #{args.state.press_count}", 3, 1]
  args.outputs.labels << [640, 350, "key_held (hold):  #{args.state.held_count}", 3, 1]
  args.outputs.labels << [640, 300, "key_up (release): #{args.state.up_count}", 3, 1]
end
```

## When to Use Each

```ruby:readonly
def tick args
  # key_down - For single actions (jump, shoot, menu selection)
  if args.inputs.keyboard.key_down.space
    puts "Player jumped!"
  end
  
  # key_held - For continuous actions (movement, charging)
  if args.inputs.keyboard.key_held.right
    puts "Player moving right..."
  end
  
  # key_up - For release actions (stop charging, release bow)
  if args.inputs.keyboard.key_up.space
    puts "Player landed!"
  end
end
```

## Jump Example

```ruby:solution
def tick args
  # Initialize
  args.state.player ||= { x: 640, y: 100, vy: 0, on_ground: true }
  gravity = -0.5
  jump_power = 12
  
  # Jump only when pressing (not holding)
  if args.inputs.keyboard.key_down.space && args.state.player.on_ground
    args.state.player.vy = jump_power
    args.state.player.on_ground = false
  end
  
  # Apply gravity
  args.state.player.vy += gravity
  args.state.player.y += args.state.player.vy
  
  # Ground collision
  if args.state.player.y <= 100
    args.state.player.y = 100
    args.state.player.vy = 0
    args.state.player.on_ground = true
  end
  
  # Render player
  args.outputs.sprites << [
    args.state.player.x - 32,
    args.state.player.y,
    64, 64,
    'sprites/square/blue.png'
  ]
  
  # Ground
  args.outputs.solids << [0, 0, 1280, 100, 50, 50, 50]
  
  # Instructions
  status = args.state.player.on_ground ? "On Ground" : "In Air"
  args.outputs.labels << [640, 680, status, 4, 1]
  args.outputs.labels << [640, 640, "Press SPACE to jump (not hold!)", 2, 1]
end
```

## Toggle with key_down

```ruby:solution
def tick args
  args.state.paused ||= false
  args.state.debug_mode ||= false
  
  # Toggle pause with P (key_down for single toggle)
  if args.inputs.keyboard.key_down.p
    args.state.paused = !args.state.paused
  end
  
  # Toggle debug with D
  if args.inputs.keyboard.key_down.d
    args.state.debug_mode = !args.state.debug_mode
  end
  
  # Update counter (only when not paused)
  unless args.state.paused
    args.state.counter ||= 0
    args.state.counter += 1
  end
  
  # Display
  pause_text = args.state.paused ? "PAUSED" : "RUNNING"
  pause_color = args.state.paused ? [247, 118, 142] : [158, 206, 106]
  
  args.outputs.labels << [640, 500, pause_text, 5, 1, *pause_color]
  args.outputs.labels << [640, 400, "Counter: #{args.state.counter || 0}", 3, 1]
  args.outputs.labels << [640, 300, "Debug: #{args.state.debug_mode ? 'ON' : 'OFF'}", 3, 1]
  args.outputs.labels << [640, 200, "P = Toggle Pause", 2, 1]
  args.outputs.labels << [640, 160, "D = Toggle Debug", 2, 1]
end
```

## Charging Attack

```ruby:solution
def tick args
  args.state.charge ||= 0
  args.state.max_charge ||= 180  # 3 seconds at 60 FPS
  
  # Charge while holding space
  if args.inputs.keyboard.key_held.space
    args.state.charge += 2
    args.state.charge = args.state.charge.clamp(0, args.state.max_charge)
  end
  
  # Release attack
  if args.inputs.keyboard.key_up.space && args.state.charge > 0
    power = (args.state.charge / args.state.max_charge.to_f * 100).to_i
    puts "Attack released! Power: #{power}%"
    args.state.last_power = power
    args.state.charge = 0
  end
  
  # Auto-discharge if max
  if args.state.charge >= args.state.max_charge
    args.state.last_power = 100
    args.state.charge = 0
  end
  
  # Visual charge bar
  bar_width = 400
  bar_height = 40
  bar_x = 640 - bar_width / 2
  bar_y = 300
  
  # Background
  args.outputs.borders << [bar_x, bar_y, bar_width, bar_height, 122, 162, 247]
  
  # Filled portion
  fill_width = (args.state.charge / args.state.max_charge.to_f * bar_width).to_i
  charge_pct = (args.state.charge / args.state.max_charge.to_f * 100).to_i
  
  # Color changes as charge increases
  r = [255, charge_pct * 2.55].min.to_i
  g = [255 - charge_pct * 2.55, 0].max.to_i
  b = 100
  
  args.outputs.solids << [bar_x, bar_y, fill_width, bar_height, r, g, b]
  
  # Labels
  args.outputs.labels << [640, 400, "Hold SPACE to charge attack", 3, 1]
  args.outputs.labels << [640, 260, "Charge: #{charge_pct}%", 2, 1]
  
  if args.state.last_power
    args.outputs.labels << [640, 200, "Last attack power: #{args.state.last_power}%", 3, 1]
  end
end
```

## Rapid Fire vs Single Shot

```ruby:readonly
def tick args
  args.state.bullets ||= []
  args.state.single_shots ||= 0
  args.state.rapid_shots ||= 0
  
  # Single shot with key_down (one bullet per press)
  if args.inputs.keyboard.key_down.z
    args.state.single_shots += 1
    puts "Single shot fired! Total: #{args.state.single_shots}"
  end
  
  # Rapid fire with key_held (every frame)
  if args.inputs.keyboard.key_held.x
    args.state.rapid_shots += 1
    puts "Rapid fire! Total: #{args.state.rapid_shots}"
  end
  
  args.outputs.labels << [640, 400, "Z = Single Shot: #{args.state.single_shots}", 3, 1]
  args.outputs.labels << [640, 350, "X = Rapid Fire: #{args.state.rapid_shots}", 3, 1]
  args.outputs.labels << [640, 250, "Try holding each key and see the difference!", 2, 1]
end
```

## Challenges

**Challenge 1:** Create a double-jump system using key_down

**Challenge 2:** Build a dash mechanic that activates on key_down with cooldown

**Challenge 3:** Implement a combo system: press A, B, C in sequence within 2 seconds

## Next Steps

Continue to [Moving a Sprite with Arrow Keys](013-arrow-movement)
