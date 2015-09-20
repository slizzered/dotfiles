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
-- widget library
local vicious = require("vicious")
-- scratchpad
local scratch = require("scratch")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
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
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/carli/.config/awesome/themes/default/theme.lua")
-- This is used later as the default terminal and editor to run.
terminal = "urxvt -pe tabbed"
editor = "gvim" or os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
-- check WM Classes with xprop | grep WM_CLASS
browser =  "Firefox" 
mail = "Thunderbird"
instant_messenger = "Pidgin"
cherrytree = "Cherrytree"
skype = "Skype"

--skyblue  = "#607B8B"
--skyblue  = "#525C65"
skyblue  = "#535d6c"
main_screen = screen.count()
CPUCount=4


-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    --awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    awful.layout.suit.floating,
    --awful.layout.suit.fair,
    awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
for s = 1, screen.count() do
	gears.wallpaper.maximized(beautiful.wallpaper, s, true)
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ "Α", "Β", "Γ", "Δ", "Ε", "Ζ", "Η", "Θ", "Ι" }, s,
    	{	layouts[1],	layouts[2],	layouts[4],	
    		layouts[1],	layouts[1],	layouts[1],	
    		layouts[1],	layouts[1],	layouts[1]	
    	}
    )
end

if screen.count() == 1 then
-- Set the IM-Tag with pre-defined Master-Window-size and enough Slave columns
awful.tag.setproperty(tags[main_screen][2], "mwfact", 0.10)
awful.tag.setproperty(tags[main_screen][2], "ncol", 3)

--Set the skype-tag with pre-defined sizes
awful.tag.setproperty(tags[main_screen][1], "mwfact", 0.14)
awful.tag.setproperty(tags[main_screen][1], "ncol", 2)
else
-- Set the IM-Tag with pre-defined Master-Window-size and enough Slave columns
awful.tag.setproperty(tags[main_screen][2], "mwfact", 0.25)
awful.tag.setproperty(tags[main_screen][2], "ncol", 3)

--Set the skype-tag with pre-defined sizes
awful.tag.setproperty(tags[main_screen][1], "mwfact", 0.33)
awful.tag.setproperty(tags[main_screen][1], "ncol", 2)
end
-- }}}

-- Set the Browser-Tag with pre-defined Master-Window-count
--awful.tag.setproperty(tags[1][3], "nmaster", 2)
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
									{ "Chromium", "chromium" },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- create dio widget
dio = wibox.widget.textbox()
vicious.register(dio, vicious.widgets.dio, '<span color="' .. skyblue .. '">Disk:🗁 ${sda total_mb} MB/s</span>', 20)
-- 
-- --Create battery widget
--batwidget = wibox.widget.textbox()
--vicious.register(batwidget, vicious.widgets.bat,'<span color="' .. skyblue .. '">↯ $1 $2%  $3h</span>', 60,'BAT0')

-- Create MPD widget
-- Initialize widget
mpdwidget = wibox.widget.textbox()
-- Register widget
vicious.register(mpdwidget, vicious.widgets.mpd,
    function (widget, args)
        if args["{state}"] == "Stop" then 
            return "♫ ◾ "
        else 	if args["{state}"] == "Pause" then
            		return "♫ ⧐ " .. args["{Artist}"]..' - '.. args["{Title}"]
    		else	
			return "♫ ▸ " .. args["{Artist}"]..' - '.. args["{Title}"]		-- ▶ ▸ ◼ ◾ 
		end
        end
    end, 20)

-- initialize widget
cputemp = {}
--for s=1, CPUCount+1 do
for s=1, 1 do
	cputemp[s] = wibox.widget.textbox()
	-- register widget
	vicious.register(cputemp[s], vicious.widgets.thermal, '<span color="' .. skyblue .. '">($1°C)</span>',20,'thermal_zone2')
	--vicious.register(cputemp[s], vicious.widgets.my_thermal, '<span color="' .. skyblue .. '">($1°C)</span>',20,{'coretemp.0','core'..s})
end

-- Create Memory Usage widget
-- Initialize widget
memwidget = wibox.widget.textbox()
-- Register widget
vicious.register(memwidget, vicious.widgets.mem, '<span color="' .. skyblue .. '">RAM: $1% ($2MB)</span>', 20)


