---------------------------------------------------
-- Licensed under the GNU General Public License v2
--  * (c) 2011, Carlchristian Eckert
---------------------------------------------------

-- {{{ Grab environment
local type = type
local tonumber = tonumber
local os = { execute = os.execute }
local io = { popen = io.popen }
local setmetatable = setmetatable
local string = { match = string.match }
local helpers = require("vicious.helpers")
-- }}}


-- Thermal GPU: provides temperature levels of Nvidia-Settings GPU-Coretemp
module("vicious.widgets.thermal_gpu")


-- {{{ Thermal widget type
local function worker(format)
	local f = io.popen("nvidia-smi -q -d TEMPERATURE | grep Gpu")
	local line = f:read("*l")
	local gpu_temp = tonumber(string.match(line, "[%d]+"))
	f:close()
	return {gpu_temp} 
end
-- }}}

setmetatable(_M, { __call = function(_, ...) return worker(...) end })
