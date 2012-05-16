Renderer = class('Renderer', Controller)

function Renderer:render( ... )
    self:renderEntities( self.entities, ... )
end

function Renderer:renderEntities( entities, ... )
    for i, entity in ipairs(entities) do
        self:renderEntity( entity )
    end
end

-----------------------
-- Interface:
-----------------------

function Controller:renderEntity( entity, ... ) end