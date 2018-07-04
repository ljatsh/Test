------------------------------------------------------------------------------------
-- PIL 4th edition. The basics--- 3. Numbers
-- 

------------------------------------------------------------------------------------
-- 1. integer and float both have "number" type, but can be distinguished by math.type
-- 2. integer and float with the same value are compared as equal

--- TODO: deep into number system(https://en.wikipedia.org/wiki/Number) in computer world

lu = require("luaunit")

TestNumbers = {}

  function TestNumbers:testType()
    lu.assertEquals(type(3), "number")
    lu.assertEquals(type(3.0), "number")

    lu.assertEquals(math.type(3), "integer")
    lu.assertEquals(math.type(3.0), "float")

    lu.assertEquals(3, 3.0, 'integer and float with the same value are compared as equal')
  end

-- end of table TestNumbers
