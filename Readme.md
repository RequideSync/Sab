# Sab UI Library Demo Document

**Description:** The Best Undetected UI for Steal a Brainrot

## 1. Library Loading and Title Setup

This is the initial code to load the library and set the main UI title.

```lua
local Sab = loadstring(game:HttpGet("https://raw.githubusercontent.com/RequideSync/Sab/refs/heads/main/Scr/V2.lua"))()

if Sab then
    Sab:SetTitle("Sab UI All Elements Demo")
end
```

---

## 2. Creating Tabs (`Sab:cTab`)

Construct the main navigation tabs for the UI.

```lua
local TabElements = Sab:cTab("Basic Elements")
local TabNotifications = Sab:cTab("Notifications")
local TabFloatingElements = Sab:cTab("Floating Elements Control")
```

---

## 3. Basic Elements (`:Button`, `:Toggle`, `:Slider`) Implementation

### 3.1. Button (`:Button`)

```lua
TabElements:Button("1. Button (Click)", function()
    Sab:MakeNotify({
        Title = "Button Action", 
        SubTitle = "Click detected.", 
        Duration = 1.5
    })
end)
```

### 3.2. Slider (`:Slider`)

Defined first for the Toggle demonstration.

```lua
local SliderElement = TabElements:Slider(
    "3. Slider (Value: 0 - 100)", 
    0, 
    100, 
    50, 
    function(value)
        print("Slider Value: " .. tostring(value))
    end
)
```

### 3.3. Toggle (`:Toggle`)

Demonstrates controlling the visibility of the Slider.

```lua
local myToggle = TabElements:Toggle("2. Toggle Switch", function(state)
    Sab:MakeNotify({
        Title = "Toggle Action", 
        SubTitle = state and "Switched ON." or "Switched OFF.", 
        Duration = 1.5
    })
    SliderElement.Frame.Visible = state
end)
```

---

## 4. Notifications Demo (`Sab:MakeNotify`)

Tests notifications with different display durations.

```lua
TabNotifications:Button("4. Show Notification (5 sec)", function()
    Sab:MakeNotify({
        Title = "Long Notification Test", 
        SubTitle = "This notification disappears automatically.", 
        Duration = 5
    })
end)

TabNotifications:Button("4. Show Short Notification (1 sec)", function()
    Sab:MakeNotify({
        Title = "Quick Notification", 
        SubTitle = "A brief message!", 
        Duration = 1
    })
end)
```

---

## 5. Floating Elements (`Sab:cMenu`) Implementation and Control

### 5.1. Defining Floating Elements (Button and Toggle)

These elements are draggable and exist outside the main UI window.

```lua
local FloatingBtn = Sab:cMenu("5. Floating Button (Draggable)", {
    Type = "Button",
    Callback = function()
        Sab:MakeNotify({
            Title = "Floating Button", 
            SubTitle = "Independent element clicked.", 
            Duration = 2
        })
    end,
    Position = UDim2.new(0.05, 0, 0.2, 0)
})

local FloatingToggle = Sab:cMenu("6. Floating Toggle (Draggable)", {
    Type = "Toggle",
    Callback = function(state)
        Sab:MakeNotify({
            Title = "Floating Toggle", 
            SubTitle = state and "ON" or "OFF", 
            Duration = 2
        })
    end,
    Position = UDim2.new(0.05, 0, 0.35, 0)
})

-- Hide elements initially
FloatingBtn.Frame.Visible = false
FloatingToggle.Frame.Visible = false
```
