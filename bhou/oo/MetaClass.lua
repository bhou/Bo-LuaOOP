-------------------------------------------------------------------------------
-- meta table for all the class
-- @author  BHou
local mt = {};

local util = require( "bhou.oo.Util" );
local type = type;
local rawset = rawset;
local getfenv = getfenv;
local setfenv = setfenv;
local setmetatable = setmetatable;
local print = print;

setfenv( 1, mt );

__index = function( t, k )
	-- 1. determine if t has the __super field
	if t.__super == nil then
		return nil;
	end
	
	local v;
	-- 2. search the __super class
	v = util.searchAll(k, {t.__super});
			
	if v == nil then
		-- 3. search the __interfaces for function
		v = util.searchFunction(k, t.__interfaces); 
	end
			
	if v ~= nil then
		rawset( t, k, v );
	end
			
	return v;
end

__newindex = function( t, k, v )
	if t.__super ~= nil and type( v ) == "function" then
		-- reset the function v's env to support super
		local oldenv = getfenv( v );
		local newenv = setmetatable(
			{super = t.__super},
			{__index = oldenv, __newindex = oldenv} );
		setfenv( v, newenv );
	end
	
	rawset(t, k, v);
end

__eq = function( t1, t2 )
	if t1 == nil or t2 == nil then
		return false;
	end
	
	if t1.__name == nil or t2.__name == nil then
		return false;
	end
	
	return t1.__name == t2.__name;
end

return mt;