cpuconsumption = {}
for s=1, CPUCount do
 	cpuconsumption[s] = wibox.widget.textbox()
 	vicious.register(cpuconsumption[s], vicious.widgets.cpu, '<span color="' .. skyblue .. '">$1%</span>',20,"$" .. s)
end
-- 
-- -- Create CPU Usage WidgetS
cpuwidget = {}
for s=1, CPUCount do
-- 	-- Initialize widget
	cpuwidget[s] = awful.widget.graph()
-- 	-- Graph properties
 	cpuwidget[s]:set_width(50)
 	cpuwidget[s]:set_background_color("#494B4F")
 	cpuwidget[s]:set_color("#FF5656")
-- 	cpuwidget[s]:set_gradient_colors({ "#FF5656", "#88A175", "#AECF96" })
-- 	-- Register widget
 	vicious.register(cpuwidget[s], vicious.widgets.cpu, "$" .. s,20)
end
 

-- Create a HDD Temperature widget
--hddtempwidget = widget({ type = "textbox" })
--vicious.register(hddtempwidget, vicious.widgets.hddtemp, "(${/dev/sda}°C)",31)

-- Create a GPU Temperature widget
--gpu_temp = widget({ type = "textbox" })
--vicious.register(gpu_temp, vicious.widgets.thermal_gpu, "GPU: $1°C", 19)

-- -- Create an invisible separator
smallseparator = wibox.widget.textbox()
smallseparator:set_text("  ")
bigseparator = wibox.widget.textbox()
bigseparator:set_text("      ")
-- 
-- -- Network usage widget
-- -- Initialize widget
netwidget = wibox.widget.textbox()
-- -- Register widget
-- down-arrow: ↆ
-- up-arrow: 𐌣
vicious.register(netwidget, vicious.widgets.my_net, '<span color="#8F9F7F">ↆ ${wlan0 down_kb}/${eth0 down_kb}</span> <span color="#CC9393"> 𐌣 ${wlan0 up_kb}/${eth0 up_kb}</span>', 20)

