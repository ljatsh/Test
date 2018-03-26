
require "lunit"
require "test_util"

-- Programming in Lua--> More about functions
-- http://www.lua.org/pil/6.html

module ("cp6", lunit.testcase, package.seeall)

    function testClosure()
        function test1(t)
            return function(x) table.insert(t, x) end
        end

        local t = {}
        local c1 = test1(t)
        local c2 = test1(t)
        test.assert_list_equal({}, t)
        c1(1)
        c1(2)
        test.assert_list_equal({1, 2}, t, 't was referred by the closure c1')
        c2('a')
        test.assert_list_equal({1, 2, 'a'}, t, 't was also referred by the closure c2')

        function test2()
            local t = {}
            return function(x) table.insert(t, x); return t end
        end

        c1 = test2()
        c2 = test2()

        local t1 = c1(2)
        local t2 = c2('a')

        test.assert_list_equal({2}, t1, 't1 and t2 are different objects')
        test.assert_list_equal({'a'}, t2, 't1 and t2 are different objects')
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