require "lunit"

-- Programming in Lua: Chapter2
-- http://www.lua.org/pil/2.1.html

module("cp2", lunit.testcase, package.seeall)

    function testNil()
        assert_nil(nil, 'const nil value')
        assert_nil(a, 'a was never assigned')
        local b
        assert_nil(b, 'local b was declared, but was not assigned')
        b = 1
        assert_not_nil(b, 'local b refered to value 1 now')
        b = nil
        assert_nil(b, 'local b refered to nil now')
    end

    -- false or nil was considered as false, anything else as true(including 0, '')
    function testBoolean()
        assert_true(not false, 'const false value is false')
        assert_true(not nil, 'const nil value is false')

        assert_false(not {}, 'table is true')
        assert_false(not 0, 'zero is true')
        assert_false(not '', 'empty string is true')
    end