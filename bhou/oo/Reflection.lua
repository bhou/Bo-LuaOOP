--- reflection functionality
-- @author BHOU
local m = {}
local oo = require 'bhou.oo.base'

--- local function: visit class function
-- @param clz 	the class 
-- @param visitor		function( funcName, func )
local function visitClassFunction(clz, visitor)
	if clz == nil then
		return
	end
	
	for k, v in pairs(clz) do
		if type(v) == 'function' then
			visitor(k, v)
		end
	end
	
	visitClassFunction(clz.__super, visitor)
	if clz.__interfaces ~= nil then
		for k, v in ipairs(clz.__interfaces) do
			visitClassFunction(v, visitor)
		end
	end
end

--- list all the available function
-- @param o		an oo object 
function m.functions(o)
	if not oo.isValidObject(o) then
		return 'Not a valid object'
	end
	
	local buf = {}
	
	for k, v in pairs(o) do
		if type(v) == 'function' then
			if buf[k] == nil then
				buf[k] = v
			end
		end
	end
	
	local function visitor( name, func )
		if buf[name] == nil then
			buf[name] = func
		end
	end
	
	visitClassFunction(o.__class, visitor)
	
	return buf
end

return m