---
title: "Debugging with puts and Console"
description: "Learn essential debugging techniques for DragonRuby development"
difficulty: "beginner"
category: "getting-started"
order: 10
estimated_time: "10 min"
tags: ["debugging", "console", "development"]
author: "Matt Kelly"
date: 2024-10-23
status: "published"
dragonruby_version: "5.0+"
---

# Debugging with puts and Console

Debugging is an essential skill. Learn how to inspect values and track down bugs in your DragonRuby games.

## Using puts

The `puts` method prints to the console:

```ruby:starter
def tick args
  args.state.counter ||= 0
  args.state.counter += 1
  
  # Print to console every 60 ticks (once per second)
  if args.state.counter % 60 == 0
    puts "Tick: #{args.state.counter}"
    puts "Counter is divisible by 60!"
  end
  
  args.outputs.labels << [640, 360, "Check the console for output", 3, 1]
  args.outputs.labels << [640, 320, "Counter: #{args.state.counter}", 2, 1]
end
```

## Inspecting Objects

Use `.inspect` or `p` for detailed object output:

```ruby:readonly
def tick args
  args.state.player ||= {
    x: 640,
    y: 360,
    health: 100,
    inventory: ["sword", "shield"]
  }
  
  # Print entire object structure
  if args.inputs.keyboard.key_down.space
    puts "Player object:"
    puts args.state.player.inspect
    
    # Shorthand using 'p'
    p args.state.player
  end
  
  args.outputs.labels << [640, 360, "Press SPACE to inspect player", 3, 1]
end
```

## On-Screen Debug Info

Display debug info directly on screen:

```ruby:solution
def tick args
  # Initialize
  args.state.player ||= { x: 640, y: 360, vx: 0, vy: 0 }
  args.state.debug_mode ||= true
  
  # Toggle debug mode
  if args.inputs.keyboard.key_down.d
    args.state.debug_mode = !args.state.debug_mode
  end
  
  # Movement
  if args.inputs.keyboard.left
    args.state.player.vx = -5
  elsif args.inputs.keyboard.right
    args.state.player.vx = 5
  else
    args.state.player.vx = 0
  end
  
  args.state.player.x += args.state.player.vx
  
  # Render player
  args.outputs.sprites << [
    args.state.player.x - 32,
    args.state.player.y - 32,
    64, 64,
    'sprites/square/blue.png'
  ]
  
  # Debug overlay
  if args.state.debug_mode
    y = 710
    line_height = 25
    
    args.outputs.labels << [10, y, "=== DEBUG INFO ===", 2, 0, 158, 206, 106]
    y -= line_height
    
    args.outputs.labels << [10, y, "FPS: #{args.gtk.current_framerate.to_i}", 2]
    y -= line_height
    
    args.outputs.labels << [10, y, "Player X: #{args.state.player.x.to_i}", 2]
    y -= line_height
    
    args.outputs.labels << [10, y, "Player Y: #{args.state.player.y.to_i}", 2]
    y -= line_height
    
    args.outputs.labels << [10, y, "Velocity X: #{args.state.player.vx}", 2]
    y -= line_height
    
    args.outputs.labels << [10, y, "Mouse: (#{args.inputs.mouse.x.to_i}, #{args.inputs.mouse.y.to_i})", 2]
    y -= line_height
    
    args.outputs.labels << [10, y, "Press D to toggle debug", 2, 0, 122, 162, 247]
  end
end
```

## Conditional Debugging

Only debug when needed:

```ruby:readonly
def tick args
  DEBUG = true  # Set to false to disable all debug output
  
  args.state.counter ||= 0
  args.state.counter += 1
  
  # Debug helper method
  if DEBUG && args.state.counter % 60 == 0
    puts "=== Frame #{args.state.counter} ==="
    puts "Memory: #{args.gtk.stat_memory_usage} MB"
    puts "Objects: #{args.gtk.stat_object_count}"
  end
end
```

## Tracking State Changes

Monitor when values change:

```ruby:solution
def tick args
  args.state.score ||= 0
  args.state.prev_score ||= 0
  
  # Increment score on space
  if args.inputs.keyboard.key_down.space
    args.state.score += 10
  end
  
  # Detect and log changes
  if args.state.score != args.state.prev_score
    puts "Score changed: #{args.state.prev_score} → #{args.state.score}"
    args.state.prev_score = args.state.score
  end
  
  # Display
  args.outputs.labels << [640, 400, "Score: #{args.state.score}", 5, 1]
  args.outputs.labels << [640, 300, "Press SPACE to add points", 2, 1]
  args.outputs.labels << [640, 260, "Watch console for changes", 2, 1]
end
```

## Performance Monitoring

Track frame rate and performance:

```ruby:readonly
def tick args
  # Performance stats
  fps = args.gtk.current_framerate.to_i
  memory = "#{(args.gtk.stat_memory_usage / 1024.0).round(2)} MB"
  
  # Warn if FPS drops
  if fps < 50
    puts "WARNING: Low FPS detected: #{fps}"
  end
  
  # Display performance
  y = 710
  args.outputs.labels << [10, y, "FPS: #{fps}", 2]; y -= 25
  args.outputs.labels << [10, y, "Memory: #{memory}", 2]; y -= 25
  args.outputs.labels << [10, y, "Tick: #{args.tick_count}", 2]
end
```

## Debug Assertions

Add runtime checks:

```ruby:readonly
def tick args
  args.state.player ||= { health: 100 }
  
  # Reduce health
  if args.inputs.keyboard.key_down.space
    args.state.player.health -= 10
  end
  
  # Assertion - health should never go negative
  if args.state.player.health < 0
    puts "ERROR: Health went negative! #{args.state.player.health}"
    args.state.player.health = 0
  end
  
  # Assertion - health should never exceed max
  if args.state.player.health > 100
    puts "ERROR: Health exceeded maximum! #{args.state.player.health}"
    args.state.player.health = 100
  end
  
  args.outputs.labels << [640, 360, "Health: #{args.state.player.health}", 5, 1]
end
```

## Challenges

**Challenge 1:** Create a debug overlay showing all keyboard inputs

**Challenge 2:** Log every collision between objects to console

**Challenge 3:** Build a frame-by-frame playback system using debug output

## Next Steps

Continue to [Reading Keyboard Input](011-keyboard-input)
