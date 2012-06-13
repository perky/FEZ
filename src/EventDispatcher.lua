EventDispatcher = {}

-----------------------
-- Public Constants:
-----------------------

EventDispatcher.TAGS_ANY  = 1
EventDispatcher.TAGS_ALL  = 2
EventDispatcher.TAGS_ONLY = 3

-----------------------
-- Private Vars:
-----------------------

local _listeners = {}
local _listenersOrdered = {}
local _currentID = 0
local _listenerHasTags = {}

-----------------------
-- Private Methods:
-----------------------

local function _getUniqueID()
	_currentID = _currentID + 1
	return _currentID
end

_listenerHasTags[EventDispatcher.TAGS_ANY] = function( listener, tags )
    if listener.tags then
    	for _, listenerTag in ipairs( listener.tags ) do
    		for _, testingTag in ipairs( tags ) do
    			if listenerTag == testingTag then return true end
    		end
    	end
	end
	return false
end

_listenerHasTags[EventDispatcher.TAGS_ALL] = function( listener, tags )
	if listener.tags then
		for _, listenerTag in ipairs(listener.tags) do
			for _, testingTag in ipairs( tags ) do
				if listenerTag ~= testingTag then return false end
			end
		end

		return true
	end
end

-----------------------
-- Public Methods:
-----------------------

function EventDispatcher.listen( name, tags, callback, ... )
	assert( callback, "Callback is nil" )
	assert( type(callback) == "function", "Callback is not a function" )
	if _listeners[name] == nil then
		_listeners[name] = {}
		table.insert( _listenersOrdered, _listeners[name] )
	end
	if tags and type(tags) ~= "table" then 
	    tags = {tags}
	end
	local id = _getUniqueID()
	local listener = {
		['id'] 			= id,
		['name']		= name,
		['tags'] 		= tags,
		['callback'] 	= callback,
		['args'] 		= {...},
		['active'] 		= true
	}
	table.insert( _listeners[name], listener )
	return listener
end

function EventDispatcher.send( name, tags, ... )
	
	local args = {...}
	if tags and type(tags) ~= "table" then 
	    tags = {tags}
	end
	local listeners = _listeners[name]
	if listeners then
		for i, listener in ipairs(listeners) do
			if listener.active and (tags == nil or _listenerHasTags[EventDispatcher.TAGS_ANY]( listener, tags )) then
				listener.callback( unpack(listener.args), unpack(args) )
			end
		end
	end
end

function EventDispatcher.muteListener( listener )
	listener.active = false
end

function EventDispatcher.unmuteListener( listener )
	listener.active = true
end

function EventDispatcher.killListener( listener )
	for i, v in ipairs(_listeners[ listener.name ]) do
		if v.id == listener.id then
			table.remove( _listeners[ listener.name ], i)
			break
		end
	end
	listener = nil
end

function EventDispatcher.muteTags( tags, checkType )
    _performMethodOnTags( tags, checkType, function(listener) _muteListener(listener) end )
end

function EventDispatcher.unmuteTags( tags, checkType )
    _performMethodOnTags( tags, checkType, function(listener) _unmuteListener(listener) end )
end

function EventDispatcher.killTags( tags, checkType )
    _performMethodOnTags( tags, checkType, function(listener) _killListener(listener) end )
end

function EventDispatcher.performMethodOnTags( tags, checkType, method )
    local checkType = checkType or EventDispatcher.TAGS_ANY
	for _, listenerType in ipairs(_listenersOrdered) do
		for _, listener in ipairs(listenerType) do
			if listener.tags and _listenerHasTags[checkType]( listener, tags ) then
                method( listener )
			end
		end
	end
end