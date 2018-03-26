
require "lunit"
require "test_util"

-- temporary tests

module("cp0", lunit.testcase, package.seeall)

    -- next can used to check table is empty or not
    function test_next_function()
        assert_nil(next({}))
    end

    -- pair(t) returns next, t, nil by default
    -- pair(t) can call mt.__pair(t) and fetch its first 3 returns
    function test_pair()
        local config = {
            switch={id=1, name=2, value=3, sex=4},
            [1] = {1, 'ljatsh', 4, 'm'},
            [3] = {3, 'ljatbj', 5, 'm'},
            [5] = {5, 'ljatsz', 0, 'm'}
        }

        local mt = {}
        setmetatable(config, mt)

        local function my_next(t, index)
            k, v = next(t, index)

            if k == nil then return nil end

            if k == 'switch' then
                k, v = next(t, k)
            end

            return k, v
        end

        mt.__pairs = function(t)
            return my_next, t, nil
        end

        local t = {}
        for k, _ in pairs(config) do table.insert(t, k) end

        -- pair traverse is not stable
        table.sort(t)
        test.assert_list_equal({1, 3, 5}, t)
    end
