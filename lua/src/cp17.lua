
require "lunit"
require "util"

-- Programming in Lua: Chapter17-->Weak Tables
-- http://www.lua.org/pil/17.html


module("cp17", lunit.testcase, package.seeall)

    function testWeakTable()
        v = {}
        mt = {}
        setmetatable(v, mt)
        mt.__mode = 'k'

        key = {}
        v[key] = 1
        key = {}
        v[key] = 2

        assert_equal(2, table.len(v), 'v contains 2 entries')

        collectgarbage()
        assert_equal(1, table.len(v), 'v contains only 1 entry now')
        assert_equal(2, v[key], 'the first key was collected')

        v[2] = {}
        collectgarbage()
        assert_equal(2, table.len(v), 'v contains 2 entries again')
        mt.__mode = 'v'

        collectgarbage()
        assert_equal(1, table.len(v), 'v contains only 1 entry again')
        assert_nil(v[2], 'value associated with key 2 was collected')
    end