local STATES = _G.STATES
local state = require("lib.state") ---@type state
local assetloader = require("lib.assetloader") ---@type assetloader

---@class camera
---@field savePath string
local camera = {}

camera.savePath = ""

---Assign Save Path
---@param str string
function camera:setSavePath(str)
    self.savePath = str
end

---Call System Command to gphoto2 library.
function camera:capture()
    local gotErr = os.execute('gphoto2 --trigger-capture --wait-event-and-download 1s --filename "'.. self.savePath .. '/camsys/lua/DSC_0001.JPG" --force-overwrite')

    if (gotErr) then
        print("Image was not taken!")
        state:setState(STATES.IDLEVIDEO)
    else
        assetloader:loadCameraImage()
        state:setState(STATES.CAMERACAPTURE)
    end
end

return camera