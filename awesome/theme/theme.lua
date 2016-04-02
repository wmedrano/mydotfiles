---------------------------
-- Default awesome theme --
---------------------------

theme = {}
theme_dir = "~/.config/awesome/theme"

theme.font          = "Ubuntu Mono 10"

theme.bg_normal     = "#222222"
theme.bg_focus      = "#535D5C"
theme.bg_urgent     = "#FF0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#C0C0C0"
theme.fg_focus      = "#FFFFFF"
theme.fg_urgent     = "#FFFFFF"
theme.fg_minimize   = "#FFFFFF"

theme.border_width  = 2
theme.border_normal = "#FF0000"
theme.border_focus  = "#00FF00"
theme.border_float  = "#0000FF"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Display the taglist squares
theme.taglist_squares_sel   = theme_dir .. "/squares/square_sel.png"
theme.taglist_squares_unsel = theme_dir .. "/squares/square_unsel.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = theme_dir .. "/icons/submenu.png"
theme.menu_height = 16
theme.menu_width  = 100

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = theme_dir .. "/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = theme_dir .. "/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = theme_dir .. "/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = theme_dir .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = theme_dir .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = theme_dir .. "/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = theme_dir .. "/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = theme_dir .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = theme_dir .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = theme_dir .. "/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = theme_dir .. "/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = theme_dir .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = theme_dir .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = theme_dir .. "/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = theme_dir .. "/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = theme_dir .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = theme_dir .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = theme_dir .. "/titlebar/maximized_focus_active.png"

theme.wallpaper = theme_dir .. "/background.jpg"

-- You can use your own layout icons like this:
theme.layout_floating  = theme_dir .. "/layouts/floating.png"
theme.layout_tilebottom = theme_dir .. "/layouts/tilebottom.png"
theme.layout_tileleft   = theme_dir .. "/layouts/tileleft.png"
theme.layout_tile = theme_dir .. "/layouts/tile.png"
theme.layout_tiletop = theme_dir .. "/layouts/tiletop.png"

theme.awesome_icon = theme_dir .. "/icons/awesome-icon.png"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
