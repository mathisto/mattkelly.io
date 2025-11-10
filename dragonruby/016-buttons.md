---
title: "Creating Clickable Buttons"
description: "Build interactive UI buttons with hover and click states"
difficulty: "beginner"
category: "input"
order: 16
estimated_time: "12 min"
tags: ["ui", "buttons", "mouse", "interaction"]
author: "Matt Kelly"
date: 2024-10-23
status: "published"
dragonruby_version: "5.0+"
---

# Creating Clickable Buttons

Build interactive buttons for menus, UI, and in-game controls.

## Basic Button

```ruby:starter
def tick args
  # Button definition
  button = { x: 540, y: 310, w: 200, h: 100 }
  
  # Check if mouse is over button
  mouse_over = args.inputs.mouse.inside_rect? button
  
  # Button color (change on hover)
  color = mouse_over ? [187, 154, 247] : [122, 162, 247]
  
  # Render button
  args.outputs.solids << [button.x, button.y, button.w, button.h, *color]
  args.outputs.borders << [button.x, button.y, button.w, button.h, 255, 255, 255]
  args.outputs.labels << [640, 360, "Click Me", 4, 1]
  
  # Handle click
  if mouse_over && args.inputs.mouse.click
    puts "Button clicked!"
  end
end
```

## Button States

```ruby:solution
def tick args
  args.state.click_count ||= 0
  
  button = { x: 490, y: 285, w: 300, h: 150 }
  
  # Determine state
  mouse_over = args.inputs.mouse.inside_rect? button
  mouse_down = mouse_over && args.inputs.mouse.button_left
  
  # State-based colors
  if mouse_down
    bg_color = [158, 206, 106]  # Green when pressed
    border_color = [158, 206, 106]
  elsif mouse_over
    bg_color = [187, 154, 247]  # Purple on hover
    border_color = [187, 154, 247]
  else
    bg_color = [122, 162, 247]  # Blue default
    border_color = [122, 162, 247]
  end
  
  # Render
  args.outputs.solids << [button.x, button.y, button.w, button.h, *bg_color, 200]
  args.outputs.borders << [button.x, button.y, button.w, button.h, *border_color, 255]
  args.outputs.labels << [640, 360, "Click Counter", 5, 1]
  args.outputs.labels << [640, 310, "Clicks: #{args.state.click_count}", 3, 1]
  
  # Click handler
  if mouse_over && args.inputs.mouse.click
    args.state.click_count += 1
  end
end
```

## Multiple Buttons

```ruby:solution
def tick args
  args.state.selected ||= "None"
  
  buttons = [
    { x: 100, y: 500, w: 180, h: 80, label: "Red", action: "red" },
    { x: 300, y: 500, w: 180, h: 80, label: "Green", action: "green" },
    { x: 500, y: 500, w: 180, h: 80, label: "Blue", action: "blue" }
  ]
  
  buttons.each do |btn|
    mouse_over = args.inputs.mouse.inside_rect? btn
    selected = args.state.selected == btn.action
    
    # Colors
    if selected
      bg = [158, 206, 106]
    elsif mouse_over
      bg = [187, 154, 247]
    else
      bg = [70, 70, 90]
    end
    
    # Render button
    args.outputs.solids << [btn.x, btn.y, btn.w, btn.h, *bg]
    args.outputs.borders << [btn.x, btn.y, btn.w, btn.h, 200, 200, 200]
    args.outputs.labels << [btn.x + 90, btn.y + 50, btn.label, 3, 1]
    
    # Handle click
    if mouse_over && args.inputs.mouse.click
      args.state.selected = btn.action
    end
  end
  
  args.outputs.labels << [640, 300, "Selected: #{args.state.selected}", 4, 1]
end
```

## Challenges

**Challenge 1:** Create disabled button state
**Challenge 2:** Add button press animation
**Challenge 3:** Build a calculator with number buttons

## Next Steps

Continue to [Reading Gamepad Input](017-gamepad-input)
