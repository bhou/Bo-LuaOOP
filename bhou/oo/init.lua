---
-- util function to import the module and register to global variable
local _prefix = ''	-- prefix of the global module
local function importAs(moduleName, globalName)
	_G[_prefix..globalName] = require(moduleName)
end

importAs('bhou.oo.base', 'oo')

-- if you don't want pollut the global environment, comment the code above and uncomment the code below
-- return require 'bhou.oo.base'
