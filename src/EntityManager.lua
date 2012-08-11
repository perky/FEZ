local _path = ({...})[1]:gsub("%.EntityManager", "")
local bag = require( _path .. '.util.bag' )

-----------------------
-- Private variables:
-----------------------

local _entityTableSize = 4294967296

-----------------------
-- Private Methods:
-----------------------

local function _getUniqueID( entityManager )
    for i=1, _entityTableSize do
        if entityManager.entities[i] == nil or entityManager.entities[i] == false then
            return i
        end
    end
end

-----------------------
-- EntityManager:
-----------------------

function EntityManager()
    local em = {}
    em._kind = 'EntityManager'
    em.entities    = {}
    em.entityNames = {}
    em.components  = {}
    em.entitiesToComponentTypes = bag.new(  )
    em.componentTypesToEntities = bag.new(  )
    em.tagManager  = EntityTagManager( em )

    -----------------------
    -- Entity Initialization:
    -----------------------
    
    function em:createEntity( name, id )
        local id = id or _getUniqueID( self )
        assert( not self.entities[id], "Entity already exists with id "..id )
        self.entities[id]    = true
        -- Names used for debugging.
        self.entityNames[id] = name or "entity"
        return id
    end

    function em:addComponentToEntity( entity, component )
        component:setOwner( entity )
        -- Add to tables. (Strong)
        self.components[#self.components+1] = component
        -- Add to components-to-entities bag. (Weak)
        local componentTypeToEntities = self.componentTypesToEntities:get( component._typeid )
        if not componentTypeToEntities then
            componentTypeToEntities = bag.new( 'kv' )
            self.componentTypesToEntities:set( component._typeid, componentTypeToEntities )
        end
        componentTypeToEntities:set( entity, component )
        -- Add to entities-to-components bag. (Weak)
        local entityToComponentTypes  = self.entitiesToComponentTypes:get( entity )
        if not entityToComponentTypes then
            entityToComponentTypes = bag.new( 'kv' )
            self.entitiesToComponentTypes:set( entity, entityToComponentTypes )
        end
        entityToComponentTypes:set( component._typeid, component )
        
        return component
    end

    function em:refreshEntity( entity )
        self:assert_entity_exists( entity )
        local entityToComponentTypes = self.entitiesToComponentTypes:get( entity )
        for typeid, component in pairs( entityToComponentTypes ) do
            component:onOwnerRefresh( entity, entityToComponentTypes )
        end
        EventDispatcher.send( "on_entity_refresh", nil, entity, entityToComponentTypes, self )
    end

    -----------------------
    -- Exist Validation:
    -----------------------

    function em:entityExists( entity )
        return self.entitiesToComponentTypes:contains( entity )
    end

    function em:componentTypeExists( component )
        return self.componentTypesToEntities:hasType( component )
    end

    -----------------------
    -- Assertions:
    -----------------------
    
    function em:assert_entity_has_componentType( entity, componentType )
        local entityHasComponent = self.entitiesToComponentTypes:get( entity ):contains( componentType._typeid )
        assert( entityHasComponent, "Entity "..self:entityToString( entity ).." does not possess component "..tostring(componentType))
    end

    function em:assert_entity_exists( entity )
        assert( self:entityExists(entity), "Entity "..self:entityToString( entity ).." does not exist." )
    end

    function em:assert_componentType_exists( componentType )
        assert( self:componentTypeExists(componentType), "Component "..tostring(componentType).." does not exist." )
    end

    -----------------------
    -- Entity & Component Getters:
    -----------------------

    function em:getEntities()
        return self.entities
    end

    function em:getComponents()
        return self.components
    end

    function em:getComponentFromEntity( entity, componentType )
        self:assert_entity_exists( entity )
        self:assert_entity_has_componentType( entity, componentType )
        return self.entitiesToComponentTypes:get( entity ):get( componentType._typeid )
    end

    function em:getEntityComponents( entity )
        self:assert_entity_exists( entity )
        local entityToComponentTypes = self.entitiesToComponentTypes:get( entity )
        return entityToComponentTypes:valuesToList()
    end

    function em:getEntitiesWithComponent( componentType )
        self:assert_componentType_exists( componentType )
        return self.componentTypesToEntities:get( componentType._typeid ):keysToList()
    end

    function em:getComponentsOfType( componentType )
        self:assert_componentType_exists( componentType )
        return self.componentTypesToEntities:get( componentType._typeid ):valuesToList()
    end

    function em:entityHasComponent( entity, componentType )
        self:assert_entity_exists( entity )
        return self.entitiesToComponentTypes:get( entity ):contains( componentType._typeid )
    end

    function em:entityHasComponents( entity, ... )
        local components = {...}
        for i, component in ipairs( components ) do
            if not self:entityHasComponent( entity, component ) then return false end
        end
        return true
    end

    function em:entityHasName( entity, name )
        return self.entityNames[entity] == name
    end

    function em:getEntityName( entity )
        if not self.entityNames[entity] then
            return "NIL"
        end
        return self.entityNames[entity]
    end

    -----------------------
    -- Other:
    -----------------------
    
    function em:entityToString( entity )
        if not entity then
            return "NIL"
        end
        return string.format( "(%s:%s)", entity, self:getEntityName(entity) )
    end

    -----------------------
    -- Destruction:
    -----------------------

    function em:destroyEntity( entity )
        self:assert_entity_exists( entity )
        self.entities[entity] = nil
        local entityToComponentTypes = self.entitiesToComponentTypes:get( entity )
        for type, component in pairs(entityToComponentTypes) do
            self:destroyComponentInstance( entity, component )
        end
        self.entitiesToComponentTypes:set( entity, nil )
        EventDispatcher.send( "on_entity_destroy", nil, entity, self )
    end

    function em:destroyComponentInstance( entity, component )
        local componentTypeToEntities = self.componentTypesToEntities:get( component._typeid )
        componentTypeToEntities:set( entity, nil )
        local entityToComponentTypes = self.entitiesToComponentTypes:get( entity )
        entityToComponentTypes:set( component._typeid, nil )

        for i, v in ipairs( self.components ) do
            if v == component then
                table.remove( self.components, i )
                break
            end
        end

        component:onDestroy()
        EventDispatcher.send( "on_component_destroy", nil, component )
    end

    function em:removeComponentFromEntity( entity, componentType )
        self:assert_entity_has_componentType( entity, componentType )
        local component = self:getComponentFromEntity( entity, componentType )
        self:destroyComponentInstance( entity, component )
    end

    -----------------------
    -- Update:
    -----------------------

    function em:updateBehaviours( ... )
        for i, component in ipairs( self.components ) do
            if component and component._kind == "Behaviour" and component:getEnabled() then
                component:updateOwner( component._owner, ... )
            end
        end
    end

    return em
end