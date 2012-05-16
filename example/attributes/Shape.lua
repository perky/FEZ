Shape = class('Shape', Attribute)

--[[
	This is a super attribute.
	ShapeCircle and ShapeHexagon subclass this class.
	They should both implement the 'isPointInside' method.
	Now a controller can call 'entity:getComponent( Shape )' and if
	the entity has a ShapeCircle class it returns that, likewise for ShapeHexagon.
	This is assuming the entity has only one Shape component, if it had both
	ShapeCircle and ShapeHexagon you would call it explicitly with 'entity:getComponent( ShapeCircle )'
]]

-----------------------
-- Interface:
-----------------------

function Shape:isPointInside( x, y ) end