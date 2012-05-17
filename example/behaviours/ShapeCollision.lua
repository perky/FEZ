ShapeCollision = Behaviour('ShapeCollision')

function ShapeCollision:onInit( shape )
	if shape then
		self:setShape( shape )
	end
end

function ShapeCollision:onDestroy() end
function ShapeCollision:onOwnerRefresh( owner ) end
function ShapeCollision:updateOwner( dt, owner ) end

function ShapeCollision:isPointInside( x, y )
	assert( self.shape, "ShapeCollision has not set a shape to check.")
	return self.shape:isPointInside( x, y )
end

function ShapeCollision:setShape( shape )
	-- Lua does not have interfaces, but we can check if an attribute has implemented a method easily.
	assert( shape and shape.isPointInside, "Component "..tostring(shape).." is not a shape.")
	self.shape = shape
end

function ShapeCollision:getShape()
	return self.shape
end