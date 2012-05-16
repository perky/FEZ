HexagonRenderer = class('HexagonRenderer', Renderer)

function HexagonRenderer:onInit(  )
	self:setComponentFilters( Transform, ShapeHexagon, Input )
end

function HexagonRenderer:renderEntity( entity, ... )
	local hexagonVertices 	= entity.shapeHexagon:getVertices()
	local x, y 				= entity.transform:getXY()

	if entity.input:getMouseIsOver() then
		love.graphics.setColor( 190, 190, 55 )
	else
		love.graphics.setColor( 190, 30, 55 )
	end

	love.graphics.push()
	love.graphics.translate( x, y )
	love.graphics.polygon( "fill", hexagonVertices )
	love.graphics.pop()
end