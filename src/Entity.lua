Entity = class('Entity', nil)

function Entity:initialize( entityManager, id, name )
    self.entityManager = entityManager
    self.id = id
    self.components = {}
    self.attributes = {}
    self.behaviours = {}
    self.name = name
end

function Entity:destroy()
    for i, component in ipairs( self.components ) do
        component:destroy()
    end
    self.components = nil
    self.attributes = nil
    self.behaviours = nil
    self.entityManager = nil
    self.entityManager:onEntityDestroy( self )
end

-----------------------
-- Getters & Setters:
-----------------------

function Entity:getId()
    return self.id
end

-----------------------
-- Public Methods:
-----------------------

function Entity:addComponent( component )
    assert( not self:hasComponent( componentClass ), "An entity can only have one component class each." )
    self[ component:getAccessorName() ] = component
    component:setOwner( self )
    table.insert( self.components, component )
    if instanceOf( Attribute, component ) then
        table.insert( self.attributes, component )
    elseif instanceOf( Behaviour, component ) then
        table.insert( self.behaviours, component )
    end
    
    EventDispatcher.send( "on_entity_add_component", nil, self, component )
end

function Entity:addComponentClass( componentClass )
    assert( not self:hasComponent( componentClass ), "An entity can only have one component class each." )
    self:addComponent( componentClass() )
end

function Entity:addComponentClasses( componentClasses )
    for i, componentClass in ipairs(componentClasses) do
        self:addComponentClass( componentClass )
    end
end

function Entity:destroyComponent( componentClass )
    local component = self:getComponent( componentClass )
    component:destroy()
    self:removeComponent( componentClass )
end

function Entity:removeComponent( componentClass )
    for i, component in ipairs(self.components) do
        if instanceOf( componentClass, component ) then
            table.remove( self.components, i )
            break
        end
    end
    for i, attribute in ipairs( self.attributes ) do
        if instanceOf( componentClass, attribute ) then
            table.remove( self.attributes, i )
            break
        end
    end
    for i, behaviour in ipairs( self.behaviours ) do
        if instanceOf( componentClass, behaviour ) then
            table.remove( self.behaviours, i )
            break
        end
    end
end

function Entity:hasComponent( componentClass )
    for i, component in ipairs(self.components) do
        if instanceOf( componentClass, component ) then
            return true
        end
    end
    
    return false
end

function Entity:getComponent( componentClass )
    for i, component in ipairs(self.components) do
        if instanceOf( componentClass, component ) then
            return component
        end
    end
    -- If component not found.
    error("Entity does not have component "..tostring(componentClass))
end

function Entity:refresh()
    for i, component in ipairs(self.components) do
        component:onOwnerRefresh( self )
    end
end