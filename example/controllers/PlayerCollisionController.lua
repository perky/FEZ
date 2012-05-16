PlayerCollisionController = class('PlayerCollisionController', Controller)

function PlayerCollisionController:onInit()
	self:addComponentFilters( Collidable, ShapeCircle, Transform )  
end

function PlayerCollisionController:updateEntity( dt, entity, ... )
	local hexagonEntities = entityManager:getEntitiesWithComponents( ShapeHexagon, Transform )
	local shapeCircle = entity.shapeCircle
	local x, y        = entity.transform:getXY()

	entity.collidable:setIsColliding( false )
	entity.collidable:setCollidingEntity( nil )

	for i, hexagonEntity in ipairs( hexagonEntities ) do
		local vertices = hexagonEntity.shapeHexagon:getVertices()
		local hx, hy   = hexagonEntity.transform:getXY()
		for i=1, #vertices, 2 do
			local vx, vy = vertices[i], vertices[i+1]
			if shapeCircle:isPointInside( (vx+hx) - x, (vy+hy) - y ) then
				entity.collidable:setIsColliding( true )
				entity.collidable:setCollidingEntity( hexagonEntity )
			end
		end
	end
end