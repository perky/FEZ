Transform = Attribute( 'Transform' )

function Transform:onInit( x, y, r, s, z )
    self.x          = x or 0
    self.y          = y or 0
    self.z          = z or 0
    self.rotation   = r or 0
    self.scale      = s or 1
end
function Transform:setRotation( rotation )
    self.rotation = rotation
end

function Transform:getRotation()
    return self.rotation
end

function Transform:setScale( scale )
    self.scale = scale
end

function Transform:getScale()
    return self.scale
end

function Transform:setXY( x, y )
    self.x = x
    self.y = y
end

function Transform:getXY()
    return self.x, self.y
end

function Transform:setX( x )
    self.x = x
end

function Transform:getX()
    return self.x
end

function Transform:setY( y )
    self.y = y
end

function Transform:getY()
    return self.y
end

function Transform:setZ( z )
    self.z = z
end

function Transform:getZ()
    return self.z
end

function Transform:distanceSquaredToXY( x, y )
    local dx = self.x - x
    local dy = self.y - y
    return (dx * dx) + (dy * dy)
end