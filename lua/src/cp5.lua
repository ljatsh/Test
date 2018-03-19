
require ("lunit")
require ("test_util")

-- Programming in Lua-->Functions
-- http://www.lua.org/pil/5.html

module ("cp5", lunit.testcase, package.seeall)

    function testMultipleReturns()
        local function f1() return 1 end
        local function f2() return 1, 2 end
        local function f3() return 1, 2, 3 end

        -- we can get all results then the call is the last(or the only) expression in a list of expressions:

        -- 1. multiple assignments
        local r1, r2, r3, r4 = f3()
        assert_equal(1, r1)
        assert_equal(2, r2)
        assert_equal(3, r3)
        assert_nil(r4, 'the return values is not sufficient')

        r1, r2, r3 = f3(), 10
        assert_equal(1, r1)
        assert_equal(10, r2, 'a function call that is not the last element in the list always produce only 1 result')
        assert_nil(r3)

        -- 2. as parameter in other calls
        test.assert_list_equal({0, 1, 2, 3}, table.pack(0, f3()))
        test.assert_list_equal({1, 0}, table.pack(f3(), 0))

        -- 3. table constructor collects all results from a call
        test.assert_list_equal({1}, {f1()})
        test.assert_list_equal({1, 2}, {f2()})
        test.assert_list_equal({1, 2, 3}, {f3()})
        test.assert_list_equal({0, 1, 2, 3}, {0, f3()})
        test.assert_list_equal({1, 10}, {f3(), 10})

        -- 4. return f() returns all values returned by f

        -- we can force a call to return exactly on result by enclosing it in an extra pair of parentheses
        local function test1()
            string.format('%d-%d', (f3()))
        end
        assert_error('string.format complains there is no sufficient arguments', test1)
    end

    function testVariableFunction()
        local function func_test(...)
            return select('#', ...), select(1, ...)
        end

        local count = func_test()
        assert_equal(0, count, 'zero arguments')

        count, p1 = func_test(1)
        assert_equal(1, count, '1 arguments')
        assert_equal(1, p1)

        count, p1, p2 = func_test(1, 'a', 'b')
        assert_equal(3, count, '3 arguments')
        assert_equal(1, p1)
        assert_equal('a', p2)
    end

    function testNamedArguments()
        local function func_test(...)
            return select(1, ...)
        end

        -- 1 special case for function call syntax:
        -- if the function has only 1 single parameter, and this argument is either a literal string
        -- or a table constructor, then the parentheses are optional.
        test.assert_list_equal({1, 2, 3}, func_test{1, 2, 3}, 'named arguments are simulated by table constructor')
    end
