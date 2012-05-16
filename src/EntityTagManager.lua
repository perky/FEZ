EntityTagManager = class('EntityTagManager', nil)

function EntityTagManager:initialize( entityManager )
    self.entityManager = entityManager
    self._tagsToEntities = {}
    self._entitiesToTags = {}
end

function EntityTagManager:addTagsToEntity( entity, ... )
    local tags = {...}
    if type(entity) ~= "number" then
        entity = entity:getId()
    end
    
    self._entitiesToTags[ entity ] = tags
    for i, tag in ipairs(tags) do
        if not self._tagsToEntities[ tag ] then
            self._tagsToEntities[ tag ] = {}
        end
        table.insert( self._tagsToEntities[ tag ], entity )
    end
end

function EntityTagManager:getEntitiesWithTag( tag )
    return self._tagsToEntities[ tag ]
end

function EntityTagManager:getTagsFromEntity( entity )
    return self._entitiesToTags[ entity:getId() ]
end

function EntityTagManager:getEntitiesWithAnyTags( ... )
   local tags = {...}
   local entities = {}
   
   for eid, etags in ipairs( self._entitiesToTags ) do
       if self:entityHasAnyTags( eid, tags ) then
           entities[#entities+1] = self.entityManager:getEntity( eid )
       end
   end
   
   return entities
end

function EntityTagManager:getEntitiesWithAllTags( ... )
    local tags = {...}
    local entities = {}

   for eid, etags in ipairs( self._entitiesToTags ) do
       if self:entityHasAllTags( eid, tags ) then
           entities[#entities+1] = self.entityManager:getEntity( eid )
       end
   end
   
   return entities
end

function EntityTagManager:tagsHasTag( tags, tag )
    for i, atag in ipairs(tags) do
        if atag == tag then return true end
    end
end

function EntityTagManager:entityHasAnyTags( entityid, tags )
    for i, etag in ipairs( self._entitiesToTags[entityid] ) do
        for j, tag in ipairs(tags) do
            if tag == etag then return true end
        end
    end
end

function EntityTagManager:entityHasAllTags( entityid, tags )
    local unmatchedTags = #tags
    
    for i, etag in ipairs( self._entitiesToTags[entityid] ) do
        for j, tag in ipairs(tags) do
            if tag == etag then
                unmatchedTags = unmatchedTags - 1
            end
        end
    end
    
    return unmatchedTags == 0
end