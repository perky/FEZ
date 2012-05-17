HudRenderer = Controller('HudRenderer')

function HudRenderer:onInit( ... )
	self.info = "Press the W,A,S,D keys to move about."
end

-- We override the render function.
-- Since we're not rendering any entities.
function HudRenderer:render( ... )
	love.graphics.setColor( 255, 255, 255 )
	love.graphics.print( self.info .. love.timer.getFPS(), 10, 10 )
end