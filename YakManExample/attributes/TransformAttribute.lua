TransformAttribute = Attribute('TransformAttribute')

function TransformAttribute:onInit( x, y, scale, angle )
	self.position = vector( x or 0, y or 0 )
	self.scale = scale or vector(1,1)
	self.angle = angle or 0
end