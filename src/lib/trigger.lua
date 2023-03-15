--[[
    Input Trigger from NA-M7RF
    Using GPIO04 pin on Raspberry Pi 4 Model B+
]]

local periphery = require("periphery")
local GPIO = periphery.GPIO

-- GPIO Config Information
---@type table<string, string|number|boolean|nil>
local CHIP_INFO = {
	path = "/dev/gpiochip0",
	line = 4,
	direction = "in",
	edge = "falling",
	bias = "pull_up",
	drive = "default",
	inverted = true,
	label = nil
}


---@class trigger
local trigger = {}

---Load Event Handler
function trigger:load()
    self.pin = GPIO(CHIP_INFO)
end

---OVERWRITE
function trigger.gotSignal() end

---Update Event Handler
function trigger:update()
    if (self.pin:read()) then
        self:gotSignal()
    end
end

--Close Event Handler
function trigger:close()
	self.pin:close()
end

return trigger