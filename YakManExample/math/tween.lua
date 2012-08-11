local tween = {}

function tween.lerp( a, b, t )
	local c = (b-a) * t
	return a + c
end

function tween.lerpXY( x1, y1, x2, y2, t )
  local x3 = (x2 - x1) * t
  local y3 = (y2 - y1) * t
  return x1 + x3, y1 + y3
end

function tween.lerpAngle( angle1, angle2, t )
	local pi = math.pi
	if angle2 > angle1 then
		while angle2 - angle1 > pi do
			angle2 = angle2 - TAU
		end
	else
		while angle2 - angle1 < -pi do
			angle2 = angle2 + TAU
		end
	end
	return tween.lerp( angle1, angle2, t )
end

return tween