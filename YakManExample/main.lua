package.path = package.path .. ";../?/init.lua;../?.lua"

-- In big games the require list can get pretty big,
-- I usually places these requires in an init.lua or,
-- setup a system to automatically require all files in a folder.
require "src"
vector = require "math.vector"
tween  = require "math.tween"
require "math.angles"
require "attributes.TransformAttribute"
require "attributes.AnimatingSpriteAttribute"
require "attributes.MovementStateAttribute"
require "attributes.LevelAttribute"
require "attributes.TileMovementAttribute"
require "attributes.MapPositionAttribute"
require "attributes.GameStateAttribute"
require "attributes.YakManAttribute"
require "attributes.WolfAttribute"
require "aspects.TileMovementAspect"
require "aspects.RenderableAspect"
require "aspects.WolfAspect"
require "controllers.TileMovementController"
require "controllers.YakManInputController"
require "controllers.LevelController"
require "controllers.ScoreController"
require "controllers.WolfMovementController"
require "renderers.SpriteRenderer"
require "renderers.LevelRenderer"
require "renderers.HUDRenderer"
require "EntityFactory"
require "LevelLoader"

local gameState

function love.load()
	-- Set screen resolution.
	love.graphics.setMode(1280,800)
	math.randomseed(os.time())
	-- Create instances of the EntityManager and the ControllerManager.
	entityManager     = EntityManager()
	controllerManager = ControllerManager()
	
	yakMan = createYak( 1,1 )
	game   = createGame()
	gameState = entityManager:getComponentFromEntity( game, GameStateAttribute )
	createWolf( 1, 5 )
	createWolf( 1, 5 )
	createWolf( 1, 5 )
	createWolf( 1, 5 )

	-- Create instances of our Controllers. Pass the controllerManager instance
	-- into their constructors.
	tileMovementController = TileMovementController( controllerManager )
	yakManInputController    = YakManInputController( controllerManager, yakMan )
	levelController          = LevelController( controllerManager )
	scoreController          = ScoreController( controllerManager )
	wolfMovementController   = WolfMovementController( controllerManager )
	levelRenderer            = LevelRenderer( controllerManager )
	spriteRenderer           = SpriteRenderer( controllerManager )
	hudRenderer              = HUDRenderer( controllerManager )

	currentLevel = LevelLoader:load( 'resources/levels/level1.lua' )
	-- Refresh the controllers so they can setup dependencies.
	controllerManager:refresh()
end

-----------------------
-- Game Loop:
-----------------------

function love.update( dt )
	levelController:update( dt )
		tileMovementController:update( dt )
		wolfMovementController:update( dt )
	scoreController:update( dt )
end

function love.draw()
	levelRenderer:update()
	spriteRenderer:update()
	hudRenderer:update()
end

-----------------------
-- Key Constants:
-----------------------

KEY_LEFT = 0
KEY_UP = 1
KEY_RIGHT = 2
KEY_DOWN = 3

local keyMap = {
	['left'] = KEY_LEFT,
	['up']   = KEY_UP,
	['right'] = KEY_RIGHT,
	['down'] = KEY_DOWN
}

-----------------------
-- Input:
-----------------------

function love.keypressed( key, unicode )
	local keyConstant = keyMap[key]
	if not gameState.gameOver then
		yakManInputController:onKeyPressed( keyConstant )
	end
end
