---@enum STATES
_G.STATES = {
    IDLEIMAGE = 1,
    IDLEVIDEO = 2,
    CAMERACAPTURE = 3,
    CAMERAWAIT = 4
}

local STATES = _G.STATES

---@class state
---@field currentState STATES
local state = {}

state.currentState = STATES.IDLEIMAGE

---Set Current State
---@param enum STATES
function state:setState(enum)
    self.currentState = enum
end

---Return currentState
---@return STATES
function state:getState()
    return self.currentState
end

return state