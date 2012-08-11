LevelRenderer = Controller('LevelRenderer')

function LevelRenderer:onInit()
end

-----------------------
-- Depedendencies:
-----------------------

function LevelRenderer:onControllersRefresh( cm )
	self.level = entityManager:getComponentFromEntity( currentLevel, LevelAttribute )
end

-----------------------
-- Update:
-----------------------

function LevelRenderer:onUpdate()
	love.graphics.draw( self.level.tileset.spriteBatch, 0, 0 )
end
