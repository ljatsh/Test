

require 'lunit'

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

local function class(...)

    local self

    return self
end

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
    end