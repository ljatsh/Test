
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

------------------------------------------------------------------------------------
-- nil
describe('data type - nil', function()
  it('general', function()
    assert.are.same('nil', type(nil))
    assert.is_nil(nil)
    assert.is_nil(missing_var)
    local missing_var = 1
    assert.is.not_nil(missing_var)
    missing_var = nil
    assert.is_nil(missing_var)
  end)
end)

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

describe('data type - boolean', function()
  it('general', function()
    for _, v in ipairs({true, false}) do
      assert.are.same('boolean', type(v))
      assert.is.boolean(v)
    end
  end)

  it('condition value', function()
    -- false condition values
    assert.is.falsy(false)
    assert.is.falsy(nil)

    -- true condition values
    assert.is.truthy(true)
    assert.is.truthy(0, '0 is a true condition value')
    assert.is.truthy('', 'empty string is a true condition value')
  end)

  it('logic operator', function()
    assert.are.same(5, 4 and 5)
    assert.is_nil(nil and 13)
    assert.is_false(false, false and 13)

    assert.are.same(0, 0 or 5)
    assert.are.same('hi', false or 'hi')
    assert.is_false(false, nil or false)
  end)
end)
