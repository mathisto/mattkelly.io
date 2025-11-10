---
title: "Reading Keyboard Input"
description: "Learn how to detect and respond to keyboard input"
difficulty: "beginner"
category: "input"
order: 11
estimated_time: "10 min"
tags: ["input", "keyboard", "controls"]
author: "Matt Kelly"
date: 2024-10-23
status: "published"
dragonruby_version: "5.0+"
---

# Reading Keyboard Input

Make your games interactive by responding to keyboard input. Let's explore all the ways to read keys.

## Basic Key Detection

```ruby:starter
def tick args
  # Check if key is currently held down
  if args.inputs.keyboard.a
    args.outputs.labels << [640, 360, "A key is pressed!", 5, 1]
  else
    args.outputs.labels << [640, 360, "Press the A key", 5, 1]
  end
end
```

## Common Keys

```ruby:readonly
def tick args
  y = 650
  line_height = 40
  
  # Letter keys
  if args.inputs.keyboard.a
    args.outputs.labels << [100, y, "A key pressed", 3]
  end
  y -= line_height
  
  # Number keys
  if args.inputs.keyboard.one
    args.outputs.labels << [100, y, "1 key pressed", 3]
  end
  y -= line_height
  
  # Arrow keys
  if args.inputs.keyboard.up
    args.outputs.labels << [100, y, "UP arrow pressed", 3]
  end
  y -= line_height
  
  # Special keys
  if args.inputs.keyboard.space
    args.outputs.labels << [100, y, "SPACE pressed", 3]
  end
  y -= line_height
  
  if args.inputs.keyboard.enter
    args.outputs.labels << [100, y, "ENTER pressed", 3]
  end
  y -= line_height
  
  if args.inputs.keyboard.shift
    args.outputs.labels << [100, y, "SHIFT pressed", 3]
  end
end
```

## Key Names Reference

```ruby:solution
def tick args
  keys = {
    letters: ['a', 'b', 'c', 'd', 'e', 'f'],
    numbers: ['zero', 'one', 'two', 'three'],
    arrows: ['up', 'down', 'left', 'right'],
    special: ['space', 'enter', 'escape', 'shift', 'tab']
  }
  
  args.outputs.labels << [640, 680, "Press any key to see it detected", 3, 1]
  
  y = 620
  line_height = 30
  
  # Show pressed keys
  pressed_keys = []
  
  keys.each do |category, key_list|
    key_list.each do |key|
      if args.inputs.keyboard.send(key)
        pressed_keys << key.upcase
      end
    end
  end
  
  if pressed_keys.any?
    args.outputs.labels << [640, y, "Currently pressed: #{pressed_keys.join(', ')}", 4, 1, 158, 206, 106]
  else
    args.outputs.labels << [640, y, "No keys pressed", 2, 1, 86, 95, 137]
  end
end
```

## Arrow Key Movement

```ruby:solution
def tick args
  # Initialize player
  args.state.player ||= { x: 640, y: 360 }
  speed = 5
  
  # Movement with arrow keys
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
  
  # Keep on screen
  args.state.player.x = args.state.player.x.clamp(0, 1280 - 64)
  args.state.player.y = args.state.player.y.clamp(0, 720 - 64)
  
  # Render
  args.outputs.sprites << [
    args.state.player.x,
    args.state.player.y,
    64, 64,
    'sprites/square/blue.png'
  ]
  
  args.outputs.labels << [640, 50, "Use arrow keys to move", 2, 1]
end
```

## Multiple Key Combinations

```ruby:readonly
def tick args
  args.state.player ||= { x: 640, y: 360, size: 64 }
  base_speed = 3
  
  # Sprint when holding shift
  speed = args.inputs.keyboard.shift ? base_speed * 2 : base_speed
  
  # Diagonal movement
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
  
  # Render
  color = args.inputs.keyboard.shift ? 'red' : 'blue'
  args.outputs.sprites << [
    args.state.player.x - 32,
    args.state.player.y - 32,
    args.state.player.size,
    args.state.player.size,
    "sprites/square/#{color}.png"
  ]
  
  status = args.inputs.keyboard.shift ? "SPRINTING (#{speed})" : "Walking (#{speed})"
  args.outputs.labels << [640, 50, status, 3, 1]
  args.outputs.labels << [640, 20, "Hold SHIFT to sprint", 2, 1]
end
```

## Checking All Pressed Keys

```ruby:readonly
def tick args
  # Get array of all currently pressed keys
  if args.inputs.keyboard.key_held.truthy_keys.any?
    keys = args.inputs.keyboard.key_held.truthy_keys.join(', ')
    args.outputs.labels << [640, 360, "Pressed: #{keys}", 3, 1]
  else
    args.outputs.labels << [640, 360, "Press some keys!", 3, 1]
  end
end
```

## Challenges

**Challenge 1:** Create 8-directional movement using arrow keys

**Challenge 2:** Make different keys change the player's color

**Challenge 3:** Implement a key combo system (press A+B together for special action)

## Next Steps

Continue to [Key Down vs Key Held](012-key-states)
