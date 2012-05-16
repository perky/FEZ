EntityFactory = {}

function EntityFactory:createPlayer( entityManager, x, y, radius )
	local player = entityManager:createEntity()
	player:addComponent( Transform( x, y ) )
	player:addComponent( Velocity() )
	player:addComponent( ShapeCircle( radius ) )
	player:addComponent( Input() )
	player:addComponent( Collidable() )
	player:addComponent( PlayerMovement() )
	-- It's important we call refresh after all components have been added.
	-- It let's the components know they can set up references to each other.
	player:refresh()

	return player
end

function EntityFactory:createHexagon( entityManager, x, y, sideLength )
	local hexagon = entityManager:createEntity()
	hexagon:addComponent( Transform( x, y ) )
	hexagon:addComponent( ShapeHexagon( sideLength ) )
	hexagon:addComponent( Input() )
	hexagon:refresh()

	return hexagon
end