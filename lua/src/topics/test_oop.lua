

require 'lunit'

-- TODO: prototype-based vs class-based inheritance https://stackoverflow.com/questions/816071/prototype-based-vs-class-based-inheritance

-- class_a
-- We create a table to represent the class and contains its methods.
-- We also make it double as the metatable for the instances.
local class_a = {}
class_a.__index = class_a

function class_a.new(init)
    local self = setmetatable({}, class_a)

    self.value = init
    return self
end

function class_a.get_value(self)
    return self.value
end

function class_a.set_value(self, value)
    self.value = value
end

-- class_b
-- Make several improvements to make the class and call style more like C++.
local class_b = {}
class_b.__index = class_b

setmetatable(class_b, {
    __call = function(cls, ...)
        local self = setmetatable({}, class_b)
        cls.ctor(self, ...)

        return self
    end
    })

function class_b:ctor(init)
    self.value = init
end

function class_b:get_value()
    return self.value
end

function class_b:set_value(value)
    self.value = value
end

-- class_c
local class_c = {}
class_c.__index = class_c

setmetatable(class_c, {
    __call = function(cls, ...)
        local self = setmetatable({}, class_c)
        cls.ctor(self, ...)

        return self
    end,

    __index = class_b -- this is what makes the inheritance work
    })

function class_c:ctor(init_b, init_c)
    class_b.ctor(self, init_b)

    self.age = init_c
end

-- virtual functions
function class_c:set_value(value)
    self.value = value + 1
end

function class_c:get_age()
    return self.age
end

function class_c:set_age(age)
    self.age = age
end

-- class_d
-- Make several performance improvements
local class_d = {}
-- copy contents from class_b to class_d
for k, v in pairs(class_b) do
    class_d[k] = v
end
class_d.__index = class_d

setmetatable(class_d, {
    __call = function(cls, ...)
        local self = setmetatable({}, class_d)
        cls.ctor(self, ...)

        return self
    end
    })

function class_d:ctor(init_b, init_d)
    class_b.ctor(self, init_b)

    self.age = init_d
end

-- virtual functions
function class_d:set_value(value)
    self.value = value + 1
end

function class_d:get_age()
    return self.age
end

function class_d:set_age(age)
    self.age = age
end

-- general class creator
local function class(...)
    local cls, parents = {}, {...}

    -- copy base class contents to the new class
    for _, p in ipairs(parents) do
        for k, v in pairs(p) do
            cls[k] = v
        end
    end

    -- make cls itself as instance metatable
    cls.__index = cls

    setmetatable(cls, {
        __call = function(c, ...)
            local self = setmetatable({}, cls)
            if cls.ctor ~= nil then
                cls.ctor(self, ...)
            end

            return self
        end
        })

    return cls
end

-- prototype based OOP(http://lua-users.org/wiki/InheritanceTutorial)
-- base_object: table, the base object to be cloned
-- clone_object: table, an optional object to turn into a clone of base_object
-- return: table, the new clone
local function clone(base_object, clone_object)
    if type(base_object) ~= 'table' then
        return clone_object or base_object
    end

    local new_object = clone_object or {} 
    new_object.__index = base_object
    return setmetatable(new_object, new_object)
end

-- clone_object: table, the clone to check
-- base_object: table, the suspected base of clone_objecdt
-- return: boolean, clone has base in the prototype hierarchy
local function isa(clone_object, base_object)
    if type(clone_object) ~= 'table' or type(base_object) ~= 'table' then
        -- raw equal
        return clone_object == base_object
    end

    local index = clone_object.__index
    local is_a = index == base_object
    while (not is_a) and index ~= nil do
        index = index.__index
        is_a = index == base_object
    end

    return is_a
end

local object = clone(table, {clone = clone, isa = isa})

module("oop_test", lunit.testcase, package.seeall)

    function test_simple_class()
        local a = class_a.new(1)
        assert_equal(1, a:get_value())
        a:set_value(2)
        assert_equal(2, a:get_value())

        local b = class_b(5)
        assert_equal(5, b:get_value())
        b:set_value(6)
        assert_equal(6, b:get_value())
    end

    function test_simple_inheritance()
        local c = class_c(6, 5)
        assert_equal(6, c:get_value())
        assert_equal(5, c:get_age())

        c:set_value(7)
        assert_equal(8, c:get_value())
        c:set_age(6)
        assert_equal(6, c:get_age())

        local d = class_d(6, 5)
        assert_equal(6, d:get_value())
        assert_equal(5, d:get_age())

        d:set_value(7)
        assert_equal(8, d:get_value())
        d:set_age(6)
        assert_equal(6, d:get_age())
    end

    function test_class_creator()
        local class_a = class()

        function class_a:ctor(init)
            self.v = init
        end

        function class_a:get_v() return self.v end
        function class_a:set_v(v) self.v = v end

        a = class_a(10)
        assert_equal(10, a:get_v())
        a:set_v(11)
        assert_equal(11, a:get_v())

        local class_b = class(class_a)
        function class_b:ctor(init_a, init_b)
            class_a.ctor(self, init_a)
            self.v2 = init_b
        end

        function class_b:get_v2() return self.v2 end
        function class_b:set_v2(v) self.v2 = v end

        -- virtual functions
        function class_b:set_v(v)
            class_a.set_v(self, v)
            self.v = self.v + 2
        end

        b = class_b(10, 20)
        assert_equal(10, b:get_v())
        assert_equal(20, b:get_v2())
        b:set_v(11)
        b:set_v2(21)
        assert_equal(13, b:get_v())
        assert_equal(21, b:get_v2())
    end

    function test_prototype_oop()
        local a = object:clone()
        local b = object:clone()

        assert_not_equal(a, b, 'a new table is cloned')
        assert_true(a:isa(object))
        assert_true(b:isa(object))

        function a:set_v(v) self.value = v end
        function a:get_v(v) return self.value end

        a:set_v(10)
        assert_equal(10, a:get_v())

        local c = a:clone()
        assert_true(c:isa(a))
        assert_false(c:isa(b))
        assert_true(c:isa(object))
        assert_equal(10, c:get_v())
        assert_nil(rawget(c, 'value'), 'old fields are inheried from base_object')

        a:set_v(11)
        assert_equal(11, c:get_v())

        -- non table clone
        assert_equal(1, clone(1))
        assert_equal(true, clone(true))
        local t = {}
        assert_equal(t, clone(1, t))
    end
