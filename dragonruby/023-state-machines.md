---
title: "State Machines"
description: "Manage complex game states with finite state machines"
difficulty: "advanced"
category: "architecture"
order: 23
estimated_time: "25 min"
tags: ["state-machines", "architecture", "design-patterns"]
author: "Matt Kelly"
date: 2024-10-24
status: "published"
dragonruby_version: "5.0+"
---

# State Machines

Organize complex game logic with finite state machines for menus, gameplay, and AI behavior.

## Simple State Machine

```ruby:starter
def tick args
  args.state.game_state ||= :menu
  
  case args.state.game_state
  when :menu
    handle_menu(args)
  when :playing
    handle_playing(args)
  when :game_over
    handle_game_over(args)
  end
end

def handle_menu args
  args.outputs.labels << [640, 400, "MENU", 10, 1]
  args.outputs.labels << [640, 300, "Press SPACE to start", 3, 1]
  
  if args.inputs.keyboard.key_down.space
    args.state.game_state = :playing
    args.state.score = 0
  end
end

def handle_playing args
  args.state.score ||= 0
  args.state.score += 1
  
  args.outputs.labels << [640, 400, "PLAYING", 5, 1]
  args.outputs.labels << [640, 300, "Score: #{args.state.score}", 3, 1]
  args.outputs.labels << [640, 200, "Press ESC for game over", 1, 1]
  
  if args.inputs.keyboard.key_down.escape
    args.state.game_state = :game_over
  end
end

def handle_game_over args
  args.outputs.labels << [640, 400, "GAME OVER", 10, 1]
  args.outputs.labels << [640, 300, "Final Score: #{args.state.score}", 3, 1]
  args.outputs.labels << [640, 200, "Press R to restart", 2, 1]
  
  if args.inputs.keyboard.key_down.r
    args.state.game_state = :menu
  end
end
```

## Advanced AI State Machine

```ruby:solution
def tick args
  args.state.enemy ||= {
    x: 640, y: 360,
    state: :idle,
    state_timer: 0
  }
  
  args.state.player ||= { x: 100, y: 360 }
  
  # Move player
  args.state.player.x += 3 if args.inputs.keyboard.key_held.right
  args.state.player.x -= 3 if args.inputs.keyboard.key_held.left
  
  # Enemy AI
  enemy = args.state.enemy
  enemy[:state_timer] += 1
  
  case enemy[:state]
  when :idle
    if enemy[:state_timer] > 60
      enemy[:state] = :patrol
      enemy[:state_timer] = 0
      enemy[:patrol_dir] = 1
    end
    
  when :patrol
    enemy[:x] += enemy[:patrol_dir] * 2
    
    if enemy[:x] > 1000 || enemy[:x] < 300
      enemy[:patrol_dir] *= -1
    end
    
    distance = (enemy[:x] - args.state.player.x).abs
    if distance < 150
      enemy[:state] = :chase
      enemy[:state_timer] = 0
    end
    
  when :chase
    if enemy[:x] < args.state.player.x
      enemy[:x] += 4
    else
      enemy[:x] -= 4
    end
    
    distance = (enemy[:x] - args.state.player.x).abs
    if distance > 300
      enemy[:state] = :idle
      enemy[:state_timer] = 0
    end
  end
  
  # Render
  args.outputs.sprites << [
    args.state.player.x, args.state.player.y,
    50, 50, 'sprites/square/blue.png'
  ]
  
  color = case enemy[:state]
  when :idle then 'green'
  when :patrol then 'yellow'
  when :chase then 'red'
  end
  
  args.outputs.sprites << [
    enemy[:x], enemy[:y],
    50, 50, "sprites/square/#{color}.png"
  ]
  
  args.outputs.labels << [640, 700, "Enemy State: #{enemy[:state]}", 3, 1]
  args.outputs.labels << [640, 20, "Use LEFT/RIGHT to move", 1, 1]
end
```

## Challenges

**Challenge 1:** Add attack and retreat states
**Challenge 2:** Create a dialogue system with states
**Challenge 3:** Build a platformer with player states (jump, fall, run)

## Next Steps

Continue to [Camera Systems](024-camera)
