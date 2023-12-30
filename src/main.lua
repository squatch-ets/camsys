--[[
	Camsys script for linux systems using love2d framework.

	DEPENDENCIES:
	- gphoto2: install on your linux environment using apt-get
	- lua-periphery: install on your linux environment using luarocks
	- nativefs: local, import from lib.nativefs

    NOTES:
    - This script assumes you are using a linux environment.

	Copyright 2023 brandon.burnette@squatchets.com

	Permission is hereby granted, free of charge, to any person obtaining a copy of
	this software and associated documentation files (the "Software"), to deal in
	the Software without restriction, including without limitation the rights to
	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
	of the Software, and to permit persons to whom the Software is furnished to do
	so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
]]

-- REQUIREMENTS
local state = require("lib.state") ---@type state
local trigger = require("lib.trigger") ---@type trigger
local camera = require("lib.camera") ---@type camera
local nativefs = require("lib.nativefs")
local assetloader = require("lib.assetloader") ---@type assetloader
local idletimer = require("lib.idletimer") ---@type idletimer
local STATES = _G.STATES

-- SCREEN MODE INFO
local screenWidth, screenHeight, desktopFlags = love.window.getMode()
local screenCanvas ---@type love.Canvas
local idleCapture = 0 ---@type number

---Similar to sleep
local function wait(num)
	local ntime = os.time() + num
	repeat until os.time() > ntime
end

---Called ONCE at program startup.
function love.load()
	if not (desktopFlags.fullscreen) then love.window.setMode(screenWidth, screenHeight, { fullscreen = true }) end

	love.mouse.setVisible(false)
	trigger:load()
	---@diagnostic disable-next-line:duplicate-set-field
	trigger.gotSignal = function()
		wait(10)
		camera:capture()
	end
	camera:setSavePath(nativefs.getWorkingDirectory())
	assetloader:loadIdleImage()
	assetloader:loadCameraImage()
	assetloader:loadVideoStream()
	state:setState(STATES.IDLEVIDEO)
	screenCanvas = love.graphics.newCanvas(screenWidth, screenHeight)
end

-- Called every frame before rendering to screen
function love.update(dt)
	if (assetloader.imageMode) then state:setState(STATES.IDLEIMAGE) end

	--Idle Image and Idle Video State
	if (state:getState() == STATES.IDLEVIDEO or state:getState() == STATES.IDLEIMAGE) then
		trigger:update()
		idleCapture = idletimer:update(dt)

		--Idle Video State (only ran if imageMode is false)
	elseif (state:getState() == STATES.IDLEVIDEO) then
		assetloader:updateVideo()
		idleCapture = idletimer:update(dt)

		--Camera Wait State
	elseif (state:getState() == STATES.CAMERAWAIT) then
		wait(20) -- seconds
		idleCapture = 0
		idletimer:reset()
		state:setState(STATES.IDLEVIDEO)
	end

	--Keep camera from going into standby
	if (idleCapture == 1) then trigger:gotSignal() end
end

--Called every frame after update()
function love.draw()
	local screenW, screenH = love.graphics.getDimensions()
	local canvasW, canvasH = screenCanvas:getDimensions()

	love.graphics.setCanvas(screenCanvas)

	-- IDLE IMAGE STATE
	if (state:getState() == STATES.IDLEIMAGE) then
		local sx, sy = assetloader.scaleAsset(assetloader.idleImage, screenCanvas)
		love.graphics.draw(assetloader.idleImage, 0, 0, 0, sx, sy)

		-- IDLE VIDEO STATE
	elseif (state:getState() == STATES.IDLEVIDEO) then
		assetloader:checkIdleVideo()

		if not (assetloader:checkVideoPlayback()) then assetloader.videoIdle:play() end

		local sx, sy = assetloader.scaleAsset(assetloader.videoIdle, screenCanvas)
		love.graphics.draw(assetloader.videoIdle, 0, 0, 0, sx, sy)

		-- CAMERA CAPTURE STATE
	elseif (state:getState() == STATES.CAMERACAPTURE) then
		if (assetloader:checkVideoPlayback()) then assetloader:stopVideoPlayback() end

		local sx, sy = assetloader.scaleAsset(assetloader.cameraImage, screenCanvas)
		love.graphics.draw(assetloader.cameraImage, 0, 0, 0, sx, sy)

		if not (state:getState() == STATES.CAMERAWAIT) then state:setState(STATES.CAMERAWAIT) end
	end

	love.graphics.setCanvas()
	local scale = math.min(screenW / canvasW, screenH / canvasH)

	love.graphics.push()
	love.graphics.translate(math.floor((screenW - canvasW * scale) / 2), math.floor((screenH - canvasH * scale) / 2))
	love.graphics.scale(scale, scale)
	love.graphics.draw(screenCanvas)
	love.graphics.pop()
end

-- Handles Keyboard Events
function love.keyreleased(key)
	-- Pause Key Closes the program
	if (key == "pause") then
		trigger:close()
		love.event.quit()

		-- Spacebar Forces the Camera Trigger State
	elseif (key == "space") then
		trigger:gotSignal()
	end
end
