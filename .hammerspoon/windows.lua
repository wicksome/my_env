module = {}
-------------------
-- Configuration --
-------------------

local resizeing_scale = 20 -- px

-- Margins --
local screen_edge_margins = {
    top = 0, -- px
    left = 0,
    right = 0,
    bottom = 0
}
local partition_margins = {
    x = 0, -- px
    y = 0
}

-- Partitions --
local split_screen_partitions = {
    x = 0.5, -- %
    y = 0.5
}
local quarter_screen_partitions = {
    x = 0.5, -- %
    y = 0.5
}

----------------
-- Public API --
----------------

module.move_half_window_to_left = function()
    local s = screen()
    local ssp = split_screen_partitions
    local g = gutter()
    set_frame("Left", {
        x = s.x,
        y = s.y,
        w = (s.w * ssp.x) - gutter().x,
        h = s.h
    })
end

module.move_half_window_to_right = function()
    local s = screen()
    local ssp = split_screen_partitions
    local g = gutter()
    set_frame("Right", {
        x = s.x + (s.w * ssp.x) + g.x,
        y = s.y,
        w = (s.w * (1 - ssp.x)) - g.x,
        h = s.h
    })
end

module.move_half_window_to_up = function()
    local s = screen()
    local ssp = split_screen_partitions
    local g = gutter()
    set_frame("Up", {
        x = s.x,
        y = s.y,
        w = s.w,
        h = (s.h * ssp.y) - g.y
    })
end

module.move_half_window_to_down = function()
    local s = screen()
    local ssp = split_screen_partitions
    local g = gutter()
    set_frame("Down", {
        x = s.x,
        y = s.y + (s.h * ssp.y) + g.y,
        w = s.w,
        h = (s.h * (1 - ssp.y)) - g.y
    })
end

module.move_window_to_left = function()
    local unit = win():frame()
    set_frame("Move left", {
        x = unit.x - resizeing_scale,
        y = unit.y,
        w = unit.w,
        h = unit.h
    })
end

module.move_window_to_right = function()
    local unit = win():frame()
    set_frame("Move right", {
        x = unit.x + resizeing_scale,
        y = unit.y,
        w = unit.w,
        h = unit.h
    })
end

module.move_window_to_up = function()
    local unit = win():frame()
    set_frame("Move up", {
        x = unit.x,
        y = unit.y - resizeing_scale,
        w = unit.w,
        h = unit.h
    })
end

module.move_window_to_down = function()
    local unit = win():frame()
    set_frame("Move down", {
        x = unit.x,
        y = unit.y + resizeing_scale,
        w = unit.w,
        h = unit.h
    })
end

module.move_window_upper_left = function()
    local s = screen()
    local qsp = quarter_screen_partitions
    local g = gutter()
    set_frame("Upper Left", {
        x = s.x,
        y = s.y,
        w = (s.w * qsp.x) - g.x,
        h = (s.h * qsp.y) - g.y
    })
end

module.move_window_upper_right = function()
    local s = screen()
    local qsp = quarter_screen_partitions
    local g = gutter()
    set_frame("Upper Right", {
        x = s.x + (s.w * qsp.x) + g.x,
        y = s.y,
        w = (s.w * (1 - qsp.x)) - g.x,
        h = (s.h * (qsp.y)) - g.y
    })
end

module.move_window_lower_left = function()
    local s = screen()
    local qsp = quarter_screen_partitions
    local g = gutter()
    set_frame("Lower Left", {
        x = s.x,
        y = s.y + (s.h * qsp.y) + g.y,
        w = (s.w * qsp.x) - g.x,
        h = (s.h * (1 - qsp.y)) - g.y
    })
end

module.move_window_lower_right = function()
    local s = screen()
    local qsp = quarter_screen_partitions
    local g = gutter()
    set_frame("Lower Right", {
        x = s.x + (s.w * qsp.x) + g.x,
        y = s.y + (s.h * qsp.y) + g.y,
        w = (s.w * (1 - qsp.x)) - g.x,
        h = (s.h * (1 - qsp.y)) - g.y
    })
end

module.send_window_prev_monitor = function()
    hs.alert.show("Prev Monitor")
    local win = hs.window.focusedWindow()
    local nextScreen = win:screen():previous()
    win:moveToScreen(nextScreen)
end

module.send_window_next_monitor = function()
    hs.alert.show("Next Monitor")
    local win = hs.window.focusedWindow()
    local nextScreen = win:screen():next()
    win:moveToScreen(nextScreen)
end

-- snapback return the window to its last position. calling snapback twice returns the window to its original position.
-- snapback holds state for each window, and will remember previous state even when focus is changed to another window.
module.snapback = function()
    local win = win()
    local id = win:id()
    local state = win:frame()
    local prev_state = module.snapback_window_state[id]
    if prev_state then
        win:setFrame(prev_state)
    end
    module.snapback_window_state[id] = state
end

module.maximize = function()
    set_frame("Full Screen", screen())
end

--- move_to_center_relative(size)
--- Method
--- Centers and resizes the window to the the fit on the given portion of the screen.
--- The argument is a size with each key being between 0.0 and 1.0.
--- Example: win:move_to_center_relative(w=0.5, h=0.5) -- window is now centered and is half the width and half the height of screen
module.move_to_center_relative = function(unit)
    local s = screen()
    set_frame("Center", {
        x = s.x + (s.w * ((1 - unit.w) / 2)),
        y = s.y + (s.h * ((1 - unit.h) / 2)),
        w = s.w * unit.w,
        h = s.h * unit.h
    })
end

