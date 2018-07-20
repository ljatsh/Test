
local lu = require('luaunit')
local json = require('cjson')

TestCJson = {}

  function TestCJson:testEncode()
    -- simple types
    lu.assertEquals(json.encode(100), '100')
    lu.assertEquals(json.encode(0.5112), '0.5112')
    lu.assertEquals(json.encode(nil), 'null')
    lu.assertEquals(json.encode(true), 'true')
    lu.assertEquals(json.encode('hello'), '"hello"')
    lu.assertEquals(json.encode({}), '{}')

    -- array
    lu.assertEquals(json.encode({100, 0.5112, nil, false, 'hello', {}}), '[100,0.5112,null,false,"hello",{}]')

    -- object
    local str = json.encode({name='ljatsh', age=34})
    local t = json.decode(str)
    lu.assertEquals(t.name, 'ljatsh')
    lu.assertEquals(t.age, 34)
  end

  function TestCJson:testDecode()
    lu.assertEquals(json.decode('100'), 100)
    lu.assertEquals(json.decode('0.5112'), 0.5112)
    lu.assertEquals(json.decode('null'), json.null)
    lu.assertEquals(json.decode('true'), true)
    lu.assertEquals(json.decode('"hello"'), 'hello')
    lu.assertEquals(json.decode('{}'), {})

    lu.assertEquals(json.decode('[100,0.5112,null,false,"hello",{}]'), {100, 0.5112, json.null, false, 'hello', {}})
  end

-- end of table TestCJson

ngx.say(lu.LuaUnit.run())