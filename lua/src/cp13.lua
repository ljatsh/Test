
require "lunit"
require "test_util"

-- Programming in Lua: Metatables and Metamethods
-- http://www.lua.org/pil/13.html

-- 1. metamethod signature cannot be changed (returns count, sometimes return value type)
-- 2. operand order is the same as expression order
-- 3. some events support all kinds of operands(==), while others doesn't(.., +-*/, etc)

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
        assert_equal(10, mt.__newindex.age, 'assignment was forward to __index table')
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
