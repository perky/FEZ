YakManInputController = Controller('YakManInputController')

function YakManInputController:onInit( yak )
	self.yak = yak
	self.yakMovementState = entityManager:getComponentFromEntity( yak, MovementStateAttribute )
end

function YakManInputController:onUpdate(  )
end

function YakManInputController:onKeyPressed( key )
	local movementState = self.yakMovementState
	if key == KEY_LEFT then
		movementState.state = MOVESTATE_LEFT
	elseif key == KEY_UP then
		movementState.state = MOVESTATE_UP
	elseif key == KEY_RIGHT then
		movementState.state = MOVESTATE_RIGHT
	elseif key == KEY_DOWN then
		movementState.state = MOVESTATE_DOWN
	end
end