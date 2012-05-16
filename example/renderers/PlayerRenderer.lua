PlayerRenderer = class('PlayerRenderer', Renderer)

function PlayerRenderer:onInit()
	-- Any entities that have all these components will be passed to
	-- the renderEntity method.
	self:setComponentFilters( Transform, ShapeCircle, Input, Collidable )
end

function PlayerRenderer:renderEntity( playerEntity, ... )
	-- There are two ways of getting a component from an entity.
	-- You can call the 'getComponent( componentClass )' method on the entity, 
	-- this will throw an error if the entity does not have the component.
	-- Or you can access it directly through a period like 'entity.componentClass'
	-- note that the first letter is lower case, the rest is camel case.
	local x, y = playerEntity:getComponent( Transform ):getXY()
	local circleRadius = playerEntity.shapeCircle:getRadius()
	local mouseIsOver = playerEntity.input:getMouseIsOver()
	local isColliding = playerEntity.collidable:getIsColliding()

	if isColliding then
		love.graphics.setColor( 255, 50, 50 )
	elseif mouseIsOver then
		love.graphics.setColor( 100, 210, 50 )
	else
		love.graphics.setColor( 200, 200, 200 )
	end
	love.graphics.circle( "fill", x, y, circleRadius, 32 )
end