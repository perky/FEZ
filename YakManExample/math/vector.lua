-- Copyright (C) 2012 Nicholas Carlson
--
-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the "Software"),
-- to deal in the Software without restriction, including without limitation
-- the rights to use, copy, modify, merge, publish, distribute, sublicense,
-- and/or sell copies of the Software, and to permit persons to whom the
-- Software is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
-- DEALINGS IN THE SOFTWARE.

--[[

Example usage:

  local Vector = require 'vec'
  local cos, mix = Vector.cos, Vector.mix

  local v = Vector( 0, math.pi )
  print( cos( v ) ) -- <1, -1>

  local u = Vector( 0, 0, 0 )
  local w = Vector( 1, 2, 3 )

  print( mix( u, w, 0.5 ) ) -- <0.5, 1, 1.5>

]]--


local vec = {}
vec.__index = vec

local function new_vec1( x )
  local default = 0
  local object = {
    [1] = x or default;
    x = x or default;
  }
  return setmetatable( object, vec )
end

local function new_vec2( x, y )
  local default = x or 0
  local object = {
    x = x or default;
    y = y or default;
  }
  return setmetatable( object, vec )
end

local function new_vec3( x, y, z )
  local default = x or 0
  local object = {
    [1] = x or default;
    [2] = y or default;
    [3] = z or default;
    x = x or default;
    y = y or default;
    z = z or default;
  }
  return setmetatable( object, vec )
end

local function new_vec4( w, x, y, z )
  local default = w or 0
  local object = {
    [1] = w or default;
    [2] = x or default;
    [3] = y or default;
    [4] = z or default;
    w = w or default;
    x = x or default;
    y = y or default;
    z = z or default;
  }
  return setmetatable( object, vec )
end

local function new ( ... )
  local vec_constructor_lookup = {
    [1] = new_vec1( ... );
    [2] = new_vec2( ... );
    [3] = new_vec3( ... );
    [4] = new_vec4( ... );
  }
  return vec_constructor_lookup[ select( '#', ... ) ]
end

function vec:dimensions()
    local c = 0
    for i, v in pairs(self) do
        c = c + 1
    end
    return c
end

local function clone1(v)
    return new_vec1( v.x )
end

local function clone2(v)
    return new_vec2( v.x, v.y )
end

local function clone3(v)
    return new_vec3( v.x, v.y, v.z )
end

local function clone4(v)
    return new_vec4( v.w, v.x, v.y, v.z )
end

function vec:clone()
    local vec_clone_lookup = {
        [1] = clone1;
        [2] = clone2;
        [3] = clone3;
        [4] = clone4;
    }
    return vec_clone_lookup[ self:dimensions() ]( self )
end

local function unpack1(v)
    return v.x
end

local function unpack2(v)
    return v.x, v.y
end

local function unpack3(v)
    return v.x, v.y, v.z
end

local function unpack4(v)
    return v.w, v.x, v.y, v.z
end

function vec:unpack()
    local vec_unpack_lookup = {
        [1] = unpack1;
        [2] = unpack2;
        [3] = unpack3;
        [4] = unpack4;
    }
    return vec_unpack_lookup[ self:dimensions() ]( self )
end

local function toString( v )
  local s = "vector:<"
  local dimensions = v:dimensions()
  local count = 1
  local lastvalue = nil
  for k, _v in pairs(v) do
      if count == dimensions then
          lastvalue = tostring(_v)
          break
      end
      s = s .. tostring(_v) .. ','
      count = count + 1
  end

  return s .. lastvalue .. '>'
end

-------------------------------------------------------------------------------
-- Helper functions which apply arbitrary functions to the supplied arguments.
-------------------------------------------------------------------------------

--- Returns the application of function f to argument v.
-- @param v vector
-- @param f function
local function _apply_v ( v, f )
  local fv = v:clone()
  for key,value in pairs(v) do fv[key] = f( v[key] ) end
  return fv
end

--- Returns the application of function f to arguments v and s.
-- @param v vector
-- @param s number
-- @param f function
local function _apply_v_s ( v, s, f )
  local fv = v:clone()
  for key,value in pairs(v) do fv[key] = f( v[key], s ) end
  return fv
end

--- Returns the application of function f to arguments v, s and t.
-- @param v vector
-- @param s number
-- @param t number
-- @param f function
local function _apply_v_2s ( v, s, t, f )
  local fv = v:clone()
  for key,value in pairs(v) do fv[key] = f( v[key], s, t ) end
  return fv
end

