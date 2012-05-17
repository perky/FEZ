PlayerRenderer = Controller('PlayerRenderer')

function PlayerRenderer:onInit()
	-- Any entities that have all these components will be passed to
	-- the renderEntity method.
	self:setComponentFilters( Transform, ShapeCircle, Input, Collidable )

	self.shapeCircle 	= ComponentCache( ShapeCircle, entityManager )
	self.collidable 	= ComponentCache( Collidable, entityManager )
	self.transform 		= ComponentCache( Transform, entityManager )
	self.input   		= ComponentCache( Input, entityManager )
end

function PlayerRenderer:renderEntity( playerEntity, ... )

	local x, y = self.transform( playerEntity ):getXY()
	local circleRadius = self.shapeCircle( playerEntity ):getRadius()
	local mouseIsOver = self.input( playerEntity ):getMouseIsOver()
	local isColliding = self.collidable( playerEntity ):getIsColliding()
	
	if isColliding then
		love.graphics.setColor( 255, 50, 50 )
	elseif mouseIsOver then
		love.graphics.setColor( 100, 210, 50 )
	else
		love.graphics.setColor( 200, 200, 200 )
	end
	love.graphics.circle( "fill", x, y, circleRadius, 32 )
end