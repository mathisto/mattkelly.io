---
title: "Particle Systems"
description: "Create dynamic particle effects for explosions and trails"
difficulty: "advanced"
category: "effects"
order: 22
estimated_time: "20 min"
tags: ["particles", "effects", "animation"]
author: "Matt Kelly"
date: 2024-10-24
status: "published"
dragonruby_version: "5.0+"
---

# Particle Systems

Create stunning visual effects with particle systems for explosions, trails, and environmental effects.

## Basic Particle Emitter

```ruby:starter
def tick args
  args.state.particles ||= []
  
  # Spawn particle on click
  if args.inputs.mouse.click && args.inputs.mouse.x && args.inputs.mouse.y
    10.times do
      args.state.particles << {
        x: args.inputs.mouse.x,
        y: args.inputs.mouse.y,
        vx: -3 + rand(7),
        vy: 2 + rand(4),
        life: 60
      }
    end
  end
  
  # Update particles
  args.state.particles.each do |p|
    p[:x] += p[:vx]
    p[:y] += p[:vy]
    p[:vy] -= 0.2
    p[:life] -= 1
  end
  
  # Remove dead particles
  args.state.particles.reject! { |p| p[:life] <= 0 }
  
  # Render particles
  args.state.particles.each do |p|
    alpha = (255 * p[:life] / 60.0).to_i
    args.outputs.sprites << [
      p[:x], p[:y], 8, 8,
      'sprites/circle/yellow.png',
      0, alpha
    ]
  end
  
  args.outputs.labels << [640, 20, "Click to create particles", 2, 1]
end
```

## Advanced Particle System

```ruby:solution
def tick args
  args.state.particles ||= []
  args.state.emitter_x ||= 640
  args.state.emitter_y ||= 100
  
  # Move emitter with mouse
  if args.inputs.mouse.x && args.inputs.mouse.y
    args.state.emitter_x = args.inputs.mouse.x
    args.state.emitter_y = args.inputs.mouse.y
  end
  
  # Continuous emission
  if args.tick_count % 2 == 0
    args.state.particles << {
      x: args.state.emitter_x,
      y: args.state.emitter_y,
      vx: -2.0 + rand * 4.0,
      vy: 3.0 + rand * 3.0,
      size: 4 + rand(9),
      life: 40 + rand(41),
      max_life: 60,
      color: ['red', 'orange', 'yellow'].sample
    }
  end
  
  # Physics update
  args.state.particles.each do |p|
    p[:x] += p[:vx]
    p[:y] += p[:vy]
    p[:vy] -= 0.15
    p[:vx] *= 0.99
    p[:life] -= 1
  end
  
  # Remove dead particles
  args.state.particles.reject! { |p| p[:life] <= 0 || p[:y] < 0 }
  
  # Render with fade
  args.state.particles.each do |p|
    life_ratio = p[:life].fdiv(p[:max_life])
    alpha = (255 * life_ratio).to_i
    
    args.outputs.sprites << [
      p[:x] - p[:size] / 2,
      p[:y] - p[:size] / 2,
      p[:size], p[:size],
      "sprites/circle/#{p[:color]}.png",
      0, alpha
    ]
  end
  
  # Draw emitter
  args.outputs.sprites << [
    args.state.emitter_x - 8,
    args.state.emitter_y - 8,
    16, 16,
    'sprites/square/white.png'
  ]
  
  args.outputs.labels << [640, 700, "Particles: #{args.state.particles.length}", 2, 1]
  args.outputs.labels << [640, 20, "Move mouse to control emitter", 1, 1]
end
```

## Challenges

**Challenge 1:** Create explosion effects
**Challenge 2:** Add particle trails to moving objects
**Challenge 3:** Build a fireworks display

## Next Steps

Continue to [State Machines](023-state-machines)