--- move_to_center_absolute(size)
--- Method
--- Centers and resizes the window to the the fit on the given portion of the screen given in pixels.
--- Example: win:move_to_center_relative(w=800, h=600) -- window is now centered and is 800px wide and 600px high
module.move_to_center_absolute = function(unit)
    local s = screen()
    set_frame("Center", {
        x = (s.w - unit.w) / 2,
        y = (s.h - unit.h) / 2,
        w = unit.w,
        h = unit.h
    })
end

--- move_to_center()
module.move_to_center = function()
    local unit = win():frame()
    local s = screen()
    set_frame("Center", {
        x = (s.w - unit.w) / 2,
        y = (s.h - unit.h) / 2,
        w = unit.w,
        h = unit.h
    })
end

module.size_up = function()
    local unit = win():frame()
    set_frame("Size Up", {
        x = unit.x - (resizeing_scale / 2),
        y = unit.y - (resizeing_scale / 2),
        w = unit.w + resizeing_scale,
        h = unit.h + resizeing_scale
    })
end

module.size_down = function()
    local unit = win():frame()
    set_frame("Size Down", {
        x = unit.x + (resizeing_scale / 2),
        y = unit.y + (resizeing_scale / 2),
        w = unit.w - resizeing_scale,
        h = unit.h - resizeing_scale
    })
end

module.size_up_vertical = function()
    local unit = win():frame()
    set_frame("Size Up(vertical)", {
        x = unit.x,
        y = unit.y,
        w = unit.w,
        h = unit.h + resizeing_scale
    })
end

module.size_down_vertical = function()
    local unit = win():frame()
    set_frame("Size Down(vertical)", {
        x = unit.x,
        y = unit.y,
        w = unit.w,
        h = unit.h - resizeing_scale
    })
end

module.size_up_horizontal = function()
    local unit = win():frame()
    set_frame("Size Up(horizontal)", {
        x = unit.x,
        y = unit.y,
        w = unit.w + resizeing_scale,
        h = unit.h
    })
end

module.size_down_horizontal = function()
    local unit = win():frame()
    set_frame("Size Down(horizontal)", {
        x = unit.x,
        y = unit.y,
        w = unit.w - resizeing_scale,
        h = unit.h
    })
end

--- set_working_layout_horizontal(apps)
--- Method
--- resizes the window to the the fit on the given portion of the screen given in pixels.
--- Example: win:set_working_layout_horizontal({{app="code",r=0.5}, {app="iTerm",r=0.5}})
module.set_working_layout_horizontal = function(apps)
    local s = screen() -- window

    local location = s.x
    for i = 1, #apps do
        hs.application.launchOrFocus(apps[i].app)
        set_frame("Resize layout:" .. apps[i].app, {
            x = location,
            y = s.y,
            w = s.w * apps[i].r,
            h = s.h
        })
        location = location + win():frame().w
    end
end

module.set_working_layout_vertical = function(apps)
    local s = screen() -- window

    local location = s.y
    for i = 1, #apps do
        hs.application.launchOrFocus(apps[i].app)
        set_frame("Resize layout:" .. apps[i].app, {
            x = s.x,
            y = location,
            w = s.w,
            h = s.h * apps[i].r
        })
        location = location + win():frame().h
    end
end

module.set_working_layout = function(apps)
    local s = screen() -- window
    if s.w > s.h then 
        print("horizontal")
        module.set_working_layout_horizontal(apps)
    else 
        print("vertical")
        module.set_working_layout_vertical(apps)
    end
end

-- log app, screen location and size 
module.print_locations = function()
    local format = "%s = x:%.2f y:%.2f w:%.2f h:%.2f"
    local s = screen() -- window
    print(string.format(format, "win", s.x, s.y, s.w, s.h))
    local unit = win():frame() -- app
    print(string.format(format, "app", unit.x, unit.y, unit.w, unit.h))
end

------------------
-- Internal API --
------------------

-- module uses no animations
hs.window.animationDuration = 0
-- Initialize Snapback state
module.snapback_window_state = { }
-- return currently focused window
function win ()
    return hs.window.focusedWindow()
end
-- display title, save state and move win to unit
function set_frame(title, unit)
    print(title)
    local win = win()
    module.snapback_window_state[win:id()] = win:frame()
    return win:setFrame(unit)
end
-- screen is the available rect inside the screen edge margins
function screen()
    local screen = win():screen():frame()
    local sem = screen_edge_margins
    return {
        x = screen.x + sem.left,
        y = screen.y + sem.top,
        w = screen.w - (sem.left + sem.right),
        h = screen.h - (sem.top + sem.bottom)
    }
end
-- gutter is the adjustment required to accomidate partition
-- margins between windows
function gutter()
    local pm = partition_margins
    return {
        x = pm.x / 2,
        y = pm.y / 2
    }
end

--- hs.window:moveToScreen(screen)
--- Method
--- move window to the the given screen, keeping the relative proportion and position window to the original screen.
--- Example: win:moveToScreen(win:screen():next()) -- move window to next screen
function hs.window:moveToScreen(nextScreen)
    local currentFrame = self:frame()
    local screenFrame = self:screen():frame()
    local nextScreenFrame = nextScreen:frame()
    self:setFrame({
        x = ((((currentFrame.x - screenFrame.x) / screenFrame.w) * nextScreenFrame.w) + nextScreenFrame.x),
        y = ((((currentFrame.y - screenFrame.y) / screenFrame.h) * nextScreenFrame.h) + nextScreenFrame.y),
        h = ((currentFrame.h / screenFrame.h) * nextScreenFrame.h),
        w = ((currentFrame.w / screenFrame.w) * nextScreenFrame.w)
    })
end

return module
