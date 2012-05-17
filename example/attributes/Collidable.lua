Collidable = Attribute('Collidable')

function Collidable:onInit()
	self.isColliding = false
	self.collidingEntity = nil
end

function Collidable:setIsColliding( isColliding )
	self.isColliding = isColliding
end

function Collidable:getIsColliding()
	return self.isColliding
end

function Collidable:setCollidingEntity( collidingEntity )
	self.collidingEntity = collidingEntity
end

function Collidable:getCollidingEntity()
	return self.collidingEntity
end