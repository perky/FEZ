WolfAspect = Aspect('WolfAspect')

function WolfAspect:getComponents()
	return {
		TileMovementAttribute,
		MapPositionAttribute,
		TransformAttribute,
		MovementStateAttribute,
		WolfAttribute
	}
end