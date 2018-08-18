-- Programming in Lua: Metatables and Metamethods
-- http://www.lua.org/pil/13.html

-- 1. metamethod signature cannot be changed (returns count, sometimes return value type)
-- 2. operand order is the same as expression order
-- 3. some events support all kinds of operands(==), while others doesn't(.., +-*/, etc)

local helper = require('helper')

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

  --- other arithmetic events are omited (__div, __mod, __unm, __pow)
  -- bitwise events are ommited too (__band, __bor, __bxor, __bnot, __shl, __shr)

  it('length', function()
    local mt = { __len = function(...) end }
    local obj = setmetatable({}, mt)

    local s = spy.on(mt, '__len')
    assert.is_nil(#obj, '__len can return anything')
    assert.spy(s).was.called(1)
    -- 'TODO, why are there two parameters?'
    assert.spy(s).was.called_with(obj, obj)
  end)

  it('concat', function()
    local expects = {
      {'1', '2', '12'}, {'1', 2, '12'},
      {1, '2', '12'}, {1, 2, '12'}
    }

    -- By default, operands of .. operator are strings or that which can be converted to strings
    for _, v in ipairs(expects) do
      assert.are.same(v[3], v[1] .. v[2])
    end

    local mt = {
      __tostring = function(...) return '__tostring' end
    }

    local obj = setmetatable({}, mt)
    assert.has.error.match(function() return 1 .. obj end, 'attempt to concatenate a table value', 'it seems lua converts only numbers by default')

    mt.__concat = function(...) end
    local s = spy.on(mt, '__concat')
    assert.is_nil(1 .. obj)
    assert.spy(s).was.called(1)
    assert.spy(s).was.called_with(1, obj)
  end)

  -- TODO spy.on cannot be applied to metamethods __index, __newindex and __call
  it('index', function()
    local mt = {
      __index = function(...) return select(2, ...) end
    }
    local obj = setmetatable({'ljatsh', age=34}, mt)

    -- __index can be a function, and it was only queried when table field does not exist
    assert.are.same('ljatsh', obj[1])
    assert.are.same(34, obj.age)
    assert.are.same('addr', obj.addr)
    assert.are.same(3, obj[3])

    -- __index can also be a table
    obj = setmetatable({}, {__index = obj})
    assert.are.same('ljatsh', obj[1])
    assert.are.same(34, obj.age)
    assert.are.same('addr', obj.addr)
    assert.are.same(3, obj[3])
  end)

  it('newindex', function()
    local t = {}
    local mt = {
      __newindex = function(...) table.insert(t, table.pack(...)) end
    }
    local obj = setmetatable({name='ljatsh', age=34}, mt)

    -- __newindex was only queries when table key does not exist. it can be a function
    obj.age = 35
    assert.are.same(0, #t)
    obj.sex = 'm'
    assert.are.same({obj, 'sex', 'm', n=3}, t[1])

    -- __newindex can also be a table
    local obj2 = setmetatable({where='sh'}, {__newindex = obj})
    obj2.where = 'xa'
    assert.are.same(1, #t)
    obj2.name = 'ljatxa'
    assert.is_nil(rawget(obj2, 'name'))
    assert.are.same('ljatxa', obj.name, '__newindex was forwarded to the new table')
    assert.are.same(1, #t)
    obj.from = 'CN'
    assert.are.same({obj, 'from', 'CN', n=3}, t[2], 'table object changed when it passed the chain')
  end)

  it('call', function()
    local mt = {
      __call = function(...) return table.pack(...) end
    }
    
    local obj = {}
    assert.has.error.match(function() return obj() end, 'attempt to call a table value')
    setmetatable(obj, mt)
    assert.are.same({obj, 1, 2, n=3}, obj(1, 2))
  end)
end)

--[[

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
]]
