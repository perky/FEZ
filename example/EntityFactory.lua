EntityFactory = {}

function EntityFactory:createPlayer( entityManager, x, y, radius )
	local player = entityManager:createEntity( "PLAYER" )
	entityManager.tagManager:addTagsToEntity( player, "Player" )
	local shapeCircle    = ShapeCircle( radius )
	local shapeCollision = ShapeCollision( shapeCircle )
	entityManager:addComponentToEntity( player, Transform( x, y ) )
	entityManager:addComponentToEntity( player, Velocity() )
	entityManager:addComponentToEntity( player, shapeCircle )
	entityManager:addComponentToEntity( player, shapeCollision )
	entityManager:addComponentToEntity( player, Input() )
	entityManager:addComponentToEntity( player, Collidable() )
	entityManager:addComponentToEntity( player, PlayerMovement() )
	-- It's important we call refresh after all components have been added.
	-- It let's the components know they can set up references to each other.
	entityManager:refreshEntity( player )

	return player
end

function EntityFactory:createHexagon( entityManager, x, y, sideLength )
	local hexagon = entityManager:createEntity( "HEXAGON" )
	entityManager.tagManager:addTagsToEntity( hexagon, "Hexagon" )
	local shapeHexagon = ShapeHexagon( sideLength )
	local shapeCollision = ShapeCollision( shapeHexagon )
	entityManager:addComponentToEntity( hexagon, Transform( x, y ) )
	entityManager:addComponentToEntity( hexagon, shapeHexagon )
	entityManager:addComponentToEntity( hexagon, shapeCollision )
	entityManager:addComponentToEntity( hexagon, Input() )
	entityManager:refreshEntity( hexagon )

	return hexagon
end