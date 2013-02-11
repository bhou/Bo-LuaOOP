-------------------------------------------------------------------------------
-- utils for all the oo
-- @author  BHou
local m = {};

local table = table;
local type = type;
local pairs = pairs;
local print = print;
local rawset = rawset;
local setmetatable = setmetatable;
local setfenv = setfenv;
local getfenv = getfenv;


setfenv( 1, m );

-- search all in the table
function searchAll( k, plist )
	local i,v;
	for i = 1, table.getn( plist ) do
		v = plist[i][k];
		if v then return v end;
	end
end

-- search all functions in the table
function searchFunction( k, plist )
	local i,v;
	for i = 1, table.getn( plist ) do
		v = plist[i][k];
		if 'function' == type(v) then return v end;
	end
end

-- search all elements in the table
function searchElement( k, plist )
	local i,v;
	for i = 1, table.getn( plist ) do
		v = plist[i][k];
		if 'function' ~= type(v) and 'nil' ~= type(v) then return v end;
	end
end

-- copy a table
function copyTable( dest, src )
	if 'table' ~= type(src) or 'table' ~= type( dest ) then
		return nil;
	end

	local k,v;
	for k,v in pairs(src) do
		dest[k] = v;
	end

	return dest;
end


-- print a table
function printTable( src )
	if 'table' ~= type(src) then
		return nil;
	end

	local k,v;
	for k,v in pairs(src) do
		print( k, v );
	end

	return dest;
end

return m;
