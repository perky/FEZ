local function addEntityToAspect( entity, aspect )
	local newAspectEntity = AspectEntity( entity, aspect )
	table.insert( aspect.aspectEntities, newAspectEntity )
end

local function removeEntityFromAspectList( entity, aspect )
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

local function entityHasComponents( entityComponents, aspectComponents )
	for _, component in ipairs( aspectComponents ) do
		if not entityComponents:hasType( component ) then
			return false
		end
	end

	return true
end

local function onEntityRefreshed( aspect, entity, componentTypes )
	if entityHasComponents( componentTypes, aspect.components ) and not aspectHasEntity( aspect, entity ) then
		addEntityToAspect( entity, aspect )
	elseif aspectHasEntity( aspect, entity ) then
		removeEntityFromAspect( entity, aspect )
	end
end

local function onEntityDestroyed( aspect, entity )
	if aspectHasEntity( aspect, entity ) then
		removeEntityFromAspect( entity, aspect )
	end
end

function Aspect( name, entityManager, ... )
	local components = {...}
	local newAspect = {}
	newAspect._kind = "Aspect"
	newAspect._name = name
	newAspect.entityManager = entityManager
	newAspect.components = components
	newAspect.aspectEntities = {}

	EventDispatcher.listen( "on_entity_refresh", newAspect, onEntityRefreshed, newAspect )
    EventDispatcher.listen( "on_entity_destroy", newAspect, onEntityDestroyed, newAspect )
    return newAspect
end

function AspectEntity( entity, aspect )
	local newAspectEntity = {}
	newAspectEntity._kind = "AspectEntity"
	newAspectEntity.entity = entity
	for _, component in ipairs( aspect.components ) do
		newAspectEntity[name] = aspect.entityManager:getComponentFromEntity( entity, component )
	end
end