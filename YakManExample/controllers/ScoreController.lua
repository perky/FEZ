ScoreController = Controller('ScoreController')

function ScoreController:onInit()
	EventDispatcher.listen("on_tileMovemementAspect_eat_grass", nil, self.onEatGrass, self)
	EventDispatcher.listen("on_tileMovemementAspect_eat_wheat", nil, self.onEatWheat, self)
	EventDispatcher.listen("on_tileMovemementAspect_crash_in_to_fence", nil, self.onCrashInToFence, self)
end

-----------------------
-- Depedendencies:
-----------------------

function ScoreController:onControllersRefresh( cm )
	self.gameState = entityManager:getComponentFromEntity( game, GameStateAttribute )
end

-----------------------
-- Events:
-----------------------

function ScoreController:onEatGrass( tileMovementAspect )
	self.gameState.score = self.gameState.score + 1
end

function ScoreController:onEatWheat( tileMovementAspect )
	self.gameState.score = self.gameState.score + 5
end

function ScoreController:onCrashInToFence( tileMovementAspect )
	self.gameState.score = self.gameState.score - 20
	self.gameState.life  = self.gameState.life - 1
	if self.gameState.life == 0 then
		self.gameState.gameOver = true
		EventDispatcher.send("on_game_over", nil)
	end
end

-----------------------
-- Update:
-----------------------

function ScoreController:onUpdate( aspect )
end
