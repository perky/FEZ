function ControllerManager( entityManager )
    local cm = {}
    cm._kind = 'ControllerManager'
    cm.controllers = {}
    cm.entityManager = entityManager

    function cm:getController( controller )
        assert( self.controllers[controller._name], "Controller "..controller._name.." does not exist.")
        return self.controllers[ controller._name ]
    end

    function cm:addController( controller )
        assert( self.controllers[controller._name] == nil, "Controller "..controller._name.." already added.")
        self.controllers[controller._name] = controller
    end

    function cm:removeController( controller )
        self.controllers[controller._name] = nil
    end

    return cm
end

function Controller( name, inherits )
    local controller = {}
    controller._kind = 'Controller'
    controller._name = name
    controller._mt   = { __index = inherits or controller }

    -----------------------
    -- Interface:
    -----------------------

    function controller:updateEntity( dt, entity, ... ) end
    function controller:renderEntity( entity, ... )     end
    function controller:onInit( ... )                   end
    function controller:onDestroy()                     end

    -----------------------
    -- Initialization:
    -----------------------
    
    function controller.init(self, controllerManager, ...)
        local new = setmetatable({}, controller._mt)
        self.setup( new, controllerManager )
        self.onInit(new,...)
        return new
    end

    function controller:setup( controllerManager )
        controllerManager:addController( self )
        self.controllerManager = controllerManager
        self.filters  = {}
        self.entities = {}
        EventDispatcher.listen( "on_entity_refresh", self, self.eventEntityRefresh, self )
        EventDispatcher.listen( "on_entity_destroy", self, self.eventEntityDestroy, self )
    end

    function controller:destroy(  )
        self.controllerManager:removeController( self )
        self.entities = nil
        self.filters  = nil
        self:onDestroy()
    end

    -----------------------
    -- Event Callbacks:
    -----------------------
    
    function controller:eventEntityRefresh( entity, componentTypes )
        if self:canControllEntity( entity, componentTypes ) then
            self:addEntity( entity )
        else
            self:removeEntity( entity )
        end
    end

    function controller:eventEntityDestroy( entity )
        self:removeEntity( entity )
    end

    -----------------------
    -- Methods:
    -----------------------

    function controller:canControllEntity( entity, componentTypes )
        if #self.filters > 0 then
            local unmatchedComponents = #self.filters
            for i, filterComponent in ipairs( self.filters ) do
                if componentTypes:contains( filterComponent._typeid ) then
                    unmatchedComponents = unmatchedComponents - 1
                end
            end
            return unmatchedComponents == 0
        else
            return true
        end
    end

    function controller:hasEntity( entity )
        for i, v in ipairs( self.entities ) do
            if v == entity then return true end
        end
        return false
    end
    
    function controller:addEntity( entity )
        if not self:hasEntity( entity ) then
            table.insert( self.entities, entity )
        end
    end

    function controller:removeEntity( entity )
        for i, v in ipairs( self.entities ) do
            if v == entity then
                table.remove( self.entities, i )
                break
            end
        end
    end

    function controller:setComponentFilters( ... )
        local components = {...}
        for i, v in ipairs( components ) do
            assert( v and v._isComponent, tostring(v).." is not a component." )
        end
        self.filters = components
    end

    function controller:addComponentFilters( ... )
        local components = {...}
        for i, v in ipairs(components) do
            assert( v and v._isComponent, tostring(v).." is not a component." )
            table.insert( self.filters, v )
        end
    end
    
    function controller:doesFilterComponent( component )
        for i, v in ipairs( self.filters ) do
            if v == component then return true end
        end
    end

    function controller:getFilteredEntities()
        return self.entities
    end

    function controller:listen( eventName, callback )
        EventDispatcher.listen( eventName, self, callback, self )
    end

    -----------------------
    -- Update:
    -----------------------

    function controller:update( dt, ... )
        self:updateEntities( dt, self.entities, ... )
    end

    function controller:updateEntities( dt, entities, ... )
        for i, entity in ipairs( entities ) do
            self:updateEntity( dt, entity, ... )
        end
    end

    function controller:render( ... )
        self:renderEntities( self.entities, ... )
    end

    function controller:renderEntities( entities, ... )
        for i, entity in ipairs( entities ) do
            self:renderEntity( entity, ... )
        end
    end

    return setmetatable( controller, { __call = controller.init } )
end