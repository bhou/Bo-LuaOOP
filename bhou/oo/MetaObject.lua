-------------------------------------------------------------------------------
-- meta table for all the objects
-- @author  BHou
local mt = {};

local util = require( "bhou.oo.Util" );
local type = type;
local rawset = rawset;
local getfenv = getfenv;
local setfenv = setfenv;
local setmetatable = setmetatable;
local getmetatable = getmetatable;
local print = print;
local tostring = tostring;
local pairs = pairs;


--- determine if the object is a valide plxpls style object
--- this function is just the same as in oo.base
-- @param o	the object
local function isValidObject( o )
	if o == nil then
		return false;
	end

	if o.__class == nil or o.__data == nil then
		return false;
	end

	if getmetatable( o ) ~= mt then
		return false;
	end

	return true;
end

--- deep copy a table without metatable
-- @param	t		the table to be copied
-- @return 	the copy table
function mt.deepCopyTable( t )
	if isValidObject( t ) then
		return t;
	end

	local history = {};
	function copy( _t )
		-- find the table in the history
		for k, v in pairs( history ) do
			if k == _t then
				return v;
			end
		end

		-- create new table
		local nt = {};
		history[_t] = nt;

		for k, v in pairs( _t ) do
			if type( v ) == "table" and not isValidObject( v ) then
				nt[k] = copy( v );
			else
				nt[k] = v;
			end
		end

		return nt;
	end


	return copy( t );
end


-- control the index behavior
mt.__index = function( t, k )
	-- 1. determine if t has the __data field
	if t.__data == nil then
		return nil;
	end

	-- 2. search k in the __data field, and copy the function into the object
	local v;
	-- 2.1 search k in the __data field
	v = util.searchAll(k, {t.__data});
	if v ~= nil then
		-- 2.2 copy the function into the object
		if type( v ) == "function" then
			rawset( t, k, v );
		end
		return v;
	end

	-- 3. if k is not in the __data field
	-- 3.1 search in the __class
	v = util.searchAll(k, {t.__class});
	if v == nil then
		return nil;
	end
	if type( v ) == "function" then
		-- 3.2a copy the function into the object
		rawset( t, k, v );
	elseif type( v ) == "table" then
		-- 3.2b copy the table into __datafield
		local dv = deepCopyTable(v);
		rawset( t.__data, k, dv );
		return dv;
	else
		-- 3.2c copy the other type data into the __data field
		rawset( t.__data, k, v );
	end

	return v;
end

-- control the newindex behavior
mt.__newindex = function( t, k, v )
	-- 1. determine if t has the __data field
	if t.__data == nil then
		return;
	end

	-- 2. check the type of v
	if type( v ) == "function" then
		rawset( t, k, v );
	else
		rawset( t.__data, k, v );
	end
end

-- control the to string behavior, this will be called by lua build in tostring function
mt.__tostring = function( t )
	return t:toString();
end

return mt;
