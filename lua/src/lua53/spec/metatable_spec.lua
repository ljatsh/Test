-- Programming in Lua: Metatables and Metamethods
-- http://www.lua.org/pil/13.html

-- 1. metamethod signature cannot be changed (returns count, sometimes return value type)
-- 2. operand order is the same as expression order
-- 3. some events support all kinds of operands(==), while others doesn't(.., +-*/, etc)

describe("metatable", function()
  it('arithmetic - add', function()
    local expects = {
      {1, 10.1, 11.1}, {1, '10.1', 11.1},
      {'1', 10.1, 11.1}, {'1', '10.1', 11.1}
    }

    -- By default, operands of + operator are numbers or that which can be converted to numbers
    for _, v in ipairs(expects) do
      assert.are.same(v[3], v[1] + v[2])
    end

    assert.has.error.match(function() return 1 + true end, 'attempt to perform arithmetic on a boolean value')
    assert.has.error.match(function() return 1 + 'true' end, 'attempt to perform arithmetic on a string value')

    local mt1 = { __add = function(...) end }
    local mt2 = { __add = function(...) end }
    local obj1 = setmetatable({}, mt1)
    local obj2 = setmetatable({}, mt2)

    local s1 = spy.on(mt1, '__add')
    local s2 = spy.on(mt2, '__add')

    -- + operator choose __add event from left to right
    assert.is_nil(obj1 + obj2)
    assert.spy(s1).was.called(1)
    assert.spy(s2).was.no.called()
    assert.spy(s1).was.called_with(obj1, obj2)

    s1:clear()
    s2:clear()

    assert.is_nil(obj2 + obj2)
    assert.spy(s2).was.called(1)
    assert.spy(s2).was.called_with(obj2, obj1)
    assert.spy(s1).was.no.called()

    assert.has.no.error(function() return 1 + obj1 end)
    assert.has.no.error(function() return 'a' + obj1 end)
  end)

  it('arithmetic - sub', function()
    local expects = {
      {11.1, 1, 10.1}, {11.1, '1', 10.1},
      {'11.1', 1, 10.1}, {'11.1', '1', 10.1}
    }

    -- By default, operands of - operator are numbers or that which can be converted to numbers
    for _, v in ipairs(expects) do
      assert.are.same(v[3], v[1] - v[2])
    end

    assert.has.error.match(function() return 1 - true end, 'attempt to perform arithmetic on a boolean value')
    assert.has.error.match(function() return 1 - 'true' end, 'attempt to perform arithmetic on a string value')

    local mt1 = { __sub = function(...) end }
    local mt2 = { __sub = function(...) end }
    local obj1 = setmetatable({}, mt1)
    local obj2 = setmetatable({}, mt2)

    local s1 = spy.on(mt1, '__sub')
    local s2 = spy.on(mt2, '__sub')

    -- - operator choose __sub event from left to right
    assert.is_nil(obj1 - obj2)
    assert.spy(s1).was.called(1)
    assert.spy(s2).was.no.called()
    assert.spy(s1).was.called_with(obj1, obj2)

    s1:clear()
    s2:clear()

    assert.is_nil(obj2 - obj2)
    assert.spy(s2).was.called(1)
    assert.spy(s2).was.called_with(obj2, obj1)
    assert.spy(s1).was.no.called()

    assert.has.no.error(function() return 1 - obj1 end)
    assert.has.no.error(function() return 'a' - obj1 end)
  end)

  it('arithmetic - mul', function()
    local expects = {
      {11.1, 2, 22.2}, {11.1, '2', 22.2},
      {'11.1', 2, 22.2}, {'11.1', '2', 22.2}
    }

    -- By default, operands of * operator are numbers or that which can be converted to numbers
    for _, v in ipairs(expects) do
      assert.are.same(v[3], v[1] * v[2])
    end

    assert.has.error.match(function() return 1 * true end, 'attempt to perform arithmetic on a boolean value')
    assert.has.error.match(function() return 1 * 'true' end, 'attempt to perform arithmetic on a string value')

    local mt1 = { __mul = function(...) end }
    local mt2 = { __mul = function(...) end }
    local obj1 = setmetatable({}, mt1)
    local obj2 = setmetatable({}, mt2)

    local s1 = spy.on(mt1, '__mul')
    local s2 = spy.on(mt2, '__mul')

    -- * operator choose __mul event from left to right
    assert.is_nil(obj1 * obj2)
    assert.spy(s1).was.called(1)
    assert.spy(s2).was.no.called()
    assert.spy(s1).was.called_with(obj1, obj2)

    s1:clear()
    s2:clear()

    assert.is_nil(obj2 * obj2)
    assert.spy(s2).was.called(1)
    assert.spy(s2).was.called_with(obj2, obj1)
    assert.spy(s1).was.no.called()

    assert.has.no.error(function() return 1 * obj1 end)
    assert.has.no.error(function() return 'a' * obj1 end)
  end)

  it('arithmetic - div', function()
    local expects = {
      {22.2, 2, 11.1}, {22.2, '2', 11.1},
      {'22.2', 2, 11.1}, {'22.2', '2', 11.1}
    }

    -- By default, operands of / operator are numbers or that which can be converted to numbers
    for _, v in ipairs(expects) do
      assert.are.same(v[3], v[1] / v[2])
    end

    assert.has.error.match(function() return 1 / true end, 'attempt to perform arithmetic on a boolean value')
    assert.has.error.match(function() return 1 / 'true' end, 'attempt to perform arithmetic on a string value')

    local mt1 = { __div = function(...) end }
    local mt2 = { __div = function(...) end }
    local obj1 = setmetatable({}, mt1)
    local obj2 = setmetatable({}, mt2)

    local s1 = spy.on(mt1, '__div')
    local s2 = spy.on(mt2, '__div')

    -- / operator choose __div event from left to right
    assert.is_nil(obj1 / obj2)
    assert.spy(s1).was.called(1)
    assert.spy(s2).was.no.called()
    assert.spy(s1).was.called_with(obj1, obj2)

    s1:clear()
    s2:clear()

    assert.is_nil(obj2 / obj2)
    assert.spy(s2).was.called(1)
    assert.spy(s2).was.called_with(obj2, obj1)
    assert.spy(s1).was.no.called()

    assert.has.no.error(function() return 1 / obj1 end)
    assert.has.no.error(function() return 'a' / obj1 end)
  end)

  
end
)

