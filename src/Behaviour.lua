Behaviour = class('Behaviour', Component)

function Behaviour:initialize( ... )
	self._enabled = true
    Component.initialize(self)
end

function Behaviour:update( dt ) end

function Behaviour:getEnabled()
    return self._enabled
end

function Behaviour:enable()
    self._enabled = true
    EventDispatcher.unmuteTags( self )
end

function Behaviour:disable()
    self._enabled = false
    EventDispatcher.muteTags( self )
end