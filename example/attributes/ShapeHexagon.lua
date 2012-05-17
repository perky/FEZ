ShapeHexagon = Attribute('ShapeHexagon')

local _sin60 = math.sin( math.rad( 60 ) )
local _sin30 = math.sin( math.rad( 30 ) )
local _cos30 = math.cos( math.rad( 30 ) )

function ShapeHexagon:onInit( sideLength )
    self:build( sideLength or 1 )
end

function ShapeHexagon:build( sideLength )
    local h, r, width, height, horizontalOffset, verticalOffset
    h = _sin30 * sideLength
    r = _cos30 * sideLength
    height = 2 * r
    width = sideLength * height
    horizontalOffset = sideLength + h
    verticalOffset = r
    
    self.sideLength = sideLength
    self.h = h
    self.r = r
    self.height = height
    self.width = width
    self.horizontalOffset = horizontalOffset
    self.verticalOffset = verticalOffset
    -- Bounds.
    self.x1 = -h
    self.y1 = 0
    self.x2 = horizontalOffset
    self.y2 = height
    -- Vertices.
    self.vertices = {
        0, 0,
        sideLength, 0,
        sideLength + h, r,
        sideLength, r + r,
        0, r + r,
        -h, r
    }
end

function ShapeHexagon:getEdgeBySide( side, inset )
    local edge = {}
    local start = side * 2
    for i = start, start + 3 do
        local i1 = (i % 12) + 1
        edge[#edge + 1] = self.vertices[ i1 ]
    end
    
    if inset then
        local normalize = vector.normalize
        local cx, cy = self:getCenter()
        local vec1 = vector( cx, cy )
        local vec2 = vector( edge[1], edge[2] )
        local vec3 = vector( edge[3], edge[4] )
        local vec1_2 = normalize( vec1 - vec2 )
        local vec1_3 = normalize( vec1 - vec3 )
        vec2 = vec2 + vec1_2 * inset
        vec3 = vec3 + vec1_3 * inset
        edge[1] = vec2.x
        edge[2] = vec2.y
        edge[3] = vec3.x
        edge[4] = vec3.y
    end
    
    return edge
end

function ShapeHexagon:getCenter()
    return (self.sideLength / 2), self.r
end

function ShapeHexagon:isPointInside( px, py )
    -- transform point to always be in bottom right quadrant.
    local cx, cy = self:getCenter()
    local qx = math.abs( px - cx ) + cx
    local qy = math.abs( py - cy ) + cy
    -- check bounds.
    if qx > cx+self.sideLength or qy > self.height then return false end
    -- check corner.
    local px, py = self.vertices[7], self.vertices[8]
    local d = -py * (qx - px) - px * (qy - py)
    return d >= 0
end

function ShapeHexagon:getVertices()
    return self.vertices
end

