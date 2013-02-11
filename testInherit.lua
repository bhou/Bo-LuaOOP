local oo = require("bhou.oo.base")

--[[
Define a base class
this is an compact way to create a class
--]]
BaseClass = oo.class("BaseClass", nil, nil, { -- by default inherited from Object class and no interfaces
	a = 10,

	init = function(self, a)	-- note the self is mandatory in this case
		self.a = a
		end,	-- note the ',' is mandatory in this case

	double = function(self)
		self.a = self.a * 2
		end,

	print = function(self)
		print(self.a)
		end,
})

--[[
define an interface
--]]
MyInterface = oo.interface("MyInterface", nil, {
	c = 100, 		-- this will not be inherited by the subclass
	divide = function(self, b)
		end,
	add = function(self, b)
		end,
	})



--[[
Define a child class
--]]
ChildClass = oo.class("ChildClass", BaseClass, {MyInterface})

function ChildClass:init(a)
	self.a = a + 1
end

function ChildClass:double()
	self.a = self.a * 2
end

function ChildClass:print()
	super.print(self)	-- call super class
end

function ChildClass:divide(b)
	self.a = self.a/b
end

function ChildClass:add(b)
	self.a = self.a + b
end