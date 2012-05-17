PlayerCollisionController = Controller('PlayerCollisionController')

function PlayerCollisionController:onInit()
	self:addComponentFilters( Collidable, ShapeCircle, Transform )
	self.shapeCircle 	= ComponentCache( ShapeCircle, entityManager )
	self.collidable 	= ComponentCache( Collidable, entityManager )
	self.transform 		= ComponentCache( Transform, entityManager )
	self.shapeHexagon   = ComponentCache( ShapeHexagon, entityManager )
end

function PlayerCollisionController:updateEntity( dt, entity, ... )
	local hexagonEntities = entityManager.tagManager:getEntitiesWithTag( "Hexagon" )
	local shapeCircle = self.shapeCircle( entity )
	local x, y        = self.transform( entity ):getXY()

	self.collidable( entity ):setIsColliding( false )
	self.collidable( entity ):setCollidingEntity( nil )

	for i, hexagonEntity in ipairs( hexagonEntities ) do
		local vertices = self.shapeHexagon( hexagonEntity ):getVertices()
		local hx, hy   = self.transform( hexagonEntity ):getXY()
		for i=1, #vertices, 2 do
			local vx, vy = vertices[i], vertices[i+1]
			if shapeCircle:isPointInside( (vx+hx) - x, (vy+hy) - y ) then
				self.collidable( entity ):setIsColliding( true )
				self.collidable( entity ):setCollidingEntity( hexagonEntity )
			end
		end
	end
end