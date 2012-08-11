MovementStateAttribute = Attribute('MovementStateAttribute')

MOVESTATE_NONE = 0
MOVESTATE_LEFT = 1
MOVESTATE_UP   = 2
MOVESTATE_RIGHT = 3
MOVESTATE_DOWN = 4

function MovementStateAttribute:onInit()
	self.state = MOVESTATE_NONE
end