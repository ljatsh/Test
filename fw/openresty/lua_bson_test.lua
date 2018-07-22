
local cbson = require('cbson')
local lu = require('luaunit')

TestBson = {}

  function TestBson:tes1SimpleTypes()
    local o = {
      --simple types
      a = cbson.int(100),
      b = 100,
      c = 0.5112,
      d = nil,
      e = cbson.null(),
      f = true,
      g = 'hello',
      h = {},
      i = cbson.array()
    }

    local bdata = cbson.encode(o)
    lu.assertNotNil(bdata)

    local o2 = cbson.decode(bdata)

    lu.assertIsUserdata(o2['a'])
    lu.assertEquals(o2['a'], cbson.int(100))

    lu.assertIsNumber(o2['b'])
    lu.assertEquals(o2['b'], 100)

    lu.assertEquals(o2['c'], 0.5112)

    lu.assertIsNil(o2['d'])

    lu.assertIsUserdata(o2['e'])
    lu.assertEquals(o2['e'], cbson.null())

    lu.assertEquals(o2['f'], true)

    lu.assertEquals(o2['g'], 'hello')

    lu.assertEquals(o2['h'], {})

    lu.assertEquals(o2['i'], {})
  end

  function TestBson:testArray()
    local o = {1, 2, 3, 4}
    local bdata = cbson.encode(o)
    print (cbson.to_json(bdata))
    local o2 = cbson.decode(bdata)
    for k, v in pairs(o2) do print(k, '= ', o2[k]) end
    print(o2[1])
    print(o2[2])
    print(o2[3])
    --lu.assertEquals(cbson.decode(bdata), o)

    bdata = cbson.from_json('[1,2,3,4]')
    print(cbson.to_json(bdata))

    o2 = cbson.decode(bdata)
    for k, v in pairs(o2) do print(k, '= ', o2[k]) end
    print(o2[1])
    print(o2[2])
    print(o2[3])
  end

-- end of table TestBson

os.exit(lu.LuaUnit.run())
