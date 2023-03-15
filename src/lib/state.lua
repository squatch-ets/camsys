---@enum STATES
_G.STATES = {
    IDLEIMAGE = 1,
    IDLEVIDEO = 2,
    CAMERACAPTURE = 3,
    CAMERAWAIT = 4
}

local STATES = _G.STATES

---@class state
local state = {}

state.currentState = STATES.IDLEIMAGE

function state:setState(enum)
    self.currentState = enum
end

function state:getState()
    return self.currentState
end

return state