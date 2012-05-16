ShapeCircle = class('ShapeCircle', Shape)

function ShapeCircle:onInit( radius )
    self.radius = radius
end

function ShapeCircle:setRadius( radius )
    self.radius = radius
end

function ShapeCircle:getRadius()
    return self.radius
end

function ShapeCircle:isPointInside( x, y )
    return self:distanceSquaredToXY( x, y ) < self.radius * self.radius
end

function ShapeCircle:isTouchingShapeCircleAtXY( shapeCircle, x, y )
    local radii = self.radius + shapeCircle:getRadius()
    return self:distanceSquaredToXY( x, y ) < radii * radii
end

function ShapeCircle:distanceSquaredToXY( x, y )
    return (x * x) + (y * y)
end