local nfs = require("lib.nativefs")

---@class assetloader
---@field imageMode boolean
---@field videoIdleStream love.VideoStream?
---@field videoIdle love.Video?
---@field idleImage love.Image?
local assetloader = {}

assetloader.imageMode = false
assetloader.videoIdleStream = nil
assetloader.videoIdle = nil
assetloader.idleImage = nil

---Scale Drawable Object to Cavnas Size
---@param drawable love.Video|love.Image
---@param canvas love.Canvas
---@return unknown
---@return unknown
function assetloader.scaleAsset(drawable, canvas)
	local iw, ih = drawable:getDimensions()
	local canvasW, canvasH = canvas:getDimensions()

	return canvasW/iw, canvasH/ih
end

---Create VideoIdle if not exists.
function assetloader:checkIdleVideo()
    if not (self.videoIdle) then self.videoIdle = love.graphics.newVideo(self.videoIdleStream) end
end

---Check if VideoStream is playing.
---@return boolean
function assetloader:checkVideoPlayback()
	return self.videoIdleStream:isPlaying()
end

---Stop VideoStream Playback
function assetloader:stopVideoPlayback()
	self.videoIdleStream:pause()
	self.videoIdleStream:rewind()
end

---Create the IdleImage.
function assetloader:loadIdleImage()
	self.idleImage = love.graphics.newImage("idle_image.jpg")
end

---Remove CameraImage from memory and load new CameraImage.
function assetloader:loadCameraImage()
	if not (self.cameraImage == nil) then self.cameraImage:release() end
	self.cameraImage = love.graphics.newImage("/camsys/lua/DSC_0001.jpg")
end

---Load the VideoStream from file directory.
function assetloader:loadVideoStream()
	local _, errmsg = nfs.newFile("idle_video.ogv")

	if (errmsg == 0) then
		self.videoIdleStream = love.video.newVideoStream("idle_video.ogv")
	else
		self.imageMode = true
	end
end

---Loop VideoStream
function assetloader:updateVideo()
	self:checkIdleVideo()
	if (self.videoIdleStream:tell() >= 19) then self.videoIdleStream:seek(0) end
end

return assetloader