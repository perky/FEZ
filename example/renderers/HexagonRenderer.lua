HexagonRenderer = Controller('HexagonRenderer')

function HexagonRenderer:onInit(  )
	self:setComponentFilters( Transform, ShapeHexagon, Input )
	self.input 			= ComponentCache( Input, entityManager )
	self.transform 		= ComponentCache( Transform, entityManager )
	self.shapeHexagon   = ComponentCache( ShapeHexagon, entityManager )
end

function HexagonRenderer:renderEntity( entity, ... )
	local hexagonVertices 	= self.shapeHexagon( entity ):getVertices()
	local x, y 				= self.transform( entity ):getXY()

	if self.input( entity ):getMouseIsOver() then
		love.graphics.setColor( 190, 190, 55 )
	else
		love.graphics.setColor( 190, 30, 55 )
	end

	love.graphics.push()
	love.graphics.translate( x, y )
	love.graphics.polygon( "fill", hexagonVertices )
	love.graphics.pop()
end