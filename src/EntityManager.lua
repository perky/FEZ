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
    
    function em:createEntity( name )
        local id = _getUniqueID( self )
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
        assert( self:entityExists(entity), "Entity "..entity.." does not exist." )
        local entityToComponentTypes = self.entitiesToComponentTypes:get( entity )
        for typeid, component in pairs( entityToComponentTypes ) do
            component:onOwnerRefresh( entity )
        end
        EventDispatcher.send( "on_entity_refresh", nil, entity, entityToComponentTypes )
    end

    -----------------------
    -- Exist Validation:
    -----------------------

    function em:entityExists( entity )
        return self.entitiesToComponentTypes:contains( entity )
    end

    function em:componentTypeExists( component )
        return self.componentTypesToEntities:contains( component._typeid )
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

    function em:getComponentFromEntity( entity, component )
        assert( self:entityExists(entity), "Entity "..self:entityToString(entity).." does not exist." )
        assert( self:componentTypeExists(component), "Entity "..self:entityToString( entity ).." does not possess component "..tostring(component))
        return self.entitiesToComponentTypes:get( entity ):get( component._typeid )
    end

    function em:getEntityComponents( entity )
        assert( self.entityExists( entity ), "Entity "..self:entityToString(entity).." does not exist." )
        local entityToComponentTypes = self.entitiesToComponentTypes:get( entity )
        return entityToComponentTypes:valuesToList()
    end

    function em:getEntitiesWithComponent( component )
        assert( self:componentTypeExists(component), "Component "..tostring(component).." does not exist." )
        return self.componentTypesToEntities:get( component._typeid ):keysToList()
    end

    function em:getComponentsOfType( component )
        assert( self:componentTypeExists(component), "Component "..tostring(component).." does not exist." )
        return self.componentTypesToEntities:get( component._typeid ):valuesToList()
    end

    function em:getEntityName( entity )
        return self.entityNames[entity]
    end

    function em:entityHasComponent( entity, component )
        assert( self.entityExists( entity ), "Entity "..self:entityToString(entity).." does not exist." )
        return self.entitiesToComponentTypes:get( entity ):contains( component._typeid )
    end

    function em:entityHasComponents( entity, ... )
        local components = {...}
        local unmatchedComponents = #components
        for i, component in ipairs( components ) do
            if self:entityHasComponent( entity, component ) then
                unmatchedComponents = unmatchedComponents - 1
            end
        end
        return unmatchedComponents == 0
    end

    -----------------------
    -- Other:
    -----------------------
    
    function em:entityToString( entity )
        local s = "Entity (%s:%s)"
        return s:format( entity, self:getEntityName(entity) )
    end

    -----------------------
    -- Destruction:
    -----------------------

    function em:destroyEntity( entity )
        assert( self.entityExists( entity ), "Entity "..self:entityToString(entity).." does not exist." )
        local components = self:getEntityComponents( entity )
        for i, component in ipairs( components ) do
            self:destroyComponent( entity, component )
        end
        self.entitiesToComponentTypes:set( entity, nil )
        self.entities[entity] = false
        EventDispatcher.send( "on_entity_destroy", nil, entity )
    end

    function em:destroyComponent( entity, component )
        assert( self:componentTypeExists(component), "Component "..tostring(component).." does not exist." )
        self.componentTypesToEntities:get( component ):set( entity, nil )
        for i, v in ipairs( self.components ) do
            if v == component then
                table.remove( self.components, i )
                break
            end
        end
        EventDispatcher.send( "on_component_destroy", nil, component )
        component:onDestroy()
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