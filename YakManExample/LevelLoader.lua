LevelLoader = {}

function LevelLoader:load( filepath )
	local levelLuaFile = love.filesystem.load( filepath )
	local leveldata = levelLuaFile()
	local tileset = self:loadTiles( leveldata.tilesets[1] )
	local mainLayer = leveldata.layers[1]
	local tilemap   = mainLayer.data

	local level = entityManager:createEntity('level')
	entityManager:addComponentToEntity( level, LevelAttribute( leveldata, tileset, tilemap ) )
	entityManager:refreshEntity( level )

	return level
end

function LevelLoader:loadTiles( tileset )
	local graphics = love.graphics
	local quads 	  = {}
	local numberOfTiles = (tileset.imagewidth / tileset.tilewidth) * (tileset.imageheight / tileset.tileheight)
	local image 	  = graphics.newImage( tileset.image )
	local spriteBatch = graphics.newSpriteBatch( image, 1000 )
	
	local i = 1
	for y = 0, (tileset.imageheight / tileset.tileheight)-1 do
	for x = 0, (tileset.imagewidth / tileset.tilewidth)-1 do
		quads[i] = graphics.newQuad(x * tileset.tilewidth, y * tileset.tileheight, 
			tileset.tilewidth, tileset.tileheight,
			tileset.imagewidth, tileset.imageheight
		)
		i = i + 1
	end
	end

	return {
		['data'] = tileset;
		['quads'] = quads;
		['spriteBatch'] = spriteBatch;
	}
end