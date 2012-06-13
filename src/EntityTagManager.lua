local _path = ({...})[1]:gsub("%.EntityTagManager", "")
local bag = require( _path .. '.util.bag' )

function EntityTagManager( entityManager )
  local entityTagManager = {}
  entityTagManager.entityManager = entityManager
  entityTagManager.tagsToEntities = bag.new()
  entityTagManager.entitiesToTags = bag.new()

  function entityTagManager:eventEntityDestroy( entity )
    local tags = self.entitiesToTags:get( entity )
    local tagToEntities
    for i, tag in ipairs( tags ) do
      tagToEntities = self.tagsToEntities:get( tag )
      if tagToEntities then
        for j, v in ipairs( tagToEntities ) do
          if v == entity then
            table.remove( tagToEntities, j )
            break
          end
        end
      end
      tagToEntities = nil
    end
    self.entitiesToTags:set( entity, nil )
  end
  EventDispatcher.listen( "on_entity_destroy", nil, entityTagManager.eventEntityDestroy, entityTagManager)

  function entityTagManager:addTagsToEntity( entity, ... )
    local tags = {...}
    for i, tag in ipairs(tags) do
      --
      local entityToTags  = self.entitiesToTags:get( entity )
      if not entityToTags then
        entityToTags = {}
        self.entitiesToTags:set( entity, entityToTags )
      end
      entityToTags[#entityToTags+1] = tag
      --
      local tagToEntities = self.tagsToEntities:get( tag )
      if not tagToEntities then
        tagToEntities = {}
        self.tagsToEntities:set( tag, tagToEntities )
      end
      tagToEntities[#tagToEntities+1] = entity
      --
    end
  end

  function entityTagManager:getEntitiesWithTag( tag )
    return self.tagsToEntities:get( tag )
  end

  function entityTagManager:getTagsFromEntity( entity )
    return self.entitiesToTags:get( entity )
  end

  function entityTagManager:getEntitiesWithAnyTags( ... )
    local queryTags = {...}
    local entities = {}

    for entity, tags in pairs( self.entitiesToTags ) do
      if self:entityHasAnyTags( entity, queryTags ) then
        entities[#entities+1] = entity
      end
    end

    return entities
  end

  function entityTagManager:getEntitiesWithAllTags( ... )
    local queryTags = {...}
    local entities = {}

    for entity, tags in ipairs( self.entitiesToTags ) do
      if self:entityHasAllTags( entity, queryTags ) then
        entities[#entities+1] = entity
      end
    end

    return entities
  end

  function entityTagManager:entityHasTag( entity, tag )
    return self:entityHasAnyTags( entity, {tag} )
  end

  function entityTagManager:tagsHasTag( tags, tag )
    for i, atag in ipairs(tags) do
      if atag == tag then return true end
    end
  end

  function entityTagManager:entityHasAnyTags( entity, queryTags )
    for i, tag in ipairs( self.entitiesToTags:get( entity ) ) do
      for j, queryTag in ipairs(queryTags) do
        if tag == queryTag then return true end
      end
    end
  end

  function entityTagManager:entityHasAllTags( entity, queryTags )
    local unmatchedTags = #queryTags

    for i, tag in ipairs( self.entitiesToTags:get( entity ) ) do
      for j, queryTag in ipairs(queryTags) do
        if tag == queryTag then
          unmatchedTags = unmatchedTags - 1
        end
      end
    end
    return unmatchedTags == 0
  end

  return entityTagManager
end