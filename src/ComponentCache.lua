local _path = ({...})[1]:gsub("%.ComponentCache", "")
local utils = require( _path .. '.util.utils' )

function ComponentCache( component, entityManager )
	local componentCache = {}
	componentCache.componentQuery = component
	componentCache.entityManager  = entityManager
	componentCache.cache          = utils.weakValuesTable()

	local function get( self, entity )
		if self.cache[entity] then
			return self.cache[entity]
		else
			local componentInstance = self.entityManager:getComponentFromEntity( entity, self.componentQuery )
			self.cache[entity] = componentInstance
			return componentInstance
		end
	end

	function componentCache:clear()
		self.cache = utils.weakValuesTable()
	end

	return setmetatable( componentCache, { __call = get } )
end