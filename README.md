Introduction
------------

Bo-Lua OOP is a Java-like Lua Object Oriented Programming (OOP) implementation. 
Its purpose is to give the power of the Object-Oriented Programming to Lua and at the same time 
to keep itself as simple as possible, because of this, not all the Object-Oriented Programming features 
are supported by Bo-Lua OOP. Unlike the other Lua OOP implementation, Bo-Lua OOP enables multple 
inheritance through interface, which is from the concept of Java. The implemented features of Bo-Lua 
OOP are listed below:

###OOP features

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

###Other features

- Super: **supported**
- Instanceof: **supported**
- GetClassName: **supported**

###Todo list
- Reflection support
- Utils Classes

###Lua version
Currently supports Lua 5.2.x and 5.1.x


Usage
-----------
copy the directory **bhou/oo/*** to your lua path,

to load the module, use
`````lua
local oo = require("bhou.oo.base")
`````
this way does not pollute the global table. 

if you include ?/init.lua to your lua path, you can load the module by using
`````lua
require 'bhou.oo'
`````
This way will automatically register a global table 'oo', more details see init.lua

Document
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

oo.interface("InterfaceC", {InterfaceA, InterfaceB})
function InterfaceC:interfaceCFunction()
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
  SubClass.super.add(self, b)    -- call super method
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
### upgrade
upgrade is a feature to turn a normal lua table into an object, which gives the table 
oop ability and meanwhile keep its own data.

There are two kinds of upgrade. One is strong upgrade, which will call the constructor 
of the class that you want your table turns to. Another one is weak upgrade, which does
not call the constructor

to turn a table, let's say *t* into an object of class *ClassA*, we can do:
`````lua
local t = {
  v1 = 100,
  v2 = 200,
  ... -- any thing you want to be in the table
}

local upgradedT = oo.upgrade(t, ClassA, ... --[[constructor arguments for ClassA--]])
-- now you can call any instance method defined in ClassA on upgradedT
upgradedT:instanceMethod()
-- or you can call method/variable defined in table t
print(upgradedT.v1)
`````
or we can use weak upgrade (no constructor called to initiate the object)
`````lua
local wt = {
  v1 = 100,
  v2 = 200,
  ... -- any thing you want to be in the table
}

local upgradedWT = oo.upgradeWeak(wt, ClassA) -- no constructor arguments
-- now you can call any instance method defined in ClassA on upgradedT
upgradedWT:instanceMethod()
-- or you can call method/variable defined in table wt
print(upgradedWT.v1)
``````

### Reflection
Since any object/class is a table as well, you can access any function, data in the object/class. A util module is provided to help you access some meta information of the object/class/interface. To use it, require it by :

`````lua
local reflection = require 'bhou.oo.Reflection'
`````

Currently there is only one method in reflection module: ***functions***, which returns a list of name-function pair of the object, including the functions of its ancestor. See the end of the test.lua

`````lua
reflection.functions(obj)
`````


