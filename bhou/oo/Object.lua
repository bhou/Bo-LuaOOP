-----------------------------------------------------------------------------
-- @class file
-- module Object
-- Object is the root class for all the other class
-- it provide the following methods:
-- constructor(...)
-- super()
-- getClass()
-- getClassName()
-- instanceof( class )
-- clone()
-- __tostring()
-- @author 	BHou
------------------------------------------------------------------------------

local Object = {};

-- import the mata object
local MetaObject = require( "bhou.oo.MetaObject" );
-- import the mata class
local MetaClass = require( "bhou.oo.MetaClass" );

local print = print
local getmetatable = getmetatable
local setmetatable = setmetatable
local table = table
local rawset = rawset
local rawget = rawget
local setfenv = setfenv
local getfenv = getfenv
local type = type
local tostring = tostring

-- set the sandbox


-------------------------------------------------------------------
-- internal fields
-------------------------------------------------------------------
__name = "Object";
__super = nil;
__interfaces = {};
__isclass = true;

---
-- constructors
-- @param ...				the contructor params
function Object.init( self, ... )
end

---
-- finalize the object
function Object.finalize( self )
end

--- get the class of the object
-- if the object is a class the meta class is returned
function Object.getClass( self )
	return self.__class;
end
--- get the name of the class for the object
function Object.getClassName( self )
	return self.__class.__name;
end


-- local traversal function
local function _visitInheritTree( class, visit, continue )
	if not continue[1] then
		return;
	end

	if class == nil or visit == nil or type( visit ) ~= "function" then
		return;
	end

	if not visit( class ) then
		continue[1] = false;
	end

	-- visit the super
	_visitInheritTree( class.__super, visit, continue );
	-- visit the interfaces
	local i;
	for i = 1,  #(class.__interfaces) do
		_visitInheritTree( class.__interfaces[i], visit, continue );
	end
end
--- visit inherit tree
-- @param visit			the visit function with the form "bool function ( class or interface )"
function Object.visitInheritTree( self, visit )
	local continue = {true};
	_visitInheritTree( self.__class, visit, continue );
end

--- determine if the object is an instance of given class
-- @param class			the plxpls style class
function Object.instanceof( self, class )
	if class == nil or class.__name == nil then
		return false;
	end
	local ret = false;
	local visitF = function( clz )
		if clz.__name == class.__name then
			ret = true;
			return false;
		end

		return true;
	end

	self:visitInheritTree( visitF );

	return ret;
end

--- clone the object
function Object.clone( self, ... )
	-- todo
end

function Object.serialize()

end

--- serialize to string, this will be called by lua build in tostring function
function Object.toString( self, ... )
	return self.__class.__name  --.."@"..self;
end


-- return the module
return Object;
