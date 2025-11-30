---
title: "Hello World - Your First DragonRuby Program"
description: "Learn the basics of DragonRuby by displaying your first message"
difficulty: "beginner"
category: "getting-started"
order: 1
estimated_time: "5 min"
tags: ["basics", "labels", "tick"]
author: "Matt Kelly"
date: 2024-10-23
status: "published"
dragonruby_version: "5.0+"
---

# Hello World - Your First DragonRuby Program

Welcome to your first DragonRuby tutorial! In this lesson, you'll 
learn the fundamental structure of a DragonRuby program and display 
your first message on screen.

## The Tick Method

Every DragonRuby game has a `tick` method that runs 60 times per 
second. This is where all your game logic goes.

```ruby:starter
def tick args
  args.outputs.solids << [0, 0, 1280, 720, 26, 27, 38]
  args.outputs.labels << [640, 360, "Hello, DragonRuby!", 10, 1, 255, 255, 255]
end
```

## Understanding the Code

Let's break down what's happening:

- `def tick args` - Defines the tick method that receives game state
- `args.outputs.labels` - Accesses the label output array
- `[640, 360, "Hello, DragonRuby!", 5, 1]` - Creates a label with:
  - `640` - X position (center of 1280px screen)
  - `360` - Y position (center of 720px screen)  
  - `"Hello, DragonRuby!"` - The text to display
  - `5` - Font size (0-10 scale)
  - `1` - Alignment (0=left, 1=center, 2=right)

## Try It Out

Click the "Run" button to see your first DragonRuby program in 
action!

## Challenges

**Challenge 1:** Change the message to display your name

**Challenge 2:** Move the text to different positions on screen

**Challenge 3:** Try different font sizes (0-10)

## Next Steps

Continue to [Understanding the Tick Method](002-tick-method)
