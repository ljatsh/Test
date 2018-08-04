
print('Hello, skynet')
print(package.path)

require('hello')


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

os.exit(lu.LuaUnit.run())