LevelAttribute = Attribute('LevelAttribute')

function LevelAttribute:onInit( leveldata, tileset, tilemap )
	self.leveldata = leveldata
	self.tileset = tileset
	self.tilemap = tilemap
end