
------------------------------------------------------------------------------------
-- PIL 4th edition. The basics--- 1. Getting Started
-- 

------------------------------------------------------------------------------------
-- The standard interactive interpreter
-- 1. Enter end-of-file(CTRL-D in posix, CTRL-Z in windows), or call os.exit() to exit
--    the interpreter
-- 2. From Lua5.3, you can type expressions directly in the interactive mode and Lua
--    will print their values. However, in older versions, you need to precede these
--    expressions with an equal sign.

lu = require('luaunit')

------------------------------------------------------------------------------------
-- Nil
TestNil = {}
  function TestNil:testNilType()
    lu.assertEquals(type(nil), "nil")
    lu.assertIsNil(nil)
    lu.assertIsNil(missing_var)     -- TODO local variable name style
    local missing_var = 1
    lu.assertNotNil(missing_var)
    missing_var = nil
    lu.assertIsNil(missing_var)
  end
-- end of table TestNil

------------------------------------------------------------------------------------
-- 1. boolean values do not hold a monopoly of condition values. In Lua, and value 
--    can represent a condition. Conditional tests consider both the Boolean false
--    and nil as false, and anything else as true.
-- 2. 'and' and 'or' operator
--    Both and and use short-circuit evaluation, they evaluate thier second operand
--    only when necessary.
--    * and result: 1st value if the 1st value is false, otherwise the 2nd value
--    * or result: 1st value if the 1st value is true, otherwise the 2nd value
--    * Avoid to use 'x and y or z'. It is equivalent to C expression 'x ? y : z', 
--    * but provided that y is true condition value.
TestBoolean = {}
  function TestBoolean:testBooleanType()
    for _, v in ipairs({true, false}) do
      lu.assertEquals(type(v), "boolean")
      lu.assertIsBoolean(v)
    end
  end

  function TestBoolean:testConditionValue()
    -- false condition values
    lu.assertTrue(not false)
    lu.assertTrue(not nil)

    -- true condition values
    lu.assertFalse(not true)
    lu.assertFalse(not 0, '0 is a true condition value')
    lu.assertFalse(not '', 'empty string is a true condition value')
  end

  function TestBoolean:testLogicOperator()
    lu.assertEquals(5, 4 and 5)
    lu.assertEquals(nil, nil and 13)
    lu.assertEquals(false, false and 13)

    lu.assertEquals(0, 0 or 5)
    lu.assertEquals('hi', false or 'hi')
    lu.assertEquals(false, nil or false)
  end
-- end of table TestBoolean