--- Returns the application of function f to arguments v and w.
-- @param v vector
-- @param w vector
-- @param f function
local function _apply_2v ( v, w, f )
  local fv = v:clone()
  for key,value in pairs(v) do fv[key] = f( v[key], w[key] ) end
  return fv
end

--- Returns the application of function f to arguments v, w and s.
-- @param v vector
-- @param w vector
-- @param s number
-- @param f function
local function _apply_2v_s ( v, w, s, f )
  local fv = v:clone()
  for key,value in pairs(v) do fv[key] = f( v[key], w[key], s ) end
  return fv
end

--- Returns the application of function f to arguments v, w and u.
-- @param v vector
-- @param w vector
-- @param u vector
-- @param f function
local function _apply_3v ( v, w, u, f )
  local fv = v:clone()
  for key,value in pairs(v) do fv[key] = f( v[key], w[key], u[key] ) end
  return fv
end


-------------------------------------------------------------------------------
-- Arithmetic
-------------------------------------------------------------------------------

local function add ( x, y )
  if type( y ) == "number" then
    return _apply_v_s( x, y, function ( _x, _y ) return _x + _y end )
  else
    return _apply_2v( x, y, function ( _x, _y ) return _x + _y end )
  end
end

local function subtract ( x, y )
  if type( y ) == "number" then
    return _apply_v_s( x, y, function ( _x, _y ) return _x - _y end )
  else
    return _apply_2v( x, y, function ( _x, _y ) return _x - _y end )
  end
end

local function multiply ( x, y )
  if type( y ) == "number" then
    return _apply_v_s( x, y, function ( _x, _y ) return _x * _y end )
  else
    return _apply_2v( x, y, function ( _x, _y ) return _x * _y end )
  end
end

local function divide ( x, y )
    if type( y ) == "number" then
        return _apply_v_s( x, y, function (_x, _y ) return _x / _y end )
    else
         return _apply_2v( x, y, function ( _x, _y ) return _x / _y end )
    end
end

local function unary( v )
    return _apply_v( v, function ( _v ) return -_v end )
end

-------------------------------------------------------------------------------
-- Angle and Trigonometry Functions
-------------------------------------------------------------------------------

local function _asinh ( x )
  return math.log( x + math.sqrt( x * x + 1 ) )
end

local function _acosh ( x )
  return math.log( x + math.sqrt( x * x - 1 ) )
end

local function _atanh ( x )
  return 0.5 * math.log( ( 1 + x ) / ( 1 - x ) )
end

local function radians ( x )
  return _apply_v( x, math.rad )
end

local function degrees ( x )
  return _apply_v( x, math.deg )
end

local function sin ( x )
  return _apply_v( x, math.sin )
end

local function cos ( x )
  return _apply_v( x, math.cos )
end

local function tan ( x )
  return _apply_v( x, math.tan )
end

local function asin ( x )
  return _apply_v( x, math.asin )
end

local function acos ( x )
  return _apply_v( x, math.acos )
end

local function atan ( x )
  return _apply_v( x, math.atan )
end

local function sinh ( x )
  return _apply_v( x, math.sinh )
end

local function cosh ( x )
  return _apply_v( x, math.cosh )
end

local function tanh ( x )
  return _apply_v( x, math.tanh )
end

local function asinh ( x )
  return _apply_v( x, _asinh )
end

local function acosh ( x )
  return _apply_v( x, _acosh )
end

local function atanh ( x )
  return _apply_v( x, _atanh )
end


-------------------------------------------------------------------------------
-- Exponential Functions
-------------------------------------------------------------------------------

local function _log2 ( x )
 return math.log( x ) / math.log( 2 )
end

local function pow ( x, y )
  if type( y ) == "number" then
    return _apply_v_s( x, y, math.pow )
  else
    return _apply_2v( x, y, math.pow )
  end
end

local function exp ( x )
  return _apply_v( x , math.exp )
end

local function log ( x )
  return _apply_v( x , math.log  )
end

local function exp2 ( x )
  return _apply_v( x , function ( _x ) return math.pow( 2, _x ) end )
end

local function log2 ( x )
  return _apply_v( x , _log2 )
end

local function sqrt ( x )
  return _apply_v( x , math.sqrt )
end

-- @precondition x > 0
local function inverseSqrt ( x )
  return _apply_v( x, function ( _x ) return 1 / sqrt( _x ) end )
end

local function length ( x )
  local l = 0
  for k,v in pairs( x ) do l = l + v * v end
  return math.sqrt( l )
