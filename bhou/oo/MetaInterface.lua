-------------------------------------------------------------------------------
-- meta table for all the interface
-- @author  BHou
local mt = {};

local util = require( "bhou.oo.Util" );
local type = type;
local rawset = rawset;

mt.__index = function( t, k )
	-- 1. determine if t has the __super field
	if t.__interfaces == nil then
		return nil;
	end
	
	local v;
	-- 2. search the __interface class
	local v;
	v = util.searchFunction( k, t.__interfaces );
	if v ~= nil then
		rawset( t, k, v );
	end
			
	return v;
end

return mt;