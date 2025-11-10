---
title: "Understanding the Tick Method and Game Loop"
description: "Learn how DragonRuby's game loop works at 60 FPS"
difficulty: "beginner"
category: "getting-started"
order: 2
estimated_time: "8 min"
tags: ["basics", "game-loop", "fps"]
author: "Matt Kelly"
date: 2024-10-23
status: "published"
dragonruby_version: "5.0+"
---

# Understanding the Tick Method and Game Loop

The `tick` method is the heart of every DragonRuby game. It runs 60 times per second, creating smooth animations and responsive gameplay.

## The Game Loop

```ruby:starter
def tick args
  args.state.tick_count ||= 0
  args.state.tick_count += 1
  
  args.outputs.labels << [640, 360, "Tick: #{args.state.tick_count}", 5, 1]
end
```

## What's Happening?

- `args.state` - Persistent storage that survives between ticks
- `||=` - Ruby's "or-equals" operator (sets value if nil)
- `tick_count` - A counter that increments every frame

## Frame Rate

DragonRuby runs at 60 frames per second (FPS):
- 60 ticks = 1 second
- 3600 ticks = 1 minute
- Frame time = ~16.67 milliseconds

## Time-Based Logic

```ruby:solution
def tick args
  args.state.tick_count ||= 0
  args.state.tick_count += 1
  
  seconds = args.state.tick_count / 60
  
  args.outputs.labels << [640, 400, "Tick: #{args.state.tick_count}", 3, 1]
  args.outputs.labels << [640, 320, "Seconds: #{seconds}", 3, 1]
end
```

## Challenges

**Challenge 1:** Display a countdown timer from 10 to 0

**Challenge 2:** Make text appear only every 30 ticks (twice per second)

**Challenge 3:** Calculate and display minutes and seconds

## Next Steps

Continue to [The Coordinate System](003-coordinate-system)
