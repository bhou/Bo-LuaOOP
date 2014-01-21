--- unit test for Bo-LuaOOP
-- @author BHOU

-- require 'bhou.oo' -- if you put '?.init.lua' in your lua path, you can use this to init the oo lib
require 'bhou.oo.init'	-- this will register 'oo' as a global variable
local class = oo.class	-- shortcut for class declaration
local new = oo.new			-- shortcut for new an object
local interface = oo.interface	-- shortcut for interface declaration

--[[
	util function for test
--]]
local function assertEquals(expected, value)
	assert(expected == value, "[Fail] expected '"..expected.."', but got '"..value.."'")
	print('[Pass]', expected, value)
end

local function assertNil(value)
	if value ~= nil then print( "[Fail] expected 'nil', but got '"..value.."'") return end
	print('[Pass]', nil, value)
end

--[[
	define classes and interfaces used in the test
--]]
-- define parent class, all defined in the definition
local Parent = class('Parent', nil, nil, {
	a = 1,		-- properties, can be inherited in the children
	
	add = function(self, b)
		self.a = self.a + b	
		return self.a
	end,

	minus = function(self, b)
		self.a = self.a - b	
		return self.a
	end,
	
	multiple = function(self, b)
		self.a = self.a * b	
		return self.a
	end,
	
	getA = function(self)
		return self.a
	end
})

-- define child class, put method outside of class definition
local Child = class('Child', Parent, nil, {
	b = 10;
})

function Child:add(b)	-- override parent's method
	self.a = self.a + self.b + b
	return self.a
end

function Child:add2(b)	-- use self.super to access super method
	self.a = Child.super.add(self, b) + self.b
	return self.a
end

-- define interface
local Interface = class('Interf')
function Interface:divide(b)	-- interface function without implementation
end

function Interface:divide2()	-- interface function with implementation
	self.a = self.a/2
	return self.a
end

function Interface:divide5()	-- interface function with implementation
	self.a = self.a/5
	return self.a
end

-- define child2 with interface
local Child2 = class('Child2', Parent, {Interface})
function Child2:divide(b)
	self.a = self.a/b
	return self.a
end

function Child2:divide2()
	self.a = self.a / 4
	return self.a
end

-- define GrandChild
local GrandChild = class('GrandChild', Child, {Interface})
function GrandChild:testSuperInterface()
	return GrandChild.super.divide5(self)	-- this will fail, because the super Child does not have divide5 implemented
end

local GrandChild2 = class('GrandChild', Child2, {Interface})
function GrandChild2:testSuperInterface()
	return GrandChild2.super.divide5(self)
end


--[[--------------------------------------------------------------------
	test begins here
--]]--------------------------------------------------------------------
-- create parent object
print('Parent test')
local parent = new(Parent)
assertEquals(1, parent.a)
assertEquals(1, parent:getA())
assertEquals(10, parent:add(9))
assertEquals(5, parent:minus(5))
assertEquals(25, parent:multiple(5))
assertNil(parent.b)

print('Finshed testing parent\n')

-- create child object
print('Child test')
local child = new(Child)
assertEquals(1, child.a)
assertEquals(10, child.b)
assertEquals(20, child:add(9))
assertEquals(39, child:add2(9))
assertEquals(34, child:minus(5))
assertEquals(170, child:multiple(5))

print('Finshed testing child\n')

print('Interface test')
local child2 = new(Child2)
assertEquals(1, child2.a)
assertEquals(1, child2:getA())
assertEquals(10, child2:add(9))
assertEquals(5, child2:minus(5))
assertEquals(50, child2:multiple(10))
assertEquals(2, child2:divide(25))
assertEquals(20, child2:multiple(10))
assertEquals(5, child2:divide2())	-- use child2's method, so actually divide by 4
assertEquals(1, child2:divide5())	-- use interface method implement

print('Finished testing interface\n')

print('GrandChild test')
local grandChild = new(GrandChild)	-- since grand child overrides nothing, the test is the same as the child
assertEquals(1, grandChild.a)
assertEquals(10, grandChild.b)
assertEquals(20, grandChild:add(9))
assertEquals(39, grandChild:add2(9))
assertEquals(34, grandChild:minus(5))
assertEquals(170, grandChild:multiple(5))

local grandChild2 = new(GrandChild2)	-- since grand child overrides nothing, the test is the same as the child
assertEquals(1, grandChild2.a)
assertEquals(1, grandChild2:getA())
assertEquals(10, grandChild2:add(9))
assertEquals(5, grandChild2:minus(5))
assertEquals(50, grandChild2:multiple(10))
assertEquals(2, grandChild2:divide(25))
assertEquals(20, grandChild2:multiple(10))
assertEquals(5, grandChild2:divide2())	-- use child2's method, so actually divide by 4
assertEquals(1, grandChild2:divide5())	-- use interface method implement
assertEquals(100, grandChild2:multiple(100))
assertEquals(20, grandChild2:testSuperInterface())

local reflection = require 'bhou.oo.Reflection'
local funcs = reflection.functions(grandChild)
for k, v in pairs(funcs) do
	print(k, v)
end

print('LuaOOP works well!')

os.exit(false)	-- test if this fails the travis test


