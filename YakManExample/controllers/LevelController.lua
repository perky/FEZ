LevelController = Controller('LevelController')

TILE_FARM = 1
TILE_GRASS = 11
TILE_WHEAT = 12
TILE_FENCE = {2,3,4,5,6,7,8,9,10}

function LevelController:onInit()
	EventDispatcher.listen("on_TileMovementController_interval", nil, self.onTileMovementControllerInterval, self )
end

-----------------------
-- Depedendencies:
-----------------------

function LevelController:onControllersRefresh( cm )
	self.level = entityManager:getComponentFromEntity( currentLevel, LevelAttribute )
end

-----------------------
-- Events:
-----------------------

function LevelController:onTileMovementControllerInterval( tileMovementAspect )
	if entityManager:getEntityName( tileMovementAspect.entity ) == 'YakMan' then
		local mapPosition = tileMovementAspect.MapPositionAttribute.position
		local tileIndex = self.level.leveldata.width * mapPosition.y + mapPosition.x + 1
		local tileID = self.level.tilemap[tileIndex]
		if tileID == TILE_GRASS then
			self.level.tilemap[tileIndex] = TILE_FARM
			EventDispatcher.send("on_tileMovemementAspect_eat_grass", nil, tileMovementAspect)
		elseif tileID == TILE_WHEAT then
			self.level.tilemap[tileIndex] = TILE_FARM
			EventDispatcher.send("on_tileMovemementAspect_eat_wheat", nil, tileMovementAspect)
		elseif self:isTileIDAFence( tileID ) then
			self.level.tilemap[tileIndex] = TILE_FARM
			EventDispatcher.send("on_tileMovemementAspect_crash_in_to_fence", nil, tileMovementAspect)
		end
	end
end

-----------------------
-- Helpers:
-----------------------

function LevelController:getTileIDAtCoords( x, y )
	local index = self.level.leveldata.width * y + x + 1
	return self.level.tilemap[index]
end

function LevelController:isTileIDAFence( tileID )
	for _, fenceID in ipairs(TILE_FENCE) do
		if tileID == fenceID then
			return true
		end
	end
	return false
end

-----------------------
-- Update:
-----------------------

function LevelController:onUpdate()

	local leveldata = self.level.leveldata
	local tileset   = self.level.tileset
	tileset.spriteBatch:clear()
	local x = 0
	local y = 0
	local tilewidth  = leveldata.tilewidth
	local tileheight = leveldata.tileheight
	local mapwidth   = leveldata.width
	local mapheight  = leveldata.height
	for i, tileID in ipairs( self.level.tilemap ) do
		tileset.spriteBatch:addq( tileset.quads[tileID], x * tilewidth, y * tileheight )
		x = x + 1
		if x >= mapwidth then
			x = 0
			y = y + 1
		end
	end
end
