
require "lunit"
require "util"

-- Programming in Lua: Chapter19-->The Table Library
-- http://www.lua.org/pil/19.1.html

module("cp19", lunit.testcase, package.seeall)

    function assert_list_equal(expected, actual)
        for k, v in ipairs(expected) do
            assert_equal(v, actual[k])
        end

        for k, v in ipairs(actual) do
            assert_equal(v, expected[k])
        end
    end

    function testArraySize()
        -- 先不要取纠结table的长度操作符了，很让人费解，后续避免取使用这个属性
        -- http://lua-users.org/wiki/LuaTableSize
        --assert_equal(4, #{1, 0, nil, 2}, 'array ends just before its first nil element')
    end

    function testConcat()
        assert_equal('a b c', table.concat({'a', 'b', 'c'}, ' '))
        assert_equal('a b 1', table.concat({'a', 'b', '1'}, ' '))
        assert_error('table elements must be string or number', handler1(table.concat, {'a', {}}))
    end

    function testInsert()
        a = {}
        table.insert(a, 1)

        assert_equal(1, a[1], 'a={1}')

        table.insert(a, 1, 0)
        assert_list_equal({0, 1}, a, 'a={0, 1}')

        table.insert(a, 2, 3)
        assert_list_equal({0, 3, 1}, a, 'a={0, 3, 1}')
    end
