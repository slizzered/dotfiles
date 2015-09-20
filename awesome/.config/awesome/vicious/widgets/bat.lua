---------------------------------------------------
-- Licensed under the GNU General Public License v2
--  * (c) 2010, Adrian C. <anrxc@sysphere.org>
---------------------------------------------------

-- {{{ Grab environment
local tonumber = tonumber
local awful=awful
local beautiful = beautiful
local naughty = naughty
local setmetatable = setmetatable
local string = { format = string.format }
local helpers = require("vicious.helpers")
local math = {
    min = math.min,
    floor = math.floor
}
-- }}}


-- Bat: provides state, charge, and remaining time for a requested battery
module("vicious.widgets.bat")


-- {{{ Battery widget type
local function worker(format, warg)
    if not warg then return end

    local battery = helpers.pathtotable("/sys/class/power_supply/"..warg)
    local battery_state = {
        ["Full\n"]        = "⏦",
        ["Unknown\n"]     = "⌁",
        ["Charged\n"]     = "⏦",
        ["Charging\n"]    = "+",
        ["Discharging\n"] = "-"
    }

    -- Check if the battery is present
    if battery.present ~= "1\n" then
        return {battery_state["Unknown\n"], 0, "∞"}
    end


    -- Get state information
    local state = battery_state[battery.status] or battery_state["Unknown\n"]

    -- Get capacity information
    if battery.charge_now then
        remaining, capacity = battery.charge_now, battery.charge_full
    elseif battery.energy_now then
        remaining, capacity = battery.energy_now, battery.energy_full
    else
        return {battery_state["Unknown\n"], 0, "∞"}
    end

    -- Calculate percentage (but work around broken BAT/ACPI implementations)
    local percent = math.min(math.floor(remaining / capacity * 100), 100)


    -- Get charge information
    if battery.current_now then
        rate = battery.current_now
    elseif battery.power_now then
        rate = battery.power_now
    else
        return {state, percent, "∞"}
    end

    -- Calculate remaining (charging or discharging) time
    local time = "∞"
    if rate ~= nil then
        if state == "+" then
            timeleft = (tonumber(capacity) - tonumber(remaining)) / tonumber(rate)
        elseif state == "-" then
            timeleft = tonumber(remaining) / tonumber(rate)
        else
            return {state, percent, time}
        end
        local hoursleft = math.floor(timeleft)
        local minutesleft = math.floor((timeleft - hoursleft) * 60 )
        time = string.format("%02d:%02d", hoursleft, minutesleft)


		if (((hoursleft == 0) and (minutesleft <= 5)) and (state == "-")) then
			awful.util.spawn("sudo pm-hibernate")
		elseif (((hoursleft == 0) and (minutesleft <= 7)) or (percent <= 7))  and (state == "-") then
			naughty.notify({ title = "↯ Beware! ↯",
						text = "System is going to hibernate in a few seconds!",
						timeout = 13,
						position = "top_right",
						fg = beautiful.fg_focus,
						bg = beautiful.bg_focus 
					})
					
		elseif	(((hoursleft == 0) and (minutesleft <= 25)) or (percent <= 40))  and (state == "-") then
			naughty.notify({ title = "↯ Beware! ↯",
						text = "Battery charge is low",
						timeout = 7,
						position = "top_right",
						fg = beautiful.fg_focus,
						bg = beautiful.bg_focus 
					})
		end
    end


    return {state, percent, time}
end
-- }}}

setmetatable(_M, { __call = function(_, ...) return worker(...) end })
