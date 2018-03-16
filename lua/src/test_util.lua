
require "lunit"

module("test", lunit.testcase, package.seeall)

    function assert_list_equal(expected, actual)
            for k, v in ipairs(expected) do
                assert_equal(v, actual[k])
            end

            for k, v in ipairs(actual) do
                assert_equal(v, expected[k])
            end
        end