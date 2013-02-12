local oo = require("bhou.oo.base")

require("testInherit")

--[[
define a class
--]]

-- a simple class 
ClassA = oo.class("ClassA")

ClassA.D = 100

-- define ClassA's constructor
function ClassA:init(c)
	-- attribute
	self.result = 0
	self.c = c
end

-- instance method
function ClassA:add(a, b)
	self.result = a + b + self.c
end

function ClassA:print()
	print(self.result)
end

function ClassA:printD()
	print(ClassA.D)		-- access the static attribute
end


--[[
run the test 
--]]

-- create an instance of ClassA
local objA = oo.new(ClassA, 10)
objA:add(1, 5)
objA:print()		-- result should be 16
objA:printD()		-- result should be 100
print(ClassA.D)		-- output should be 100


-- test base class
local baseObject = oo.new(BaseClass, 1)
baseObject:double()	
baseObject:print()		-- output should be 2

-- test child class
local childObject = oo.new(ChildClass, 1)
childObject:double()
childObject:print()		-- output should be 4

print(childObject.a) 	-- output should be 4
print(childObject.c)	-- output should be nil


-- test interface
childObject:divide(2)
childObject:print()		-- output should be 2
childObject:add(100)
childObject:print()		-- output should be 102


-- test build-in method
print(baseObject:getClassName())	-- output should be BaseClass
print(childObject:getClassName())	-- output should be ChildClass

print(baseObject:instanceof(BaseClass))		-- output should be true
print(childObject:instanceof(BaseClass))		-- output should be true
print(childObject:instanceof(ChildClass))		-- output should be true

print(baseObject:toString())	-- output name should be class name
print(childObject:toString())	-- output name should be class name

