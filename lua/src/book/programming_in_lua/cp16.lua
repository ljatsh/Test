
require "lunit"

-- Programming in Lua-->Object-Oriented Programming
-- http://www.lua.org/pil/16.html


module ("cp16", lunit.testcase, package.seeall)

    function test_table_methods()
        local a = {balance = 0.0}
        function a.deposit(self, v)  self.balance = self.balance + v end
        function a:withdraw(v) self.balance = self.balance - v end

        a.deposit(a, 10)
        assert_equal(10, a.balance)
        a:withdraw(5)
        assert_equal(5, a.balance)
    end

    