end

-------------------------------------------------------------------------------
-- Common Functions
-------------------------------------------------------------------------------

local function _clamp( x, minVal, maxVal )
  return math.min( math.max( x, minVal ), maxVal )
end

local function _sign ( x )
  return x >= 0 and 1 or -1
end

local function _trunc ( x )
  return _sign( x ) == 1 and math.floor( x ) or math.ceil( x )
end

local function _round ( x )
  return x - _trunc( x ) >= _sign( x ) * 0.5
    and math.ceil( x )
    or math.floor( x )
end

local function _step ( x, edge )
  return x < edge and 0 or 1
end

-- @precondition edge0 < edge1
local function _smoothstep ( x, edge0, edge1 )
  local x = _clamp( (x-edge0)/(edge1-edge0), 0, 1 )
  -- 6x^5 - 14x^4 + 10x^3
  -- credit: [Perlin 2002]: ISBN-13: 978-1558608481
  return x * x * x * ( x * ( x * 6 - 15 ) + 10 )
end

local function abs ( x )
  return _apply_v( x, math.abs )
end

local function sign ( x )
  return _apply_v( x, function ( _x ) return _sign( _x ) end )
end

local function floor ( x )
  return _apply_v( x, math.floor )
end

local function trunc ( x )
  return _apply_v( x, function ( _x ) return _trunc( _x )  end )
end

local function round ( x )
  return _apply_v( x, function ( _x ) return _round( _x ) end )
end

local function roundEven ( x )
  return _apply_v( x, function ( _x ) return _round( _x / 2 ) end )
end

local function ceil ( x )
  return _apply_v( x, math.ceil )
end

local function fract ( x )
  return _apply_v( x, function ( _x ) return _x - math.floor( _x ) end )
end

local function mod ( x, y )
  if type( y ) == "number" then
    return _apply_v_s( x, y, function ( _x, _y ) return _x % _y end )
  else
    return _apply_2v( x, y, function ( _x, _y ) return _x % _y end )
  end
end

local function min ( x, y )
  if type( y ) == "number" then
    return _apply_v_s( x, y, math.min )
  else
    return length( y ) < length( x ) and y or x
  end
end

local function max ( x, y )
  if type( y ) == "number" then
    return _apply_v_s( x, y, math.max )
  else
    return length( y ) > length( x ) and y or x
  end
end

local function clamp ( x, minVal, maxVal )
  return min( max( x, minVal ), maxVal )
end

local function mix ( x, y, a )
  return _apply_2v_s( x, y, a, function ( _x, _y, _a )
                                 return _x * ( 1 - a ) + _y * _a
                               end )
end

local function step ( edge, x )
  if type( edge ) == "number" then
    return _apply_v_s( x, edge, _step )
  else
    return _apply_2v( x, edge, _step )
  end
end

local function smoothstep ( edge0, edge1, x )
  if type( edge0 ) == "number" then
    return _apply_v_2s( x, edge0, edge1, _smoothstep )
  else
    return _apply_3v( x, edge0, edge1, _smoothstep )
  end
end

local function lerp( a, b, t )
    local d = (b - a) * t
    return a + d
end

-------------------------------------------------------------------------------
-- Geometric Functions
-------------------------------------------------------------------------------

local function distance ( p0, p1 )
  return length( subtract( p0, p1 ) )
end

local function dot ( x, y )
  local s = 0
  for k,v in ipairs( x ) do s = s + (x[k] * y[k]) end
  return s
end

local function cross ( x, y )
  return new(x.y * y.z - y.y * x.z,
             x.z * y.x - y.z * x.x,
             x.x * y.y - y.x * x.y)
end

local function normalize ( x )
  local l = length( x )
  return _apply_v( x, function ( _x ) return _x / l end )
  --return new( x.x / l, x.y / l, x.z / l )
end

local function faceforward ( N, I, Nref )
  return dot( I, Nref ) < 0 and N or -N
end

-- @precondition N is normalized
local function reflect ( I, N )
  return I - 2 * dot( I, N ) * N
end

-- @precondition N is normalized
-- @precondition I is normalized
local function refract ( I, N, eta )
  local a = dot( I, N )
  local k = 1 - eta * eta - ( 1 - a * a )
  return k < 0
    and _apply_v( I, function ( _I ) return 0 end )
    or eta * I - ( eta * dot( I, N ) * math.sqrt( k ) ) * N
end

-------------------------------------------------------------------------------
-- Vector Relation Functions
-------------------------------------------------------------------------------

