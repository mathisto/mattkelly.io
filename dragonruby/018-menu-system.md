---
title: "Building a Simple Menu System"
description: "Create navigable menus for game options and settings"
difficulty: "beginner"
category: "input"
order: 18
estimated_time: "15 min"
tags: ["ui", "menus", "navigation"]
author: "Matt Kelly"
date: 2024-10-23
status: "published"
dragonruby_version: "5.0+"
---

# Building a Simple Menu System

Every game needs menus. Learn to create keyboard and mouse-navigable menu systems.

## Basic Menu

```ruby:starter
def tick args
  args.state.menu ||= {
    options: ["Start Game", "Options", "Quit"],
    selected: 0
  }
  
  # Navigate with arrow keys
  if args.inputs.keyboard.key_down.up
    args.state.menu.selected -= 1
  end
  
  if args.inputs.keyboard.key_down.down
    args.state.menu.selected += 1
  end
  
  # Wrap selection
  options_count = args.state.menu.options.length
  args.state.menu.selected = args.state.menu.selected % options_count
  
  # Render menu
  y = 500
  args.state.menu.options.each_with_index do |option, index|
    is_selected = index == args.state.menu.selected
    color = is_selected ? [187, 154, 247] : [169, 177, 214]
    prefix = is_selected ? "> " : "  "
    
    args.outputs.labels << [640, y, "#{prefix}#{option}", 4, 1, *color]
    y -= 80
  end
  
  args.outputs.labels << [640, 100, "Use arrow keys, ENTER to select", 2, 1]
end
```

## Full Menu System

```ruby:solution
def tick args
  args.state.screen ||= :menu
  args.state.menu ||= { options: ["Start Game", "Options", "Credits", "Quit"], selected: 0 }
  
  case args.state.screen
  when :menu
    render_menu args
    handle_menu_input args
  when :game
    args.outputs.labels << [640, 360, "Game Started!", 5, 1]
    args.outputs.labels << [640, 300, "Press ESC for menu", 2, 1]
    if args.inputs.keyboard.key_down.escape
      args.state.screen = :menu
    end
  when :options
    args.outputs.labels << [640, 360, "Options Screen", 5, 1]
    args.outputs.labels << [640, 300, "Press ESC to go back", 2, 1]
    if args.inputs.keyboard.key_down.escape
      args.state.screen = :menu
    end
  when :credits
    args.outputs.labels << [640, 360, "Made by You!", 5, 1]
    args.outputs.labels << [640, 300, "Press ESC to go back", 2, 1]
    if args.inputs.keyboard.key_down.escape
      args.state.screen = :menu
    end
  end
end

def render_menu args
  # Title
  args.outputs.labels << [640, 650, "MY AWESOME GAME", 8, 1, 122, 162, 247]
  
  # Menu options
  y = 450
  args.state.menu.options.each_with_index do |option, index|
    is_selected = index == args.state.menu.selected
    
    # Highlight box
    if is_selected
      args.outputs.solids << [440, y - 35, 400, 60, 187, 154, 247, 50]
      args.outputs.borders << [440, y - 35, 400, 60, 187, 154, 247]
    end
    
    color = is_selected ? [187, 154, 247] : [169, 177, 214]
    args.outputs.labels << [640, y, option, 4, 1, *color]
    y -= 80
  end
  
  args.outputs.labels << [640, 80, "↑↓ Navigate | ENTER Select", 2, 1]
end

def handle_menu_input args
  # Navigate
  if args.inputs.keyboard.key_down.up
    args.state.menu.selected = (args.state.menu.selected - 1) % args.state.menu.options.length
  elsif args.inputs.keyboard.key_down.down
    args.state.menu.selected = (args.state.menu.selected + 1) % args.state.menu.options.length
  end
  
  # Select
  if args.inputs.keyboard.key_down.enter
    case args.state.menu.selected
    when 0 then args.state.screen = :game
    when 1 then args.state.screen = :options
    when 2 then args.state.screen = :credits
    when 3 then puts "Quit selected"
    end
  end
end
```

## Challenges

**Challenge 1:** Add mouse hover and click support
**Challenge 2:** Create sub-menus for options
**Challenge 3:** Add menu animations and transitions

## Next Steps

Continue to [Rotating Sprites](019-sprite-rotation) - Module 3: Sprites & Animation
