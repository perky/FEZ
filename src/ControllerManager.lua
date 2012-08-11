function ControllerManager( entityManager )
    local controllerManager = {}
    controllerManager._kind = 'ControllerManager'
    controllerManager.controllers = {}
    controllerManager.entityManager = entityManager

    function controllerManager:get( controller )
        assert( self.controllers[controller._name], "Controller "..controller._name.." does not exist.")
        return self.controllers[ controller._name ]
    end

    function controllerManager:add( controller )
        assert( self.controllers[controller._name] == nil, "Controller "..controller._name.." already added.")
        self.controllers[controller._name] = controller
    end

    function controllerManager:remove( controller )
        self.controllers[controller._name] = nil
    end

    function controllerManager:refresh()
        for k, controller in pairs(self.controllers) do
            controller:onControllersRefresh( self )
        end
    end

    return controllerManager
end

function Controller( name, inherits )
    local controller = {}
    controller._kind = 'Controller'
    controller._name = name
    controller._inherits = inherits
    controller._mt   = { __index = controller }
    controller.super = controller

    -----------------------
    -- Interface:
    -----------------------

    function controller:onUpdate( aspectEntity, ... )   end
    function controller:updateEntity( entity, ... )     end -- DEPRECATED.
    function controller:renderEntity( entity, ... )     end -- DEPRECATED.
    function controller:onInit( ... )                   end
    function controller:onDestroy()                     end
    function controller:onControllersRefresh( cm )      end

    -----------------------
    -- Initialization:
    -----------------------
    
    function controller.init(self, controllerManager, ...)
        local new = setmetatable({}, controller._mt)
        self.setup( new, controllerManager )
        self.onInit(new,...)
        return new
    end

    function controller.setup( new, controllerManager )
        controllerManager:add( new )
        new.controllerManager = controllerManager
    end

    function controller:destroy(  )
        self.controllerManager:remove( self )
        self.entities = nil
        self.filters  = nil
        self:onDestroy()
    end

    -----------------------
    -- Event Callbacks:
    -----------------------
    
    -- DEPRECATED.
    function controller:eventEntityRefresh( entity, componentTypes )
        if self:canControllEntity( entity, componentTypes ) then
            self:addEntity( entity )
        else
            self:removeEntity( entity )
        end
    end

    -- DEPRECATED.
    function controller:eventEntityDestroy( entity )
        self:removeEntity( entity )
    end

    -----------------------
    -- Methods:
    -----------------------

    function controller:setAspect( aspect )
        assert( aspect ~= nil, "Aspect is nil.")
        self.aspect = aspect
    end

    function controller:getAspect()
        return self.aspect
    end

    -- DEPRECATED.
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

    -- DEPRECATED.
    function controller:hasEntity( entity )
        for i, v in ipairs( self.entities ) do
            if v == entity then return true end
        end
        return false
    end
    
    -- DEPRECATED.
    function controller:addEntity( entity )
        if not self:hasEntity( entity ) then
            table.insert( self.entities, entity )
        end
    end

    -- DEPRECATED.
    function controller:removeEntity( entity )
        for i, v in ipairs( self.entities ) do
            if v == entity then
                table.remove( self.entities, i )
                break
            end
        end
    end

    -- DEPRECATED.
    function controller:setComponentFilters( ... )
        local components = {...}
        for i, v in ipairs( components ) do
            assert( v and v._isComponent, tostring(v).." is not a component." )
        end
        self.filters = components
    end

    -- DEPRECATED.
    function controller:addComponentFilters( ... )
        local components = {...}
        for i, v in ipairs(components) do
            assert( v and v._isComponent, tostring(v).." is not a component." )
            table.insert( self.filters, v )
        end
    end
    
    -- DEPRECATED.
    function controller:doesFilterComponent( component )
        for i, v in ipairs( self.filters ) do
            if v == component then return true end
        end
    end

    -- DEPRECATED.
    function controller:getFilteredEntities()
        return self.entities
    end

    function controller:listen( eventName, callback, tags )
        if not tags then
            tags = {self}
        elseif type(tags) == "table" then
            table.insert( tags, self )
        elseif type(tags) == "string" then
            tags = { self, tags }
        end
        EventDispatcher.listen( eventName, tags, callback, self )
    end

    -----------------------
    -- Update:
    -----------------------

    function controller:update( ... )
        if self.aspect then
            for aspectEntity in self.aspect.list() do
                self:onUpdate( aspectEntity, ... )
            end
        else
            self:onUpdate( nil, ... )
        end
    end

    -- DEPRECATED.
    function controller:render( ... )
        self:renderEntities( self.entities, ... )
    end

    -- DEPRECATED.
    function controller:renderEntities( entities, ... )
        for i, entity in ipairs( entities ) do
            self:renderEntity( entity, ... )
        end
    end

    local mt = { __call = controller.init }
    if inherits then mt.__index = inherits end
    return setmetatable( controller, mt )
end