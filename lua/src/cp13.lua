
require "lunit"
require "test_util"

-- Programming in Lua: Metatables and Metamethods
-- http://www.lua.org/pil/13.html

-- 1. metamethod signature cannot be changed
-- 2. operand order is the same as expression order

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

