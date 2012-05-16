Component = class('Component', nil)

function Component:initialize( ... )
    self._accessor = self.class.name:sub(1,1):lower() .. self.class.name:sub(2,-1)
    self._owner = nil
    self:onInit( ... )
end

function Component:destroy()
	self._owner = nil
	self:onDestroy()
end

--------------------
-- Implementation:
-- Override these methods.
--------------------

function Component:onInit() end

function Component:onDestroy() end

function Component:onOwnerRefresh( owner ) end

-----------------------
-- Getters & Setters:
-----------------------

function Component:getAccessorName()
    return self._accessor
end

function Component:setOwner( owner )
    self._owner = owner
end

function Component:getOwner()
    return self._owner
end

-----------------------
-- Methods:
-----------------------

function Component:listen( eventName, callback, tags )
	if tags == nil then
		tags = {self}
	elseif type(tags) == "string" then
		tags = { self, tags }
	elseif type(tags) == "table" then
		table.insert( tags, self )
	end
    EventDispatcher.listen( eventName, tags, callback, self )
end

function Component:send( name, ... )
	EventDispatcher.send( name, self:getOwner(), ... )
end