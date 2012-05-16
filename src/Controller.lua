Controller = class('Controller', Component)
Controller.controllers = {}

-----------------------
-- Class Methods:
-----------------------

function Controller.get( controllerClass )
    return Controller.controllers[ controllerClass ]
end

-----------------------
-- Instance Methods:
-----------------------

function Controller:initialize( ... )
    assert( Controller.controllers[ self.class ] == nil, "You can only have one instance of a controller." )
    
    self.filters = {}
    self.entities = {}
    
    Controller.controllers[ self.class ] = self
    
    EventDispatcher.listen( "on_entity_add_component", self, self.eventEntityAddComponent, self )
    EventDispatcher.listen( "on_entity_remove_component", self, self.eventEntityRemoveComponent, self )
    Component.initialize(self)
end

function Controller:destroy()
    Component.destroy(self)
    self.filters = nil
    self.entities = nil
    Controller.controllers[ self.class ] = nil
    self:onDestroy()
end

-----------------------
-- Callbacks:
-----------------------

function Controller:eventEntityAddComponent( entity, component ) 
    if #self.filters > 0 and self:entityHasRequiredComponents( entity ) and not self:hasEntity( entity ) then
        self:addEntity( entity )
    end
end

function Controller:eventEntityRemoveComponent( entity, component )
    if #self.filters > 0 and self:doesFilterComponent( component.class ) then
        self:removeEntity( entity )
    end
end

-----------------------
-- Methods:
-----------------------

function Controller:setComponentFilters( ... )
    local components = {...}
    for i, v in ipairs(components) do
        assert( subclassOf( Component, v ), "Can only filter component classes" )
    end
    self.filters = components
end

function Controller:addComponentFilters( ... )
    local components = {...}
    for i, v in ipairs(components) do
        assert( subclassOf( Component, v ), "Can only filter component classes" )
        table.insert( self.filters, v )
    end
end

function Controller:entityHasRequiredComponents( entity )
    local unmatchedComponents = #self.filters
    for i, component in ipairs(self.filters) do
        if entity:hasComponent( component ) then
            unmatchedComponents = unmatchedComponents - 1
        end
    end
    
    return unmatchedComponents == 0
end

function Controller:doesFilterComponent( component )
    for i, v in ipairs(self.filters) do
        if v == component then return true end
    end
end

function Controller:addEntity( entity )
    table.insert( self.entities, entity )
end

function Controller:removeEntity( entity )
    for i, v in ipairs(self.entity) do
        if v == entity then return table.remove( self.entities, i ) end
    end
    return false
end

function Controller:hasEntity( entity )
    for i, v in ipairs(self.entities) do
        if v == entity then return true end
    end
end

function Controller:getFilteredEntities()
    return self.entities
end

-----------------------
-- Update:
-----------------------

function Controller:update( dt, ... )
    self:updateEntities( dt, self.entities, ... )
end

function Controller:updateEntities( dt, entities, ... )
    for i, entity in ipairs( entities ) do
        self:updateEntity( dt, entity, ... )
    end
end

-----------------------
-- Interface:
-----------------------

function Controller:updateEntity( dt, entity, ... ) end




