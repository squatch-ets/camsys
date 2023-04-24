---@class idletimer
local idletimer = {}
idletimer.MAXCOUNT = 15*60
idletimer.count = 0
local basetimer = 0

function idletimer:reset()
   basetimer = 0
   self.count = 0
end

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