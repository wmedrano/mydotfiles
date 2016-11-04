-- Hacks
-- see connect_signal at bottom
-- fullscreen signal will revert fullscreen to the state of marked.
-- marking will set fullscreen to that state.

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
-- Vicious widget library
local vicious = require("vicious")
-- local treesome = require("treesome")

-- autostart

-- compositor - add some sheen and vsync
awful.util.spawn("compton --dbus")

-- emacs deamon - provide quick editing of files with `emacsclient`
awful.util.spawn("/bin/emacs --daemon")

-- redshift - reduce eyestrain
awful.util.spawn("killall redshift")
awful.util.spawn("redshift-gtk")

-- computer specific
awful.util.spawn_with_shell("bash ~/.config/startup.sh")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

function debug_msg(msg)
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Debug Message",
                     text = msg })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
                               -- Make sure we don't go into an endless error loop
                               if in_error then return end
                               in_error = true

                               naughty.notify({ preset = naughty.config.presets.critical,
                                                title = "Oops, an error happened!",
                                                text = err })
                               in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/theme/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
browser = os.getenv("BROWSER") or "chromium"
private_browser = "chromium --incognito"
editor = "emacsclient -t"
editor_cmd = "emacsclient -c"
file_browser = "thunar"
screenshot = "scrot"
play_pause = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.banshee /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause"
calculator = terminal .. " -e python"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
    {
        awful.layout.suit.tile,
        -- treesome,
	awful.layout.suit.floating,
    }

-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
    { "manual", terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                              { "open terminal", terminal }
}
                       })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox

-- Separator
sep = wibox.widget.textbox()
sep:set_text("  ")

-- Textclock widget
mytextclock = wibox.widget.textbox()
vicious.register(mytextclock,
                 vicious.widgets.date,
                 '<span>%a %b %d, %I:%M %p</span>',
                 30)

-- Create a volume widget
myvolume = wibox.widget.textbox()
vicious.register(myvolume, vicious.widgets.volume, "<span>Vol:$1 $2</span>", 2, "Master")
function mycontrols_volume(action)
    if action == "up" then
        awful.util.spawn("amixer set Master 10%+")
    elseif action == "down" then
        awful.util.spawn("amixer set Master 10%-")
    elseif action == "mute" then
        awful.util.spawn("amixer set Master toggle")
    else
        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Error in myvolume_actions() in rc.lua!",
                         text = "Unknown action" })
    end
    vicious.force({ myvolume })
