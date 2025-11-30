---
title: "Reading Gamepad Input"
description: "Add controller support for console-style gameplay"
difficulty: "beginner"
category: "input"
order: 17
estimated_time: "10 min"
tags: ["input", "gamepad", "controller"]
author: "Matt Kelly"
date: 2024-10-23
status: "published"
dragonruby_version: "5.0+"
---

# Reading Gamepad Input

Support game controllers for a true console gaming experience.

## Controller Detection

```ruby:starter
def tick args
  # Check if controller is connected
  if args.inputs.controller_one.connected
    args.outputs.labels << [640, 400, "Controller Connected!", 5, 1, 158, 206, 106]
    
    # Display controller name
    args.outputs.labels << [640, 340, "Type: #{args.inputs.controller_one.name || 'Unknown'}", 2, 1]
  else
    args.outputs.labels << [640, 360, "No controller detected", 4, 1, 247, 118, 142]
    args.outputs.labels << [640, 300, "Connect a controller to continue", 2, 1]
  end
end
```

## Button Input

```ruby:solution
def tick args
  return unless args.inputs.controller_one.connected
  
  controller = args.inputs.controller_one
  
  # Face buttons
  if controller.key_down.a
    puts "A button pressed!"
  end
  
  if controller.key_down.b
    puts "B button pressed!"
  end
  
  # D-pad movement
  args.state.player ||= { x: 640, y: 360 }
  speed = 5
  
  if controller.left
    args.state.player.x -= speed
  end
  
  if controller.right
    args.state.player.x += speed
  end
  
  if controller.up
    args.state.player.y += speed
  end
  
  if controller.down
    args.state.player.y -= speed
  end
  
  # Render
  args.outputs.sprites << [
    args.state.player.x - 32,
    args.state.player.y - 32,
    64, 64,
    'sprites/square/blue.png'
  ]
end
```

## Analog Sticks

```ruby:solution
def tick args
  return unless args.inputs.controller_one.connected
  
  controller = args.inputs.controller_one
  args.state.player ||= { x: 640, y: 360 }
  
  # Left analog stick (-1 to 1)
  left_x = controller.left_analog_x_perc || 0
  left_y = controller.left_analog_y_perc || 0
  
  # Apply deadzone
  deadzone = 0.2
  left_x = 0 if left_x.abs < deadzone
  left_y = 0 if left_y.abs < deadzone
  
  # Move player
  speed = 8
  args.state.player.x += left_x * speed
  args.state.player.y += left_y * speed
  
  # Bounds
  args.state.player.x = args.state.player.x.clamp(32, 1248)
  args.state.player.y = args.state.player.y.clamp(32, 688)
  
  # Render
  args.outputs.sprites << [
    args.state.player.x - 32,
    args.state.player.y - 32,
    64, 64,
    'sprites/square/blue.png'
  ]
  
  # Debug info
  args.outputs.labels << [10, 710, "Left Stick: (#{left_x.round(2)}, #{left_y.round(2)})", 2]
end
```

## Challenges

**Challenge 1:** Implement aim with right analog stick
**Challenge 2:** Add trigger buttons for shooting
**Challenge 3:** Create split-screen for two controllers

## Next Steps

Continue to [Building a Simple Menu System](018-menu-system)
