local utils = {}

function utils.weakValuesTable()
	return setmetatable( {}, { __mode = 'v' } )
end

function utils.weakKeysTable()
	return setmetatable( {}, { __mode = 'k' } )
end

function utils.weakKeysAndValuesTable()
	return setmetatable( {}, { __mode = 'kv' } )
end

return utils