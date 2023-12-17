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
	self.idleImage = love.graphics.newImage("idle_image.jpg")
end

function assetloader:loadCameraImage()
	if not (self.cameraImage == nil) then self.cameraImage:release() end
	self.cameraImage = love.graphics.newImage("/camsys/lua/DSC_0001.jpg")
end

function assetloader:loadVideoStream()
	local _, errmsg = nfs.newFile("idle_video.ogv")

	if (errmsg == 0) then
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