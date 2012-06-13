local bag = {}
bag.mt = { __index = bag }

function bag.new( weak )
	local mt = { __index = bag }
	if weak then
		mt.__mode = weak
	end
	local newbag = setmetatable( {}, mt )
	return newbag
end

function bag:set( e, v )
	self[e] = v
end

function bag:remove( e )
	self[e] = nil
end

function bag:get( e )
	return self[e]
end

function bag:contains( e )
	return self[e] ~= nil
end

function bag:hasType( component )
	return self[component:type()] ~= nil
end

function bag:getType( component )
	return self[component:type()]
end

function bag:valuesToList()
	local list = {}
	for k,v in pairs(self) do
		list[#list+1] = v
	end
	return list
end

function bag:keysToList()
	local list = {}
	for k,v in pairs(self) do
		list[#list+1] = k
	end
	return list
end

return bag
