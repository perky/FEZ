SpriteRenderer = Controller('SpriteRenderer')

function SpriteRenderer:onInit()
	self:setAspect( RenderableAspect )
	EventDispatcher.listen("on_TileMovementController_interval", nil, self.onTileMovementControllerInterval, self)
	EventDispatcher.listen("on_WolfMovementController_interval", nil, self.onTileMovementControllerInterval, self)
end

-----------------------
-- Depedendencies:
-----------------------

function SpriteRenderer:onControllersRefresh( cm )
end

-----------------------
-- Events:
-----------------------

function SpriteRenderer:onTileMovementControllerInterval( tileMovementAspect )
	for renderableAspect in self:getAspect().list() do
		if renderableAspect.entity == tileMovementAspect.entity then
			local sprite = renderableAspect.AnimatingSpriteAttribute
			sprite.lastPosition = sprite.position:clone()
			sprite.lastScale = sprite.scale:clone()
			sprite.lastAngle = sprite.angle
			break
		end
	end
end

-----------------------
-- Update:
-----------------------



function SpriteRenderer:onUpdate( aspect )
	local dt = love.timer.getDelta()
	local spriteAttribute    = aspect.AnimatingSpriteAttribute
	local transformAttribute = aspect.TransformAttribute
	local tileMovementAttribute = aspect.TileMovementAttribute
	self:animateSprite( spriteAttribute, dt )
	self:tweenSpriteTransform( spriteAttribute, transformAttribute, tileMovementAttribute )
	self:renderSprite( spriteAttribute )
end

function SpriteRenderer:animateSprite( sprite, dt )
	sprite.frametime = sprite.frametime + dt
	if sprite.frametime >= sprite.framerate then
		sprite.frametime = 0
		sprite.currentFrame = sprite.currentFrame + 1
		if sprite.currentFrame > #sprite.sprites then
			sprite.currentFrame = 1
		end
	end
end

function SpriteRenderer:tweenSpriteTransform( sprite, transform, tileMovement )
	local t = tileMovement.timer * ( 1 / tileMovement.rate )
	local angle = tween.lerpAngle( sprite.lastAngle, transform.angle, t )
	sprite.angle = angle
	sprite.position.x, sprite.position.y = tween.lerpXY(
		sprite.lastPosition.x, 
		sprite.lastPosition.y, 
		transform.position.x, 
		transform.position.y, 
		t 
	)
	sprite.scale.x, sprite.scale.y = tween.lerpXY(
		sprite.lastScale.x,
		sprite.lastScale.y,
		transform.scale.x, 
		transform.scale.y, 
		t
	)
end

function SpriteRenderer:renderSprite( sprite )
	love.graphics.draw( 
		sprite.sprites[sprite.currentFrame], 
		sprite.position.x, 
		sprite.position.y, 
		sprite.angle, 
		sprite.scale.x, 
		sprite.scale.y, 
		sprite.offset.x, 
		sprite.offset.y 
	)
end