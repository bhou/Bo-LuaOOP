-- @release 	this is the base for the object-oriented framework

-------------------------------------------------------------------------------
-- base for the object-oriented framework
-- @usage  require( "bhou.oo.base" )
-- @author  BHou
local m = {};

-- import the object class
local Object = require( 'bhou.oo.Object' );
-- import the mata object
local MetaObject = require( "bhou.oo.MetaObject" );
-- import the mata class
local MetaClass = require( "bhou.oo.MetaClass" );
-- import the mata interface
local MetaInterface = require( "bhou.oo.MetaInterface" );
-- import the util
local util = require( "bhou.oo.Util" );

-- import other libs
local rawset = rawset;
local type = type;
local setmetatable = setmetatable;
local getmetatable = getmetatable;
local setfenv = setfenv;
local _G = _G

--- create a new class
-- @param name 						the new class name
-- @param base						the base class
-- @param interfaces			the list of interfaces
-- @param clz							the class table 
function m.class( name, base, interfaces, clz  )
	if 'string' ~= type( name ) then
		return nil;
	end
	
	-- init all the default field of the new class
	local clz = clz or {};
	rawset( clz, "__isclass", true); 		-- if it is a class
	rawset( clz, "__name", name );	-- the name of the class
	rawset( clz, "__super", base or Object );		-- the super class
	rawset( clz, "__interfaces", interfaces or {}); 		-- the interfaces
	
	setmetatable( clz, MetaClass );
	
	if _G[name] == nil then
		_G[name] = clz
	end

	return clz;
end

--- create a new interface
-- @param name 						the new interface name
-- @param interfaces			the list of interfaces
-- @param intf							the interface table 
function m.interface( name, interfaces, intf  )
	if 'string' ~= type( name ) then
		return nil;
	end
	
	local intf = intf or {};
	rawset( intf, "__name", name );	-- the name of the class
	rawset( intf, "__interfaces", interfaces or {} ); 		-- the interfaces
	
	setmetatable( intf, MetaInterface );

	if _G[name] == nil then
		_G[name] = clz
	end
	
	return intf;
end
--- create an instance of a given class
-- @param class					the class to be instansiate
-- @param ...							the parameters used to init the object
function m.new( class, ... )
	if class == nil then
		return nil;
	end
	
	if class.__name == "Object" then
		return nil;
	end
	
	local o = {};
	local data = {};
	rawset( o, "__data", data);
	rawset( o, "__class", class );
	rawset( o, "__pure", true );			-- the object is pure object or being upgraded from a table
	
	class.super = class.__super;
	setmetatable( o, MetaObject );
	-- call the construct function
	o:init( ... );
	return o;
end

--- upgrade a table into an object with calling the construct
-- @param t							the table to be transformed
-- @param class					the class to be instansiate, if nil, Object will be the default class
-- @param ...							the parameters used to init the object
function m.upgrade( t, class, ... )
	local o = {};
	rawset( o, "__data", t);
	rawset( o, "__class", class or Object);
	rawset( o, "__pure", false);
	setmetatable( o, MetaObject );
	-- call the construct function in transform
	o:init( ... );
	return o;
end

--- upgrade a table into an object without calling the construct
-- @param t							the table to be transformed
-- @param class					the class to be instansiate, if nil, Object will be the default class
function m.upgradeWeak( t, class )
	local o = {};
	rawset( o, "__data", t);
	rawset( o, "__class", class or Object);
	rawset( o, "__pure", false);
	setmetatable( o, MetaObject );
	-- don't call the construct function in transform
	return o;
end

--- determine if the object is a valide plxpls style object
-- @param o	the object
function m.isValidObject( o )
	if o == nil then
		return false;
	end
	
	if o.__class == nil or o.__data == nil then
		return false;
	end
	
	if getmetatable( o ) ~= MetaObject then
		return false;
	end
	
	return true;
end

return m;