local function lessThan ( x, y )
  if type( y ) == "number" then
    return _apply_v_s( x, y, function ( _x, _y ) return _x < _y end )
  else
    return _apply_2v( x, y, function ( _x, _y ) return _x < _y end )
  end
end

local function lessThanEqual ( x, y )
  if type( y ) == "number" then
    return _apply_v_s( x, y, function ( _x, _y ) return _x <= _y end )
  else
    return _apply_2v( x, y, function ( _x, _y ) return _x <= _y end )
  end
end

local function greaterThan ( x, y )
  if type( y ) == "number" then
    return _apply_v_s( x, y, function ( _x, _y ) return _x > _y end )
  else
    return _apply_2v( x, y, function ( _x, _y ) return _x > _y end )
  end
end

local function greaterThanEqual ( x, y )
  if type( y ) == "number" then
    return _apply_v_s( x, y, function ( _x, _y ) return _x >= _y end )
  else
    return _apply_2v( x, y, function ( _x, _y ) return _x >= _y end )
  end
end

local function equal ( x, y )
  if type( y ) == "number" then
    return _apply_v_s( x, y, function ( _x, _y ) return _x == _y end )
  else
    return _apply_2v( x, y, function ( _x, _y ) return _x == _y end )
  end
end

local function notEqual ( x, y )
  if type( y ) == "number" then
    return _apply_v_s( x, y, function ( _x, _y ) return _x ~= _y end )
  else
    return _apply_2v( x, y, function ( _x, _y ) return _x ~= _y end )
  end
end

-------------------------------------------------------------------------------
-- Vector Orientation Functions
-------------------------------------------------------------------------------

-- rotate vector about axis
-- @precondition axis is a vec3 of unit length
-- @param vector vec3 to rotate
-- @param axis vec3 representing axis of rotation
-- @param r number radians to rotate
local function rotate3D ( vector, axis, radians )
  local x, y, z = vector.x, vector.y, vector.z
  local u, v, w = axis.x, axis.y, axis.z
  local ux = u * x
  local vy = v * y
  local wz = w * z
  local s = math.sin( radians )
  local c = math.cos( radians )

  return new(
    u * ( ux + vy + wz ) * ( 1 - c ) + x * c + ( -w * y + v * z ) * s,
    v * ( ux + vy + wz ) * ( 1 - c ) + y * c + ( w * x - u * z ) * s,
    w * ( ux + vy + wz ) * ( 1 - c ) + z * c + ( -v * x + u * y ) * s )
end

-- rotate 2D vector.
local function rotate2D( vector, radians )
    local c, s = math.cos(radians), math.sin(radians)
	return new(c * vector.x - s * vector.y, s * vector.x + c * vector.y)
end


-- Set metamethods.
vec.__sub = subtract
vec.__add = add
vec.__mul = multiply
vec.__div = divide
vec.__eq = equal
vec.__lt = lessThan
vec.__le = lessThanEqual
vec.__unm = unary
vec.__mod = modulo
vec.__tostring = toString

return setmetatable(
  {
    new = new,
    add = add,
    subtract = subtract,
    multiply = multiply,
    radians = radians,
    degrees = degrees,
    sin = sin,
    cos = cos,
    tan = tan,
    asin = asin,
    acos = acos,
    atan = atan,
    sinh = sinh,
    cosh = cosh,
    tanh = tanh,
    asinh = asinh,
    acosh = acosh,
    atanh = atanh,
    pow = pow,
    exp = exp,
    log = log,
    exp2 = exp2,
    log2 = log2,
    sqrt = sqrt,
    inverseSqrt = inverseSqrt,
    abs = abs,
    sign = sign,
    floor = floor,
    trunc = trunc,
    round = round,
    roundEven = roundEven,
    ceil = ceil,
    fract = fract,
    mod = mod,
    min = min,
    max = max,
    clamp = clamp,
    mix = mix,
    step = step,
    smoothstep = smoothstep,
    length = length,
    distance = distance,
    dot = dot,
    cross = cross,
    normalize = normalize,
    faceforward = faceforward,
    reflect = reflect,
    refract = refract,
    lessThan = lessThan,
    lessThanEqual = lessThanEqual,
    greaterThan = greaterThan,
    greaterThanEqual = greaterThanEqual,
    equal = equal,
    notEqual = notEqual,
    rotate3D = rotate3D,
    rotate2D = rotate2D,
    lerp = lerp
  },
  {__call = function(_,...) return new(...) end})
