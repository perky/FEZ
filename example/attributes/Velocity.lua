Velocity = class('Velocity', Attribute)

function Velocity:onInit( speed, angle )
    self.speed = speed or 0
    self.angle = angle or 0
end

function Velocity:setSpeed( speed )
    self.speed = speed or 0
end

function Velocity:getSpeed()
    return self.speed
end

function Velocity:setAngle( angle )
    self.angle = angle
end

function Velocity:getAngle()
    return self.angle
end

function Velocity:getAngleInRadians()
	return math.rad( self.angle )
end