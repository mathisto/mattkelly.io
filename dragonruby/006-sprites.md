---
title: "Loading and Rendering Your First Sprite"
description: "Learn how to load and display images in your DragonRuby game"
difficulty: "beginner"
category: "getting-started"
order: 6
estimated_time: "10 min"
tags: ["rendering", "sprites", "images"]
author: "Matt Kelly"
date: 2024-10-23
status: "published"
dragonruby_version: "5.0+"
---

# Loading and Rendering Your First Sprite

Sprites are images that make up the visual elements of your game. Let's learn how to load and display them!

## Basic Sprite Rendering

```ruby:starter
def tick args
  # Sprite: [x, y, width, height, path]
  args.outputs.sprites << [100, 100, 128, 128, 'sprites/square/blue.png']
end
```

## Sprite Array Format

The sprite array contains:
- `x` - X position (bottom-left of sprite)
- `y` - Y position (bottom-left of sprite)
- `width` - Sprite width in pixels
- `height` - Sprite height in pixels
- `path` - Path to image file

## Built-in Sprites

DragonRuby includes basic shapes you can use:

```ruby:readonly
def tick args
  # Available built-in sprites
  args.outputs.sprites << [100, 500, 100, 100, 'sprites/square/blue.png']
  args.outputs.sprites << [250, 500, 100, 100, 'sprites/square/red.png']
  args.outputs.sprites << [400, 500, 100, 100, 'sprites/square/green.png']
  
  args.outputs.sprites << [100, 350, 100, 100, 'sprites/circle/blue.png']
  args.outputs.sprites << [250, 350, 100, 100, 'sprites/circle/red.png']
  args.outputs.sprites << [400, 350, 100, 100, 'sprites/circle/green.png']
end
```

## Sprite Hash Format

For more control, use hash format:

```ruby:solution
def tick args
  args.outputs.sprites << {
    x: 640 - 64,
    y: 360 - 64,
    w: 128,
    h: 128,
    path: 'sprites/square/blue.png',
    angle: 0,
    a: 255,  # Alpha (transparency)
    r: 255,  # Red tint
    g: 255,  # Green tint
    b: 255   # Blue tint
  }
  
  # Rotate sprite over time
  args.state.angle ||= 0
  args.state.angle += 1
  
  args.outputs.sprites << {
    x: 640 - 64,
    y: 360 - 64,
    w: 128,
    h: 128,
    path: 'sprites/square/red.png',
    angle: args.state.angle
  }
end
```

## Centering Sprites

By default, sprites anchor at bottom-left. To center:

```ruby:readonly
def tick args
  # Center sprite at screen center
  sprite_size = 128
  center_x = 640 - sprite_size / 2
  center_y = 360 - sprite_size / 2
  
  args.outputs.sprites << [center_x, center_y, sprite_size, sprite_size, 'sprites/square/blue.png']
end
```

## Challenges

**Challenge 1:** Display 5 different colored squares in a row

**Challenge 2:** Create a sprite that grows and shrinks over time

**Challenge 3:** Position a sprite to follow the mouse cursor

## Next Steps

Continue to [Sprite Positioning and Sizing](007-sprite-positioning)
