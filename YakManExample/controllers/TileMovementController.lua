TileMovementController = Controller('TileMovementController')

function TileMovementController:onInit()
	self:setAspect( TileMovementAspect )
	EventDispatcher.listen("on_tileMovemementAspect_crash_in_to_fence", nil, self.onCrashInToFence, self)
	EventDispatcher.listen("on_game_over", nil, self.onGameOver, self)
end

-----------------------
-- Depedendencies:
-----------------------

function TileMovementController:onControllersRefresh( cm )
end

-----------------------
-- Events:
-----------------------

function TileMovementController:onCrashInToFence( tileMovementAspect )
	tileMovementAspect.MovementStateAttribute.state = MOVESTATE_NONE
end

function TileMovementController:onGameOver()
	for tileMovementAspect in TileMovementAspect.list() do
		tileMovementAspect.MovementStateAttribute.state = MOVESTATE_NONE
	end
end

-----------------------
-- Update:
-----------------------

function TileMovementController:onUpdate( aspect, dt )
	local tileMovementAttribute = aspect.TileMovementAttribute
	tileMovementAttribute.timer = tileMovementAttribute.timer + dt
	if tileMovementAttribute.timer >= tileMovementAttribute.rate then
		tileMovementAttribute.timer = 0
		self:onUpdateInterval( aspect )
		EventDispatcher.send("on_TileMovementController_interval", nil, aspect )
	end
end

function TileMovementController:onUpdateInterval( aspect )
	local transform = aspect.TransformAttribute
	local position  = transform.position
	local mapPosition = aspect.MapPositionAttribute.position
	local movementState = aspect.MovementStateAttribute.state
	local speed = 50
	local tileSize = 64

	if movementState == MOVESTATE_LEFT then
		mapPosition.x = mapPosition.x - 1
		position.x = position.x - tileSize
		transform.scale.y = -1
		transform.angle = ANGLE_LEFT
	elseif movementState == MOVESTATE_UP then
		mapPosition.y = mapPosition.y - 1
		position.y = position.y - tileSize
		transform.scale.y = -1
		transform.angle = ANGLE_UP
	elseif movementState == MOVESTATE_RIGHT then
		mapPosition.x = mapPosition.x + 1
		position.x = position.x + tileSize
		transform.scale.y = 1
		transform.angle = ANGLE_RIGHT
	elseif movementState == MOVESTATE_DOWN then
		mapPosition.y = mapPosition.y + 1
		position.y = position.y + tileSize
		transform.scale.y = 1
		transform.angle = ANGLE_DOWN
	end
end