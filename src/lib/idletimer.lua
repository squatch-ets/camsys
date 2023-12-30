---@class idletimer
---@field MAXCOUNT number
---@field count number
local idletimer = {}
idletimer.MAXCOUNT = 15*60
idletimer.count = 0

local basetimer = 0 ---@type number

---Set counters to 0
function idletimer:reset()
   basetimer = 0
   self.count = 0
end

---Count counters using delta time.
---@param dt number
---@return number isMaxed # Represents a boolean in numarical value.
function idletimer:update(dt)
   basetimer = basetimer + dt
   self.count = math.floor(basetimer)

   if (self.count > self.MAXCOUNT) then
      basetimer = 0
      self.count = 0
      return 1
   end

   return 0
end

return idletimer