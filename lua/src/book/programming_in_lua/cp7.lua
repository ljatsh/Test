
require "lunit"
require "test_util"

-- Programming in Lua-->Iterators and the Generic for
-- http://www.lua.org/pil/7.html

-- 1. iterator was a function
-- 2. for semantics: one iterator with 2 parameters: invariant state and control value
-- 3. prefer stateless iterator in '''for''' statement

module("cp7", lunit.testcase, package.seeall)

    function test_iterator()
        local count = 0
        local function iter_func()
            if count == 3 then return nil end

            count = count + 1
            return count
        end

        local collections = {}
        for i in iter_func do table.insert(collections, i) end

        test.assert_list_equal({1, 2, 3}, collections)
    end

    function test_for_semantics()
        local function iter_func(collection, c)
            if c == 3 then return nil end

            return c + 1, collection
        end

        local collections = {}
        local c = {}
        for k, v in iter_func, c, 0 do
            table.insert(collections, k)
            table.insert(collections, v)
        end

        test.assert_list_equal({1, c, 2, c, 3, c},
                               collections)
    end
