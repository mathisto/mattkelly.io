---
title: "Introduction to args.state"
description: "Learn how to store and manage game state across ticks"
difficulty: "beginner"
category: "getting-started"
order: 8
estimated_time: "12 min"
tags: ["state", "variables", "game-logic"]
author: "Matt Kelly"
date: 2024-10-23
status: "published"
dragonruby_version: "5.0+"
---

# Introduction to args.state

`args.state` is your game's memory. It persists data between ticks, allowing you to track positions, scores, and more.

## Why args.state?

Without `args.state`, variables reset every tick (60 times per second). With it, data persists:

```ruby:starter
def tick args
  # Without state - resets every tick!
  x = 0
  x += 1
  args.outputs.labels << [640, 400, "x = #{x}", 5, 1]  # Always shows "x = 1"
  
  # With state - persists!
  args.state.counter ||= 0
  args.state.counter += 1
  args.outputs.labels << [640, 300, "counter = #{args.state.counter}", 5, 1]  # Increments!
end
```

## The ||= Operator

The `||=` (or-equals) operator initializes a value only if it's `nil`:

```ruby:readonly
def tick args
  # On first tick: position is nil, so set to 100
  # On subsequent ticks: position exists, so don't change it
  args.state.position ||= 100
  
  # This is equivalent to:
  # if args.state.position.nil?
  #   args.state.position = 100
  # end
end
```

## Storing Different Types

`args.state` can hold any Ruby object:

```ruby:solution
def tick args
  # Numbers
  args.state.score ||= 0
  args.state.health ||= 100.0
  
  # Strings
  args.state.player_name ||= "Hero"
  
  # Arrays
  args.state.inventory ||= ["sword", "shield", "potion"]
  
  # Hashes
  args.state.player ||= { x: 640, y: 360, speed: 5 }
  
  # Booleans
  args.state.game_started ||= false
  
  # Display state
  y = 600
  args.outputs.labels << [100, y, "Score: #{args.state.score}", 2]; y -= 40
  args.outputs.labels << [100, y, "Health: #{args.state.health}", 2]; y -= 40
  args.outputs.labels << [100, y, "Name: #{args.state.player_name}", 2]; y -= 40
  args.outputs.labels << [100, y, "Inventory: #{args.state.inventory.join(', ')}", 2]; y -= 40
  args.outputs.labels << [100, y, "Player X: #{args.state.player.x}", 2]; y -= 40
end
```

## Modifying State

Update state values as needed:

```ruby:readonly
def tick args
  # Initialize
  args.state.x ||= 0
  args.state.speed ||= 2
  
  # Modify
  args.state.x += args.state.speed
  
  # Conditional modification
  if args.state.x > 1280
    args.state.x = 0
  end
  
  args.outputs.sprites << [args.state.x, 360, 50, 50, 'sprites/square/blue.png']
end
```

## Player State Example

```ruby:solution
def tick args
  # Initialize player
  args.state.player ||= {
    x: 640,
    y: 360,
    size: 64,
    speed: 5,
    color: 'blue'
  }
  
  # Movement controls
  if args.inputs.keyboard.left
    args.state.player.x -= args.state.player.speed
  end
  
  if args.inputs.keyboard.right
    args.state.player.x += args.state.player.speed
  end
  
  if args.inputs.keyboard.up
    args.state.player.y += args.state.player.speed
  end
  
  if args.inputs.keyboard.down
    args.state.player.y -= args.state.player.speed
  end
  
  # Keep player on screen
  args.state.player.x = args.state.player.x.clamp(0, 1280 - args.state.player.size)
  args.state.player.y = args.state.player.y.clamp(0, 720 - args.state.player.size)
  
  # Render player
  args.outputs.sprites << [
    args.state.player.x,
    args.state.player.y,
    args.state.player.size,
    args.state.player.size,
    "sprites/square/#{args.state.player.color}.png"
  ]
  
  # Display position
  args.outputs.labels << [10, 710, "Position: (#{args.state.player.x.to_i}, #{args.state.player.y.to_i})", 2]
  args.outputs.labels << [10, 680, "Use arrow keys to move", 2]
end
```

## State Organization

Keep state organized with nested hashes:

```ruby:readonly
def tick args
  args.state.game ||= {
    score: 0,
    level: 1,
    time: 0
  }
  
  args.state.player ||= {
    x: 640,
    y: 360,
    health: 100
  }
  
  args.state.enemies ||= []
  
  # Access nested values
  args.state.game.score += 1
  args.state.player.health -= 1
end
```

## Challenges

**Challenge 1:** Create a counter that increments every 60 ticks (once per second)

**Challenge 2:** Track mouse clicks and display total click count

**Challenge 3:** Build a sprite that bounces between screen edges using state

## Next Steps

Continue to [Using ||= for Initialization](009-initialization)
