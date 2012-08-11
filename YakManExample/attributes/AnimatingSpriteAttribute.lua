AnimatingSpriteAttribute = Attribute('AnimatingSpriteAttribute')

function AnimatingSpriteAttribute:onInit( sprites, zDepth, x, y, angle, scaleX, scaleY, offsetX, offsetY )
	self.sprites = sprites
	self.currentFrame = 1
	self.frametime    = 0
	self.framerate    = 0.1

	self.zDepth       = zDepth or 0
	self.position     = vector( x or 0, y or 0 )
	self.lastPosition = self.position:clone()
	self.angle        = angle or 0
	self.lastAngle    = self.angle
	self.scale        = vector(scaleX or 1, scaleY or 1)
	self.lastScale    = self.scale:clone()
	self.offset       = vector(offsetX or 32, offsetY or 32)
end