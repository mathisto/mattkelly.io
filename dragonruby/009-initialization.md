---
title: "Using ||= for Initialization"
description: "Master the or-equals operator for clean state initialization"
difficulty: "beginner"
category: "getting-started"
order: 9
estimated_time: "8 min"
tags: ["state", "initialization", "ruby"]
author: "Matt Kelly"
date: 2024-10-23
status: "published"
dragonruby_version: "5.0+"
---

# Using ||= for Initialization

The `||=` operator is your best friend for initializing game state. Let's master this Ruby idiom.

## How ||= Works

The or-equals operator only assigns if the value is `nil` or `false`:

```ruby:starter
def tick args
  # First tick: score is nil, so set to 0
  # Every other tick: score exists, so don't reset it
  args.state.score ||= 0
  args.state.score += 1
  
  args.outputs.labels << [640, 360, "Score: #{args.state.score}", 5, 1]
end
```

## Common Pattern

Initialize all state at the start of tick:

```ruby:readonly
def tick args
  # Initialization block
  args.state.player_x ||= 640
  args.state.player_y ||= 360
  args.state.speed ||= 5
  args.state.score ||= 0
  args.state.game_started ||= false
  
  # Game logic uses initialized values
  if args.state.game_started
    args.state.player_x += args.state.speed
    args.state.score += 1
  end
end
```

## What Gets Initialized?

```ruby:readonly
def tick args
  # Numbers - use 0 or specific starting value
  args.state.counter ||= 0
  args.state.health ||= 100
  args.state.speed ||= 2.5
  
  # Strings
  args.state.name ||= "Player"
  args.state.status ||= "idle"
  
  # Arrays (use [] not nil)
  args.state.enemies ||= []
  args.state.bullets ||= []
  
  # Hashes
  args.state.player ||= { x: 0, y: 0 }
  
  # Booleans (careful with false!)
  args.state.game_over ||= false  # Works
  
  # Display
  args.outputs.labels << [100, 600, "Counter: #{args.state.counter}", 3]
  args.outputs.labels << [100, 550, "Enemies: #{args.state.enemies.length}", 3]
end
```

## Boolean Trap

Be careful with boolean `false` values:

```ruby:solution
def tick args
  # WRONG - This will reset every tick!
  # args.state.paused ||= false
  
  # RIGHT - Use .nil? check for booleans
  if args.state.paused.nil?
    args.state.paused = false
  end
  
  # Toggle with spacebar
  if args.inputs.keyboard.key_down.space
    args.state.paused = !args.state.paused
  end
  
  # Update only when not paused
  unless args.state.paused
    args.state.counter ||= 0
    args.state.counter += 1
  end
  
  # Display
  status = args.state.paused ? "PAUSED" : "RUNNING"
  args.outputs.labels << [640, 400, status, 5, 1]
  args.outputs.labels << [640, 300, "Counter: #{args.state.counter || 0}", 3, 1]
  args.outputs.labels << [640, 200, "Press SPACE to toggle", 2, 1]
end
```

## Complex Initialization

Initialize nested structures:

```ruby:readonly
def tick args
  # Initialize player with defaults
  args.state.player ||= {
    x: 640,
    y: 360,
    vx: 0,
    vy: 0,
    width: 64,
    height: 64,
    health: 100,
    max_health: 100,
    inventory: [],
    stats: {
      strength: 10,
      defense: 5,
      speed: 3
    }
  }
  
  # Access nested values
  args.state.player.stats.speed += 1
end
```

## Conditional Initialization

Different initial values based on conditions:

```ruby:solution
def tick args
  # Initialize based on difficulty
  args.state.difficulty ||= "normal"
  
  # Set enemy count based on difficulty
  if args.state.enemy_count.nil?
    args.state.enemy_count = case args.state.difficulty
      when "easy" then 5
      when "normal" then 10
      when "hard" then 20
      else 10
    end
  end
  
  # Initialize enemies array
  args.state.enemies ||= []
  
  # Spawn enemies on first tick
  if args.state.enemies.empty? && args.state.enemy_count > 0
    args.state.enemy_count.times do |i|
      args.state.enemies << {
        x: 100 + i * 100,
        y: 600,
        size: 40
      }
    end
  end
  
  # Render enemies
  args.state.enemies.each do |enemy|
    args.outputs.sprites << [enemy.x, enemy.y, enemy.size, enemy.size, 'sprites/square/red.png']
  end
  
  # Display info
  args.outputs.labels << [640, 100, "Difficulty: #{args.state.difficulty}", 3, 1]
  args.outputs.labels << [640, 60, "Enemies: #{args.state.enemies.length}", 3, 1]
end
```

## Factory Pattern

Create initialization helper methods:

```ruby:readonly
def tick args
  args.state.player ||= create_player(640, 360)
  args.state.enemies ||= []
  
  # Spawn enemy on mouse click
  if args.inputs.mouse.click
    args.state.enemies << create_enemy(
      args.inputs.mouse.x,
      args.inputs.mouse.y
    )
  end
end

def create_player(x, y)
  {
    x: x,
    y: y,
    width: 64,
    height: 64,
    health: 100,
    speed: 5,
    color: 'blue'
  }
end

def create_enemy(x, y)
  {
    x: x,
    y: y,
    width: 40,
    height: 40,
    health: 50,
    speed: 2,
    color: 'red'
  }
end
```

## Challenges

**Challenge 1:** Initialize a game with 3 difficulty levels affecting enemy speed

**Challenge 2:** Create a reset button that clears all state and re-initializes

**Challenge 3:** Build a system that tracks high score across game sessions

## Next Steps

Continue to [Debugging with puts and Console](010-debugging)