-- Create a textclock widget
mytextclock = awful.widget.textclock()

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
                                                  instance = awful.menu.clients({ width=250 })
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
    mylayoutbox[s]:buttons(awful.util.table.join(
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
	-- my own stuff starts here
	--
	-- CPU
	for count=1, CPUCount do
		left_layout:add(cpuwidget[count])
		left_layout:add(smallseparator)
	end
	for count=1, CPUCount do
		left_layout:add(cpuconsumption[count])
		left_layout:add(smallseparator)
	end
	--for count=1, CPUCount+1 do
	for count=1, 1 do
		left_layout:add(cputemp[count])
		left_layout:add(smallseparator)
	end
	--
	--memory
	left_layout:add(bigseparator)
	left_layout:add(memwidget)
	--
	--battery
	--left_layout:add(bigseparator)
	--left_layout:add(batwidget)
	--
	--disk
	left_layout:add(bigseparator)
	left_layout:add(dio)
	left_layout:add(smallseparator)
	--


    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
	-- my own stuff starts here
	--
	-- MPD
	right_layout:add(smallseparator)
	right_layout:add(mpdwidget)
	--
	-- Network
	right_layout:add(bigseparator)
	right_layout:add(netwidget)
	right_layout:add(smallseparator)
	--	
	-- the default stuff comes just now
    if s == main_screen then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mytextclock)
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
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

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
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

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
    awful.key({ modkey }, "p", function() menubar.show() end),

    -- Fn-Keys
    --awful.key({ }, "XF86AudioRaiseVolume",  function () awful.util.spawn("volume_change.sh -u 4") end),
    --awful.key({ }, "XF86AudioLowerVolume",  function () awful.util.spawn("volume_change.sh -d 4") end),
    --awful.key({ }, "XF86AudioMute",  	    function () awful.util.spawn("volume_change.sh -m") end),
    awful.key({ }, "XF86Display",  	    function () awful.util.spawn("disper --cycle-stages=-s:-S:-e:-c -C") end),
    --awful.key({ }, "XF86Launch1",  	    function () awful.util.spawn("sudo toggle_touchpad.sh") end),
    --awful.key({ }, "XF86Eject",  	    function () awful.util.spawn("DISPLAY=:0 undock.sh") end),
    awful.key({ }, "XF86Eject",  	    function () awful.util.spawn("xscreensaver-command -lock") end),
    --awful.key({ }, "XF86PowerOff", 	    function () awful.util.spawn("xrandr --output LVDS-0 --mode 1600x900 --primary --output HDMI-0 --off --output VGA-0 --off")
	--												awful.util.spawn("sudo shutdown -h now") end),
    --awful.key({ }, "XF86Launch2",  	    function () awful.util.spawn("sudo pm-hibernate") end)
	
	-- scratchpad
    --awful.key({ modkey }, "`", function () scratch.drop("urxvt -pe tabbed", "top", "center", 1, 0.25, true) end)
	awful.key({ modkey }, "`", function() scratch.pad.toggle() end),
    awful.key({ modkey }, "F9",  	    function () awful.util.spawn("mpc_toggle.sh carli") end),
    awful.key({ modkey }, "F2",  	    function () awful.util.spawn("volume_change_pulseaudio.sh -m") end),
    awful.key({ modkey }, "F3",  	    function () awful.util.spawn("volume_change_pulseaudio.sh -d 10") end),
    awful.key({ modkey }, "F4",  	    function () awful.util.spawn("volume_change_pulseaudio.sh -u 10") end),
    awful.key({ modkey }, "F5",  	    function () awful.util.spawn("monitor_change_brightness.sh down") end),
    awful.key({ modkey }, "F6",  	    function () awful.util.spawn("monitor_change_brightness.sh up") end),

	-- move focus to a different screen
    awful.key({ modkey }, "F1",  	    function () awful.screen.focus_relative( 1) end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),
	awful.key({ modkey }, "d", function (c) scratch.pad.set(c, 0.60, 1.0, true,main_screen) end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber))
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
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
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons,
		
		-- behebt das problem, dass urxvt nicht den gesamten bildschirm fuellt
		-- Robert ist ne coole hackersau, weil er die funktion gefunden hat! (jetzt schon 2x)
	             size_hints_honor = false } },

    { rule = { name = "File Operation Progress" },
      properties = { floating = true } },

	-- make mplayer appear on the left screen
    { rule = { class = "Smplayer", name = "SMPlayer" },
      properties = { tag=tags[1][5],
					 switchtotag=tags[1][5] },
	  callback = function(c) 
					awful.screen.focus(1)
				 end
	},
	
	-- Set Skype to always map on tag number 1 of the big screen
	{ rule = { class = skype },
	  properties = { tag = tags[main_screen][1] },
	  callback = awful.client.setslave
	},
	-- Set Skypes Main Window to always map on tag number 1 of screen 1.
	{ rule = { class = skype, name = "carli-eckert - Skype™" },
	  properties = { tag = function() if main_screen ~= 1 then return tags[1][1] else return tags[main_screen][1] end end },
	  callback = awful.client.setmaster
	},

    -- Set Firefox to always map on tag number 3 of screen 1.
    { rule = { class = browser },
      properties = { tag = tags[main_screen][3],
					 floating = false },
      callback =  awful.client.setslave
	},

    -- set Cherrytree to always map on tag number 4 of screen 1.
    { rule = { class = cherrytree },
      properties = { tag = tags[main_screen][4] },
      callback = awful.client.setslave 
	},

    -- Set Pidgin to always map on tag 2 of screen 1.
    { rule = { class = instant_messenger, role = "conversation" },
	  properties = { tag = tags[main_screen][2] },
	  callback = awful.client.setslave
	},
    -- Set Pidgins Main Window to always map on tag 1 of screen 1, if there are multiple monitors
    { rule = { class = instant_messenger, role = "buddy_list" },
      properties = { tag = function() if main_screen ~= 1 then return tags[1][1] else return tags[main_screen][2] end end }
	  --callback = awful.client.setmaster
	},
    
    -- Set Thunderbird to always map on tag 8 of screen 1.
    { rule = { class = mail },
      properties = { tag = tags[main_screen][8] },
      callback = awful.client.setslave 
	},

    -- Set Retroshare to always map on tag 9 of screen 1.
    { rule = { class = "Retroshare" },
      properties = { tag = tags[main_screen][9] },
      callback = awful.client.setslave }
}


-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
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

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)

-- VERALTET!!!!
-- behebt das problem, dass urxvt nicht den gesamten bildschirm fuellt
-- Robert ist ne coole hackersau, weil er die funktion gefunden hat!
-- client.connect_signal("", function(c) c.size_hints_honor = false end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


--awful.util.spawn("killall battery_warning.sh")
--awful.util.spawn("battery_warning.sh")
