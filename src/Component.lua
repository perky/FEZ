-----------------------
-- Public:
-----------------------

function Attribute( name, group, inherits )
	local attribute = Component( 'Attribute', name, inherits, group )
	return attribute
end

function Behaviour( name, group, inherits )
	local behaviour = Component( 'Behaviour', name, inherits )
	behaviour._enabled = true

	function behaviour:updateOwner( dt, owner ) end

	function behaviour:setEnabled( enabled )
		self._enabled = enabled
	end

	function behaviour:getEnabled()
		return self._enabled
	end

	return behaviour
end

-----------------------
-- Private:
-----------------------
local _typeID = 0

local function _getUniqueTypeID()
	_typeID = _typeID + 1
	return _typeID
end

function Component( kind, name, inherits )
	local component        = {}
	component._isComponent = true
	component._typeid      = _getUniqueTypeID()
	component._kind        = kind
	component._name        = name
    
    local function init(self,...)
        local new = setmetatable({}, component._mt)
        self.onInit(new,...)
        return new
    end

    local function equals( componentA, componentB )
    	return componentA._typeid == componentB._typeid
    end

    local function toString( component )
    	return ("(%s:%s)"):format( component._name, component._kind )
    end

    function component:onInit( ... ) 			end
    function component:onDestroy() 				end
    function component:onOwnerRefresh( owner ) 	end

    function component:setOwner( owner )
    	self._owner = owner
    end

    function component:getOwner()
    	return self._owner
    end

    function component:listen( eventName, callback )
    	EventDispatcher.listen( eventName, self, callback, self )
    end

    component._mt   = { __index = component, __eq == equals, __tostring = toString }
    setmetatable( component, { __call = init, __index = inherits, __eq = equals, __tostring = toString } )
    return component
end