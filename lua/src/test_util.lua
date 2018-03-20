
require "lunit"

module("test", lunit.testcase, package.seeall)

    function assert_list_equal(expected, actual, msg)
            for k, v in ipairs(expected) do
                assert_equal(v, actual[k], msg)
            end

            for k, v in ipairs(actual) do
                assert_equal(v, expected[k], msg)
            end
        end