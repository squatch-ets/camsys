local nfs = require("lib.nativefs")

---@class assetloader
local assetloader = {}

assetloader.imageMode = false
assetloader.videoIdleStream = nil
assetloader.videoIdle = nil
assetloader.idleImage = nil

function assetloader.scaleAsset(drawable, canvas)
	local iw, ih = drawable:getDimensions()
	local canvasW, canvasH = canvas:getDimensions()

	return canvasW/iw, canvasH/ih
end

function assetloader:checkIdleVideo()
    if not (self.videoIdle) then self.videoIdle = love.graphics.newVideo(self.videoIdleStream) end
end

function assetloader:checkVideoPlayback()
	return self.videoIdleStream:isPlaying()
end

function assetloader:stopVideoPlayback()
	self.videoIdleStream:pause()
	self.videoIdleStream:rewind()
end

function assetloader:loadIdleImage()
	if (nfs.newFile("idle_image.jpg")) then
		self.idleImage = love.graphics.newImage("idle_image.jpg")
	end
end

function assetloader:loadCameraImage()
	self.cameraImage = love.graphics.newImage(nfs.getWorkingDirectory().."/camsys/lua/DSC_0001.jpg")
end

function assetloader:loadVideoStream()
	if (nfs.newFile("idle_video.ogv")) then
		self.videoIdleStream = love.video.newVideoStream("idle_video.ogv")
	else
		self.imageMode = true
	end
end

function assetloader:updateVideo()
	self:checkIdleVideo()
	if (self.videoIdleStream:tell() >= 19) then self.videoIdleStream:seek(0) end
end

return assetloader