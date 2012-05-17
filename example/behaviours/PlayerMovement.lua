PlayerMovement = Behaviour('PlayerMovement')

function PlayerMovement:onInit()
	self:listen( "start_move_player_right", self.eventStartMovePlayerRight )
	self:listen( "start_move_player_down", 	self.eventStartMovePlayerDown )
	self:listen( "start_move_player_left", 	self.eventStartMovePlayerLeft )
	self:listen( "start_move_player_up", 	self.eventStartMovePlayerUp )

	self:listen( "end_move_player_right", 	self.eventEndMovePlayerRight )
	self:listen( "end_move_player_down", 	self.eventEndMovePlayerDown )
	self:listen( "end_move_player_left", 	self.eventEndMovePlayerLeft )
	self:listen( "end_move_player_up", 		self.eventEndMovePlayerUp )

	self.activeAngles = { n = 0 }
end

function PlayerMovement:onOwnerRefresh( owner )
	-- For quick access to other components we can create references once the owner has refreshed.
	-- We don't use ComponentCache here because we only use the owner's components in a behaviour.
	-- See InputController.lua for how ComponentCache works.
	--
	self.transform = entityManager:getComponentFromEntity( owner, Transform )
	self.velocity  = entityManager:getComponentFromEntity( owner, Velocity )
end

-----------------------
-- Event Callbacks:
-----------------------

local _right = 0
local _down  = math.rad(90)
local _left  = math.rad(180)
local _up    = math.rad(270)

function PlayerMovement:eventStartMovePlayerRight( )
	self.activeAngles.n = self.activeAngles.n + 1
	self.activeAngles[_right] = true
	self.velocity:setAngle( _right )
	self.velocity:setSpeed( 1 )
end

function PlayerMovement:eventStartMovePlayerDown( )
	self.activeAngles.n = self.activeAngles.n + 1
	self.activeAngles[_down] = true
	self.velocity:setAngle( _down )
	self.velocity:setSpeed( 1 )
end

function PlayerMovement:eventStartMovePlayerLeft( )
	self.activeAngles.n = self.activeAngles.n + 1
	self.activeAngles[_left] = true
	self.velocity:setAngle( _left )
	self.velocity:setSpeed( 1 )
end

function PlayerMovement:eventStartMovePlayerUp( )
	self.activeAngles.n = self.activeAngles.n + 1
	self.activeAngles[_up] = true
	self.velocity:setAngle( _up )
	self.velocity:setSpeed( 1 )
end

function PlayerMovement:eventEndMovePlayerRight( )
	self.activeAngles.n = self.activeAngles.n - 1
	self.activeAngles[_right] = nil
end

function PlayerMovement:eventEndMovePlayerDown( )
	self.activeAngles.n = self.activeAngles.n - 1
	self.activeAngles[_down] = nil
end

function PlayerMovement:eventEndMovePlayerLeft( )
	self.activeAngles.n = self.activeAngles.n - 1
	self.activeAngles[_left] = nil
end

function PlayerMovement:eventEndMovePlayerUp( )
	self.activeAngles.n = self.activeAngles.n - 1
	self.activeAngles[_up] = nil
end

-----------------------
-- Update:
-----------------------

function PlayerMovement:updateOwner( dt, owner )
	-- Unlike controllers which update a set of filtered entities
	-- Behaviours update thier owner, the entity that has added this behaviour.
	local angle = 0
	
	if self.activeAngles.n == 0 then
		self.velocity:setSpeed( 0 )
	elseif self.activeAngles.n == 1 then
		for k,v in pairs(self.activeAngles) do
			if k ~= "n" then
				angle = k
				break
			end
		end
	elseif self.activeAngles[_right] and self.activeAngles[_down] then
		angle = math.rad( 45 )
	elseif self.activeAngles[_down] and self.activeAngles[_left] then
		angle = math.rad( 135 )
	elseif self.activeAngles[_left] and self.activeAngles[_up] then
		angle = math.rad( 225 )
	elseif self.activeAngles[_up] and self.activeAngles[_right] then
		angle = math.rad( 315 )
	else
		angle = self.velocity:getAngle()
	end

	local speed = self.velocity:getSpeed()
	local x, y = self.transform:getXY()
	local dx = math.cos( angle ) * speed
	local dy = math.sin( angle ) * speed
	self.transform:setXY( x + dx, y + dy )
end