end

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
    awful.button({ }, 1, awful.tag.viewonly),
    awful.button({ modkey }, 1, awful.client.movetotag),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, awful.client.toggletag),
    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
    awful.button({ }, 1, function (c)
            if c == client.focus then
                c.minimized = true
            else
                -- Without this, the following
                -- :isvisible() makes no sense
                c.minimized = false
                if not c:isvisible() then
                    awful.tag.viewonly(c:tags()[1])
                end
                -- This will also un-minimize
                -- the client, if needed
                client.focus = c
                c:raise()
            end
    end),
    awful.button({ }, 3, function ()
            if instance then
                instance:hide()
                instance = nil
            else
                instance = awful.menu.clients({
                        theme = { width = 250 }
                })
            end
    end),
    awful.button({ }, 4, function ()
            awful.client.focus.byidx(1)
            if client.focus then client.focus:raise() end
    end),
    awful.button({ }, 5, function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(
        awful.util.table.join(
            awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
            awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
            awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
            awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(sep)
    if s == 1 then
        right_layout:add(wibox.widget.systray())
    end
    right_layout:add(sep)
    right_layout:add(myvolume)
    right_layout:add(sep)
    right_layout:add(mytextclock)
    right_layout:add(sep)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
                 awful.button({ }, 3, function () mymainmenu:toggle() end),
                 awful.button({ }, 4, awful.tag.viewnext),
                 awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings

globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),

    -- XF86 Keys
    awful.key({ }, "XF86AudioLowerVolume", function() mycontrols_volume("down") end),
    awful.key({ }, "XF86AudioRaiseVolume", function() mycontrols_volume("up") end),
    awful.key({ }, "XF86AudioMute", function() mycontrols_volume("mute") end),
    awful.key({ }, "XF86AudioPlay", function() awful.util.spawn(play_pause) end),
    awful.key({ }, "XF86Calculator", function() awful.util.spawn(calculator) end),
    awful.key({ }, "Print", function() awful.util.spawn(screenshot) end),

    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
    end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.025)   end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.025)   end),
    awful.key({ modkey, "Shift"   }, "h",
        function () -- Toggle between 1 and 2 rows on the left
            awful.tag.setnmaster(3-awful.tag.getnmaster())
    end),
    awful.key({ modkey, "Shift"   }, "l",
        function () -- Toggle between 1 and 2 cols on the right
            awful.tag.setncol(3-awful.tag.getncol())
    end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey, "Control" }, "m", awful.client.restore),
    awful.key({ modkey, "Shift"   }, "space",
	function ()
	    awful.layout.inc(layouts, 1)
    end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal)   end),
    awful.key({ modkey, "Shift"   }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
        function ()
            awful.prompt.run({ prompt = "Run Lua code: " },
                mypromptbox[mouse.screen].widget,
                awful.util.eval, nil,
                awful.util.getdir("cache") .. "/history_eval")
    end),
    -- Menubar
    awful.key({ modkey }, "space", function() menubar.show() end),
    awful.key({ modkey }, "p", function() menubar.show() end),
    -- Common Applications
    awful.key({ modkey }, "c", function() awful.util.spawn(browser) end),
    awful.key({ modkey, "Shift" }, "c", function() awful.util.spawn(private_browser) end),
    awful.key({ modkey }, "e", function() awful.util.spawn(editor_cmd) end),
    awful.key({ modkey }, "z", function() awful.util.spawn("slock") end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",
	function (c)
	    awful.client.togglemarked(c)
    end),
    awful.key({ modkey,           }, "g",
	function (c)
	    -- c:redraw()
	    -- will toggle back, as marking is the only way to toggle fullscreen
	    c.fullscreen = not c.fullscreen
    end),
    awful.key({ modkey,           }, "q",      function (c) c:kill()                         end),
    awful.key({ modkey, "Shift"   }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",
        function (c)
	    floating = not awful.client.floating.get(c)
	    awful.client.floating.set(c, floating)
	    c.ontop = floating
	    awful.client.unmark(c)
        end
    ),
    awful.key({ modkey,           }, "m",
        function (c)
            c.minimized = not c.minimized
    end),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
	    floating = awful.client.floating.get(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
	    c.ontop = floating
    end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(
        globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function ()
                local screen = mouse.screen
                local tag = awful.tag.gettags(screen)[i]
                if tag then
                    awful.tag.viewonly(tag)
                end
        end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function ()
                local screen = mouse.screen
                local tag = awful.tag.gettags(screen)[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
        end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = awful.tag.gettags(client.focus.screen)[i]
                    if tag then
                        awful.client.movetotag(tag)
                    end
                end
        end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = awful.tag.gettags(client.focus.screen)[i]
                    if tag then
                        awful.client.toggletag(tag)
                    end
                end
    end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons },
    },
    { rule = { name = "Figure" },
      properties = { floating = true, ontop = true } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal(
    "manage",
    function (c, startup)
        -- Enable sloppy focus
        c:connect_signal("mouse::enter", function(c)
                             if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
                             and awful.client.focus.filter(c) then
                                 client.focus = c
                             end
        end)

        if not startup then
            -- Set the windows at the slave,
            -- i.e. put it at the end of others instead of setting it master.
            awful.client.setslave(c)

            -- Put windows in a smart way, only if they do not set an initial position.
            if not c.size_hints.user_position and not c.size_hints.program_position then
                awful.placement.no_overlap(c)
                awful.placement.no_offscreen(c)
            end
        end
end)

client.connect_signal("focus", function(c)
			  c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus",
		      function(c)
			  if awful.client.floating.get(c) then
			      c.border_color = beautiful.border_float
			  else
			      c.border_color = beautiful.border_normal
			  end
end)
client.connect_signal("marked",
		      function(c)
			  c.fullscreen = true
end)
client.connect_signal("unmarked",
		      function(c)
			  c.fullscreen = false
end)
client.connect_signal("property::fullscreen",
		      function(c)
			  fullscreen = awful.client.ismarked(c)
			  c.fullscreen = fullscreen
			  if not fullscreen then
			      c.ontop = awful.client.floating.get(c)
			  end
end)
-- }}}
