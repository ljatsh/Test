require "lunit"

module("cp1", lunit.testcase, package.seeall)

    function test()
        assert_nil(b, 'b was never assigned')
    end

