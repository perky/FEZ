EntityManager = class('EntityManager', nil)

function EntityManager:initialize()
    self._entities = {}
    self._entitiesById = {}
    self._tagManager = EntityTagManager( self )
end

-----------------------
-- Private variables:
-----------------------

local _nextAvailableId = { 1 }

-----------------------
-- Private Methods:
-----------------------

local function _getNextAvailableId()
    local id = _nextAvailableId[ #_nextAvailableId ]
    _nextAvailableId[ #_nextAvailableId ] = id + 1
    return id
end

local function _pushAvailableId( id )
    _nextAvailableId[ #_nextAvailableId + 1 ] = id
end

-----------------------
-- Public Methods:
-----------------------

function EntityManager:getTagManager()
    return self._tagManager
end

function EntityManager:createEntity( name )
    local id = _getNextAvailableId()
    assert( not self._entitiesById[id], "Invalid id" )
    local entity = Entity:new( self, id, name )
    self._entitiesById[id] = entity
    self._entities[ #self._entities + 1 ] = entity
    return entity
end

function EntityManager:removeEntity( id )
    local entity = self._entitiesById[id]
    entity:destroy()
end

function EntityManager:onEntityDestroy( entity )
    local id = entity:getId()
    self._entitiesById[id] = false
    _pushAvailableId( id )
    for i, v in ipairs( self._entities ) do
        if v == entity then
            table.remove( self._entities, i )
        end
    end
end

function EntityManager:getEntity( id )
    return self._entitiesById[id]
end

function EntityManager:getEntitiesByName( name )
    local entities = {}
    for i, entity in ipairs(self._entities) do
        if entity and entity.name == name then
            entities[#entities+1] = entity
        end
    end
    
    return entities
end

function EntityManager:getEntitiesWithComponent( componentClass )
    local entities = {}
    for i, entity in ipairs(self._entities) do
        if entity and entity:hasComponent( componentClass ) then
            entities[#entities+1] = entity
        end
    end
    
    return entities
end

function EntityManager:getEntitiesWithComponents( ... )
    local componentClasses = {...}
    local entities = {}
    for i, entity in ipairs(self._entities) do
        local count = #componentClasses
        for j, componentClass in ipairs( componentClasses ) do
            if entity and entity:hasComponent( componentClass ) then
                count = count - 1
            end
        end
        if count == 0 then
            entities[#entities+1] = entity
        end
    end
    
    return entities
end

function EntityManager:updateEntitiesBehaviours( dt )
    for i, entity in ipairs(self._entities) do
        if entity then
            for j, behaviour in ipairs(entity.behaviours) do
                if behaviour:getEnabled() then behaviour:update( dt, entity ) end
            end
        end
    end
end