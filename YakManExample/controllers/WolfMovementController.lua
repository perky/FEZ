WolfMovementController = Controller('WolfMovementController')

function WolfMovementController:onInit()
	self:setAspect( WolfAspect )
	EventDispatcher.listen("on_TileMovementController_interval", nil, self.onTileMovementControllerInterval, self)
end

-----------------------
-- Depedendencies:
-----------------------

function WolfMovementController:onControllersRefresh( cm )
	self.levelController = cm:get( LevelController )
	self.yakManMapPosition = entityManager:getComponentFromEntity( yakMan, MapPositionAttribute ).position
	self.gameState = entityManager:getComponentFromEntity( game, GameStateAttribute )
end

-----------------------
-- Events:
-----------------------

function WolfMovementController:onTileMovementControllerInterval( tileMovementAspect )
	if entityManager:getEntityName( tileMovementAspect.entity ) == "Wolf" then
		self:randomizeDirection( tileMovementAspect )
	end
end

-----------------------
-- Update:
-----------------------

function WolfMovementController:onUpdate( wolfAspect )
	local wolfMapPosition = wolfAspect.MapPositionAttribute.position
	if wolfMapPosition.x == self.yakManMapPosition.x and wolfMapPosition.y == self.yakManMapPosition.y then
		wolfAspect.MovementStateAttribute.state = MOVESTATE_NONE
		self.gameState.gameOver = true
		EventDispatcher.send("on_game_over")
	end
end

function WolfMovementController:randomizeDirection( tileMovementAspect )
	local mapPosition = tileMovementAspect.MapPositionAttribute.position
	local moveState   = tileMovementAspect.MovementStateAttribute.state
	local availableDirections = self:getAvailableDirections( mapPosition, moveState )
	if #availableDirections == 1 then
		tileMovementAspect.MovementStateAttribute.state = availableDirections[1]
	elseif #availableDirections > 1 then
		tileMovementAspect.MovementStateAttribute.state = availableDirections[ math.random(1, #availableDirections) ]
	else
		tileMovementAspect.MovementStateAttribute.state = MOVESTATE_NONE
	end
end

function WolfMovementController:getAvailableDirections( mapPosition, moveState )
	local leftTileID = self.levelController:getTileIDAtCoords( mapPosition.x - 1, mapPosition.y )
	local rightTileID = self.levelController:getTileIDAtCoords( mapPosition.x + 1, mapPosition.y )
	local upTileID = self.levelController:getTileIDAtCoords( mapPosition.x, mapPosition.y - 1 )
	local downTileID = self.levelController:getTileIDAtCoords( mapPosition.x, mapPosition.y + 1 )

	local availableDirections = {}
	if not self.levelController:isTileIDAFence( leftTileID ) and moveState ~= MOVESTATE_RIGHT then
		table.insert( availableDirections, MOVESTATE_LEFT )
	end
	if not self.levelController:isTileIDAFence( rightTileID ) and moveState ~= MOVESTATE_LEFT then
		table.insert( availableDirections, MOVESTATE_RIGHT )
	end
	if not self.levelController:isTileIDAFence( upTileID ) and moveState ~= MOVESTATE_DOWN then
		table.insert( availableDirections, MOVESTATE_UP )
	end
	if not self.levelController:isTileIDAFence( downTileID ) and moveState ~= MOVESTATE_UP then
		table.insert( availableDirections, MOVESTATE_DOWN )
	end

	return availableDirections
end