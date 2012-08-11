HUDRenderer = Controller('HUDRenderer')

function HUDRenderer:onInit()
end

-----------------------
-- Depedendencies:
-----------------------

function HUDRenderer:onControllersRefresh( cm )
	self.gameState = entityManager:getComponentFromEntity( game, GameStateAttribute )
end

-----------------------
-- Update:
-----------------------

function HUDRenderer:onUpdate( aspect )
	local hudText
	if self.gameState.gameOver then
		hudText = "GAME OVER!"
	else
		hudText = string.format("Score: %i Lives: %i", self.gameState.score, self.gameState.life)
	end
	love.graphics.print( hudText, 10, 10 )
end
