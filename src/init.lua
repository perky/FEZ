local _path = ({...})[1]:gsub("%.init", "")
local function _require( s ) require( _path .. '.' .. s ) end

_require 'middleclass'
_require 'EventDispatcher'
_require 'Entity'
_require 'EntityManager'
_require 'EntityTagManager'
_require 'Component'
_require 'Attribute'
_require 'Behaviour'
_require 'Controller'
_require 'Renderer'