local _path = ({...})[1]:gsub("%.init", "")
local function _require( s ) require( _path .. '.' .. s ) end

_require 'EventDispatcher'
_require 'EntityManager'
_require 'EntityTagManager'
_require 'Component'
_require 'ControllerManager'
_require 'AspectManager'
_require 'ComponentCache'