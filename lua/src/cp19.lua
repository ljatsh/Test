
require "lunit"
require "util"
require "test_util"

-- Programming in Lua: Chapter19-->The Table Library
-- http://www.lua.org/pil/19.1.html

module("cp19", lunit.testcase, package.seeall)

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
        test.assert_list_equal({0, 1}, a, 'a={0, 1}')

        table.insert(a, 2, 3)
        test.assert_list_equal({0, 3, 1}, a, 'a={0, 3, 1}')
    end

    function testRemove()
        a = {1, 2, 3, 4}
        assert_equal(2, table.remove(a, 2), 'value 2 was removed from a')
        test.assert_list_equal({1, 3, 4}, a, 'a[2] was removed')

        assert_equal(4, table.remove(a), 'last element was removed by default')
        test.assert_list_equal({1, 3}, a, 'last element was removed by default')

        -- 0 position
        assert_error('position out of bounds', handler2(table.remove, a, 0))
        assert_pass('0 postion can be specified if #list=0', handler2(table.remove, {}, 0))

        -- #list+1 postion
        assert_equal(3, table.remove(a), '#list+1 == #list')
        test.assert_list_equal({1}, a, 'the last element was erased')

        assert_error('other position is invalid', handler2(table.remove, a, 3))
    end

    function testPack()
        a = table.pack(1, 2, 3)
        test.assert_list_equal({1, 2, 3}, a)
        assert_equal(3, a.n)

        p1, p2, p3 = table.unpack(a)
        assert_equal(1, p1)
        assert_equal(2, p2)
        assert_equal(3, p3)
    end

-------------------------------------------------------------- TODO
-- move following block to cp5.lua
    function testVariableFunction()
        local function test(...)
            return select('#', ...), select(1, ...)
        end

        local count = test()
        assert_equal(0, count, 'zero arguments')

        count, p1 = test(1)
        assert_equal(1, count, '1 arguments')
        assert_equal(1, p1)

        count, p1, p2 = test(1, 'a', 'b')
        assert_equal(3, count, '3 arguments')
        assert_equal(1, p1)
        assert_equal('a', p2)
    end

    function testNamedArguments()
        local function test(...)
            return select(1, ...)
        end

        -- 1 special case for function call syntax:
        -- if the function has only 1 single parameter, and this argument is either a literal string
        -- or a table constructor, then the parentheses are optional.
        assert_list_equal({1, 2, 3}, test{1, 2, 3}, 'named arguments are simulated by table constructor')
    end

-- move following block to cp6.lua
    function testClosure()
        function test1(t)
            return function(x) table.insert(t, x) end
        end

        local t = {}
        local c1 = test1(t)
        local c2 = test1(t)
        assert_list_equal({}, t)
        c1(1)
        c1(2)
        assert_list_equal({1, 2}, t, 't was referred by the closure c1')
        c2('a')
        assert_list_equal({1, 2, 'a'}, t, 't was also referred by the closure c2')

        function test2()
            local t = {}
            return function(x) table.insert(t, x); return t end
        end

        c1 = test2()
        c2 = test2()

        local t1 = c1(2)
        local t2 = c2('a')

        assert_list_equal({2}, t1, 't1 and t2 are different objects')
        assert_list_equal({'a'}, t2, 't1 and t2 are different objects')
    end

    function testNonGlobalFunctions()
        local test1 = function(n)
            if n == 0 then
                return 1
            else
                return n * test1(n - 1)
            end
        end

        local test2
        test2 = function(n)
            if n == 0 then
                return 1
            else
                return n * test2(n - 1)
            end
        end

        -- This is the way Lua expands its syntactic sugar for local functions
        local function test3(n)
            if n == 0 then
                return 1
            else
                return n * test3(n - 1)
            end
        end

        assert_error('recursive calling of test is global', handler1(test1, 10))
        assert_pass('forward declarations can solve the recursive buggy', handler1(test2, 10))
        assert_pass('the suggest way to solve the recursive buggy', handler1(test3, 10))
    end