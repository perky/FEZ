MapPositionAttribute = Attribute('MapPositionAttribute')

function MapPositionAttribute:onInit(x,y)
	self.position = vector(x or 1, y or 1)
end