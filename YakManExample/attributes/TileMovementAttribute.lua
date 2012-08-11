TileMovementAttribute = Attribute('TileMovementAttribute')

function TileMovementAttribute:onInit( rate )
	self.timer = 0
	self.rate  = rate or 1
end