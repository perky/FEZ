GameStateAttribute = Attribute('GameStateAttribute')

function GameStateAttribute:onInit()
	self.score = 0
	self.life  = 3
	self.gameOver = false
end