local STATES = _G.STATES
local state = require("lib.state")

---@class camera
local camera = {}

camera.savePath = ""

function camera:setSavePath(str)
    self.savePath = str
end

function camera:capture()
    local gotErr = os.execute('gphoto2 --trigger-capture --wait-event-and-download 1s --filename "'.. self.savePath .. '/camsys/lua/DSC_0001.JPG" --force-overwrite')

    if (gotErr) then
        print("Image was not taken!")
        state:setState(STATES.IDLEVIDEO)
    else
        state:setState(STATES.CAMERAWAIT)
    end
end

return camera