--[[

module("cp13", lunit.testcase, package.seeall)

local _mt

function setup()
    _mt = {}
end

function teardown()
    _mt = nil
end

function create_obj()
    local obj = {}
    setmetatable(obj, _mt)

    return obj
end

function test_arithmetic_methods()
    local obj1 = create_obj()
    local obj2 = create_obj()

    _mt.__add = function (...) return table.pack('__add', ...) end
    _mt.__sub = function (...) return table.pack('__sub', ...) end
    _mt.__mul = function (...) return table.pack('__mul', ...) end
    _mt.__div = function (...) return table.pack('__div', ...) end
    _mt.__mod = function (...) return table.pack('__mod', ...) end
    _mt.__unm = function (...) return table.pack('__unm', ...) end

    assert_error('By default, add event can only occurr between values which can be converted to number(tonumber)',
                    function() return 1 + 'a' end)
    assert_equal(11, 1+'10', 'By default, add event can only occurr between values which can be converted to number(tonumber)')
    assert_equal(11, '1'+'10', 'By default, add event can only occurr between values which can be converted to number(tonumber)')
    assert_error('By default, add event can only occurr between values which can be converted to number(tonumber)',
                    function() return 1 + true end)

    test.assert_list_equal({'__add', 1, obj1}, 1+obj1, 'operand order is the same as expression order')
    test.assert_list_equal({'__add', obj1, 1}, obj1+1, 'operand order is the same as expression order')
    test.assert_list_equal({'__add', obj1, obj2}, obj1+obj2)

    test.assert_list_equal({'__sub', 1, obj1}, 1-obj1)
    test.assert_list_equal({'__mul', 3, obj1}, 3 * obj1)
    test.assert_list_equal({'__div', obj1, 0}, obj1/0)
    test.assert_list_equal({'__mod', obj2, 3}, obj2%3)

    -- TODO: unary operation
    -- print(1+(-obj1))
end

function test_length_method()
    local obj1 = create_obj()

    _mt.__len = function (...) return table.pack('__len', ...) end

    test.assert_list_equal({'__len', obj1, obj1},
                            #obj1,
                            'this test may fail on lua which version is different from v5.2')
end

function test_concat_method()
    local obj1 = create_obj()
    local obj2 = create_obj()

    _mt.__concat = function (...) return table.pack('__concat', ...) end

    assert_equal('12', 1 .. '2', 'By default, concat event can only occurr between strings, string and number, or number and string, or number and number')
    assert_equal('12', '1' .. '2', 'By default, concat event can only occurr between strings, string and number, or number and string, or number and number')
    assert_equal('12', '1' .. 2, 'By default, concat event can only occurr between strings, string and number, or number and string, or number and number')
    assert_equal('12', 1 .. 2, 'By default, concat event can only occurr between strings, string and number, or number and string, or number and number')

    test.assert_list_equal({'__concat', 1, obj1}, 1 .. obj1)
end

function test_comparision_methods()
    local obj1 = create_obj()
    local obj2 = create_obj()
    local obj3 = {}
    local mt = {}
    setmetatable(obj3, mt)
    mt.__eq = function(...) return false end
    mt.__lt = function(...) return true end

    _mt.__eq = function(...) return true end
    _mt.__lt = function(...) return false end

    assert_false(1 == 2, 'primitive equal test')
    assert_false(1 == '1', 'primitive equal test')
    assert_false(1 == true, 'primitive equal test')
    assert_false(obj1 == 1, 'primitive equal test')
    assert_true(obj1 == obj1, 'primitive equal test')
    assert_false(obj1 == obj3, 'primitive equal test')

    assert_true(obj1 == obj2, 'customized equality test occurrs between tables(userdata) with the same metatable')

    assert_error('lt can not occurr between primitives with different types',
                    function() return 1 < '1' end)
    assert_error('lt can not occurr between primitives with different types',
                    function() return 1 < true end)
    assert_error('lt can not occurr between primitives with different types',
                    function() return 1 < function()end end)
    assert_error('lt cannot occurr between tables with out metatable',
                    function() return {} < {} end)

    assert_false(1 < obj1 and obj1 < 1)
    assert_false(obj1 < obj1)
    assert_false(obj1 < obj2 and obj2 < obj1)
    assert_true(not (obj1 < obj3) and obj3 < obj1)
end

function test_index_methods()
    local obj = {2, 3, name='ljatsh', 4}
    assert_equal(2, obj[1])
    assert_equal(3, obj[2])
    assert_equal(4, obj[3])
    assert_equal('ljatsh', obj.name)

    assert_nil(obj.age)

    local mt = {}
    mt.__index = {age=34}
    setmetatable(obj, mt)
    assert_equal(34, obj.age, 'age was picked from __index')

    mt.__index = function(...) return table.pack(...) end
    test.assert_list_equal({obj, 'age'}, obj.age, '__index can also be function')

    obj = {}
    assert_nil(obj.age)
    obj.age = 10
    assert_equal(10, obj.age)
    mt = {}
    mt.__newindex = {}
    obj.age = nil
    setmetatable(obj, mt)
    obj.age = 10
    assert_equal(10, mt.__newindex.age, 'assignment was forward to __newindex table')
    assert_nil(obj.age)

    local result
    mt.__newindex = function(...) result = table.pack(...) end
    obj.age = 10
    test.assert_list_equal({obj, 'age', 10}, result, '__newindex can also be function')
end

function test_call_method()
    local obj = create_obj()

    assert_error('table cannot be callable by default',
                    function() obj(1, 2, 3) end)

    _mt.__call = function(...) return table.pack(...) end
    test.assert_list_equal({obj, 1, 2, 3}, obj(1, 2, 3), 'obj can be called now')
end
]]
