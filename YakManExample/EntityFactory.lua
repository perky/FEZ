local yakManOpenMouthSprite = love.graphics.newImage('resources/art/yakManOpenMouth.png')
local yakManClosedMouthSprite = love.graphics.newImage('resources/art/yakManClosedMouth.png')
local yakManSprites = {
	yakManOpenMouthSprite,
	yakManClosedMouthSprite
}
local wolfOpenMouthSprite = love.graphics.newImage('resources/art/wolfOpenMouth.png')
local wolfClosedMouthSprite = love.graphics.newImage('resources/art/wolfClosedMouth.png')
local wolfSprites = {
	wolfOpenMouthSprite,
	wolfClosedMouthSprite
}

function createYak( x, y )
	local yak = entityManager:createEntity('YakMan')
	entityManager:addComponentToEntity( yak, MapPositionAttribute( x, y ) )
	entityManager:addComponentToEntity( yak, TransformAttribute( (x*64)+32, (y*64)+32 ) )
	entityManager:addComponentToEntity( yak, AnimatingSpriteAttribute(yakManSprites, 0, x, y) )
	entityManager:addComponentToEntity( yak, MovementStateAttribute() )
	entityManager:addComponentToEntity( yak, TileMovementAttribute(1/2) )
	entityManager:addComponentToEntity( yak, YakManAttribute )
	entityManager:refreshEntity( yak )

	return yak
end

function createWolf( x, y )
	local wolf = entityManager:createEntity('Wolf')
	entityManager:addComponentToEntity( wolf, MapPositionAttribute( x, y ) )
	entityManager:addComponentToEntity( wolf, TransformAttribute( (x*64)+32, (y*64)+32 ) )
	entityManager:addComponentToEntity( wolf, AnimatingSpriteAttribute(wolfSprites, 0, x, y) )
	entityManager:addComponentToEntity( wolf, MovementStateAttribute() )
	entityManager:addComponentToEntity( wolf, TileMovementAttribute(1/2) )
	entityManager:addComponentToEntity( wolf, WolfAttribute() )
	entityManager:refreshEntity( wolf )
	return wolf
end

function createGame()
	local game = entityManager:createEntity('Game')
	entityManager:addComponentToEntity( game, GameStateAttribute() )
	entityManager:refreshEntity( game )
	return game
end