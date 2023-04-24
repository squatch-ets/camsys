local STATES = _G.STATES
local state = require("lib.state")
local assetloader = require("lib.assetloader")

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
        assetloader:loadCameraImage()
        state:setState(STATES.CAMERACAPTURE)
    end
end

return camera