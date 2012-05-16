InputController = class('PlayerInputController', Controller)

function InputController:onInit()
	self:setComponentFilters( Input, Shape )
	-- All components have the shortcut method 'listen'
	-- The call below is the same as:
	-- EventDispatcher.listen( "on_keypressed", self, self.eventKeypressed, self )
	self:listen( "on_keypressed",  self.eventKeypressed )
	self:listen( "on_keyreleased", self.eventKeyreleased )
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
	local mx, my = love.mouse.getPosition()
	local x, y = entity.transform:getXY()
	local shape = entity:getComponent( Shape )
	if shape:isPointInside( mx - x, my - y ) then
		entity.input:setMouseIsOver( true )
	else
		entity.input:setMouseIsOver( false )
	end
end