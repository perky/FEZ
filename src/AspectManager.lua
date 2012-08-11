-----------------------
-- Aspect Manager
-----------------------
-----------------------
-- Local variables:
-----------------------
-----------------------
-- Local Functions:
-----------------------

local function addEntityToAspect( entity, aspect, entityManager )
	local newAspectEntity = AspectEntity( entity, aspect, entityManager )
	table.insert( aspect.aspectEntities, newAspectEntity )
end

local function removeEntityFromAspect( entity, aspect )
	for i, aspectEntity in ipairs( aspect.aspectEntities ) do
		if aspectEntity.entity == entity then
			return table.remove( aspect.aspectEntities, i )
		end
	end
end

local function aspectHasEntity( aspect, entity )
	for i, aspectEntity in ipairs( aspect.aspectEntities ) do
		if aspectEntity.entity == entity then
			return true
		end
	end

	return false
end

local function onEntityRefreshed( aspect, entity, componentTypes, entityManager )
	local aspectComponents = aspect:getComponents()
	if entityManager:entityHasComponents( entity, unpack(aspectComponents) ) and not aspectHasEntity( aspect, entity ) then
		addEntityToAspect( entity, aspect, entityManager )
	elseif aspectHasEntity( aspect, entity ) then
		removeEntityFromAspect( entity, aspect )
	end
end

local function onEntityDestroyed( aspect, entity, entityManager )
	if aspectHasEntity( aspect, entity ) then
		removeEntityFromAspect( entity, aspect )
	end
end

-----------------------
-- Main Functions:
-----------------------

function Aspect( name )
	local newAspect = {}
	newAspect._kind = "Aspect"
	newAspect._name = name

	local aspectEntities = {}
	newAspect.aspectEntities = aspectEntities

	function newAspect:list()
		local i = 0
		local size = #aspectEntities
		return function()
			i = i + 1
			if i <= size then return aspectEntities[i] end
		end
	end

	EventDispatcher.listen( "on_entity_refresh", newAspect, onEntityRefreshed, newAspect )
    EventDispatcher.listen( "on_entity_destroy", newAspect, onEntityDestroyed, newAspect )
    return newAspect
end

function AspectEntity( entity, aspect, entityManager )
	local newAspectEntity = {}
	newAspectEntity._kind = "AspectEntity"
	newAspectEntity.entity = entity

	for _, component in ipairs( aspect:getComponents() ) do
		newAspectEntity[component._name] = entityManager:getComponentFromEntity( entity, component )
	end
	return newAspectEntity
end