TileMovementAspect = Aspect('TileMovementAspect')

function TileMovementAspect:getComponents()
	return {
		TransformAttribute,
		MovementStateAttribute,
		TileMovementAttribute,
		MapPositionAttribute
	}
end