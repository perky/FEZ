RenderableAspect = Aspect('RenderableAspect')

function RenderableAspect:getComponents()
	return {
		TransformAttribute, 
		AnimatingSpriteAttribute,
		TileMovementAttribute
	}
end