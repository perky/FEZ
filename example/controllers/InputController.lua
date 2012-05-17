InputController = Controller('InputController')

function InputController:onInit()
	self:setComponentFilters( Input, ShapeCollision )
	-- All components have the shortcut method 'listen'
	-- The call below is the same as:
	-- EventDispatcher.listen( "on_keypressed", self, self.eventKeypressed, self )
	--
	self:listen( "on_keypressed",  self.eventKeypressed )
	self:listen( "on_keyreleased", self.eventKeyreleased )
	-- ComponentCache is a quick and effecient way of retrieving components from entities.
	-- For example:
	-- local transformAtrribute = self.transform( entity )
	-- Is the same as:
	-- local transformAtrribute = entityManager:getComponentFromEntity( entity, Transform )
	-- however after the first call it will cache that entity's component for later calls.
	-- You can clear the cache with:
	-- self.transform:clear()
	--
	self.transform      = ComponentCache( Transform, entityManager )
	self.input          = ComponentCache( Input, entityManager )
	self.shapeCollision = ComponentCache( ShapeCollision, entityManager )
end

-----------------------
-- Event Callbacks:
-----------------------

function InputController:eventKeypressed( key, unicode )
	if key == 'w' then
		EventDispatcher.send( "start_move_player_up" )
	elseif key == 's' then
		EventDispatcher.send( "start_move_player_down" )
	elseif key == 'a' then
		EventDispatcher.send( "start_move_player_left" )
	elseif key == 'd' then
		EventDispatcher.send( "start_move_player_right" )
	end
end

function InputController:eventKeyreleased( key, unicode )
	if key == 'w' then
		EventDispatcher.send( "end_move_player_up" )
	elseif key == 's' then
		EventDispatcher.send( "end_move_player_down" )
	elseif key == 'a' then
		EventDispatcher.send( "end_move_player_left" )
	elseif key == 'd' then
		EventDispatcher.send( "end_move_player_right" )
	end
end

-----------------------
-- Update:
-----------------------

function InputController:updateEntity( dt, entity, ... )
	local mx, my         = love.mouse.getPosition()
	local x, y           = self.transform( entity ):getXY()
	local shapeCollision = self.shapeCollision( entity )
	local input          = self.input( entity )

	if shapeCollision:isPointInside( mx - x, my - y ) then
		input:setMouseIsOver( true )
	else
		input:setMouseIsOver( false )
	end
end