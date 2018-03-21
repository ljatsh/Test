
require "lunit"
require "test_util"

-- Programming in Lua-->Coroutines
-- http://www.lua.org/pil/9.html

-- 1. resume-yield pair can exchange data between caller and the callee(consumer and producer).
-- 2. coroutine was run under protected mode.

module("cp9", lunit.testcase, package.seeall)

    function test_data_exchange()
        local function test_func(x, y)
            local sum = x + y
            local diff = x - y

            local value = coroutine.yield(sum, diff)

            return value, 'return'
        end


        co = coroutine.create(test_func)
        test.assert_list_equal({true, 15, 5},
                              table.pack(coroutine.resume(co, 10, 5)),
                              'resume params were passed to coroutine and yield params were resume returns')
        test.assert_list_equal({true, 'ljatsh', 'return'},
                               table.pack(coroutine.resume(co, 'ljatsh')),
                               'return values of the coroutine were the resume returns')
    end

    function test_error()
        local function test_func()
            local a
            a.name = 'ljatsh'
        end

        co = coroutine.create(test_func)
        r, error = coroutine.resume(co)
        assert_false(r)
        assert_not_nil(error)
    end

    function test_producer_consumer_pattern()
        local function consume(producer)
            local collections = {}

            while true do
                local _, data = coroutine.resume(producer)

                if data == '\0' then
                    break
                end

                table.insert(collections, data .. '__end')
            end

            return collections
        end

        local function produce()
            for _, v in ipairs({'x', 'y', 'z', '\0'}) do
                coroutine.yield(v)
            end
        end

        local function producer()
            return coroutine.create(produce)
        end

        test.assert_list_equal({'x__end', 'y__end', 'z__end'},
                               consume(producer()))
    end
