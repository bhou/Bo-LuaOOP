Introduction
============

Bo-Lua OOP is a Java-like Lua Object Oriented Programming (OOP) implementation. 
Its purpose is to give the power of the Object-Oriented Programming to Lua and at the same time 
to keep itself as simple as possible, because of this, not all the Object-Oriented Programming features 
are supported by Bo-Lua OOP. Unlike the other Lua OOP implementation, Bo-Lua OOP enables multple 
inheritance through interface, which is from the concept of Java. The implemented features of Bo-Lua 
OOP are listed below:

OOP features
============

- Objects and Classes: **supported**
- Encapsulation: *not supported*
- Inheritance: **multiple inheritance through interface**
- Virtual method: **supported**
- Constructor/Destructor: **supported**
- Abstract Methods and Classes: **supported**
- Interfaces: **supported**
- Method Overloading: *not supported, but could be easily implemented*
- Operator Overloading: *not supported, but could be easily implemented*
- Properties Exceptions: *not supported*

Usage
-----------
### Create interface
`````lua
local oo = require("bhou.oo.base")
oo.interface("InterfaceA", nil)
function InterfaceA:interfaceAFunction()
end

oo.interface("InterfaceB", nil)
function InterfaceB:interfaceBFunction()
end
`````

###Create a class

`````lua
local oo = require("bhou.oo.base")

oo.class("ClassName", BaseClase, {InterfaceA, InterfaceB})  -- ClassName is automatically registered as global variable

ClassName.STATIC_VARIABLE = "static"

-- constructor
function ClassName:init(a)
  self.a = a
end

function ClassName:add(b)
  self.a = self.a + b
end

function ClassName:print()
  print(self.a)
end

-- inherited from interface A
function ClassName:interfaceAFunction()
  print("interface A")
end

-- inherited from interface B
function ClassName:interfaceBFunction()
  print("interface B")
end

-- static method
function ClassName.printUsage()  
  print("usage")
end
`````
### Compact way to define a class
`````lua
local oo = require("bhou.oo.base")
oo.class("ClassName", BaseClass, {InterfaceA, InterfaceB}, {
  a = 100;    -- ',' is ok as well
  init = function(self, a)
        self.a = a
      end,
  add = function(self, b)
        self.a = self.a + b
      end,
  printUsage = function()   -- no self as arguement for static method
        print("usage")
      end,
  interfaceAFunction = function(self)
        print("interface A")
      end,
  interfaceBFunction = function(self)
        print("interface B")
      end,
})
`````
### Create sub class
`````lua
local oo = require("bhou.oo.base")
oo.class("SubClass", ClassName)
function SubClass:init(a)
  self.a = a + 1
end

function SubClass:add(b)
  self.a = self.a + 1
  super.add(self, b)    -- call super method
end

function SubClass:divide(b)
  self.a = self.a / b
end
`````

### create object
`````lua
local oo = require("bhou.oo.base")
local obj = oo.new(SubClass, 100)
obj:print() -- 101, automatically call the parent's method if not defined in subclass
obj:add(5)
obj:print() -- 107
`````
### object build-in method
`````lua
obj:getClassName()  -- "SubClass"
obj:instanceof(SubClass)    -- true
obj:instanceof(ClassName)   -- true
obj:toString()      -- return class name "SubClass"
`````
