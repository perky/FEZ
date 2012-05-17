package.path = package.path .. ";../?/init.lua;../?.lua"

require 'src' -- change this to whatever the lua_entity_system src resides in.
require 'attributes.Transform'
require 'attributes.Velocity'
require 'attributes.ShapeCircle'
require 'attributes.ShapeHexagon'
require 'attributes.Input'
require 'attributes.Collidable'
require 'behaviours.PlayerMovement'
require 'behaviours.ShapeCollision'
require 'controllers.InputController'
require 'controllers.PlayerCollisionController'
require 'renderers.PlayerRenderer'
require 'renderers.HexagonRenderer'
require 'renderers.HudRenderer'
require 'EntityFactory'

function love.load()
	entityManager             = EntityManager()
	controllerManager         = ControllerManager( entityManager )
	inputController           = InputController( controllerManager )
	playerCollisionController = PlayerCollisionController( controllerManager )
	playerRenderer            = PlayerRenderer( controllerManager )
	hexagonRenderer           = HexagonRenderer( controllerManager )
	hudRenderer               = HudRenderer( controllerManager )

	EntityFactory:createPlayer( entityManager, 100, 100, 10 )
	for i=1,20 do
		local x, y, l = math.random(0,700), math.random(0,600), math.random(6,24)
		EntityFactory:createHexagon( entityManager, x, y, l )
	end
end

function love.update( dt )
	entityManager:updateEntitiesBehaviours( dt )
	inputController:update( dt )
	playerCollisionController:update( dt )
end

function love.draw()
	playerRenderer:render()
	hexagonRenderer:render()
	hudRenderer:render()
end

function love.keypressed( key, unicode )
	-- The seconds argument takes a table of tags, only listeners with the same tags will reveive the event.
	-- We set the second argument to nil because we want all 'on_keypress' listeners to receive this event.
	EventDispatcher.send( "on_keypressed", nil, key, unicode )
end

function love.keyreleased( key, unicode )
	EventDispatcher.send( "on_keyreleased", nil, key, unicode )
end