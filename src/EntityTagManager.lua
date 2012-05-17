local _path = ({...})[1]:gsub("%.EntityTagManager", "")
local bag = require( _path .. '.util.bag' )

function EntityTagManager( entityManager )
  local entityTagManager = {}
  entityTagManager.entityManager = entityManager
  entityTagManager.tagsToEntities = bag.new()
  entityTagManager.entitiesToTags = bag.new()

  function entityTagManager:addTagsToEntity( entity, ... )
    local tags = {...}
    self.entitiesToTags:set( entity, tags )
    for i, tag in ipairs(tags) do
      local tagToEntities = self.tagsToEntities:get( tag )
      if not tagToEntities then
        tagToEntities = {}
        self.tagsToEntities:set( tag, tagToEntities )
      end
      tagToEntities[#tagToEntities+1] = entity
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