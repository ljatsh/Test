
local lu = require('luaunit')
local json = require('cjson')

local TestCJson = {}

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

  -- Infinity and Nan is not allowd in stadard json specification
  function TestCJson:testInvalidNumbers()
    local o = {
      name = 'ljatsh',
      nan = math.huge * 0,
      infinity = math.huge
    }

    lu.assertError(json.encode, o)

    local json2 = json.new()
    json2.encode_invalid_numbers(true)
    local r = json2.encode(o)

    json.decode_invalid_numbers(false)
    lu.assertError(json.decode, r)

    o2 = json2.decode(r)

    lu.assertEquals(o2.name, 'ljatsh')
    lu.assertIsNumber(o2.nan) -- TODO how to check the Nan
    lu.assertEquals(o2.infinity, o.infinity)
  end

  function TestCJson:testSparseArray()
    local o = {
      [1] = 34,
      [2] = 35,
      [4] = 37,
      [7] = 39
    }

    -- array and sparse array always can be encoded
    local output = json.encode(o)
    lu.assertEquals(output, '[34,35,null,37,null,null,39]')
    local o2 = json.decode(output)
    lu.assertEquals(o2, {34, 35, json.null, 37, json.null, json.null, 39})

    -- excessively sparse array can be allowed/disallowed to be encoded
    local json2 = json.new()
    json2.encode_sparse_array(true, 1, 6)
    lu.assertEquals(json2.encode(o), '{"1":34,"2":35,"4":37,"7":39}')
    json2.encode_sparse_array(false, 1, 6)
    lu.assertError(json2.encode, o)
  end

  function TestCJson:testEncodeEmptyTableAsArray()
    local json2 = json.new()
    json2.encode_empty_table_as_object(false)
    lu.assertEquals(json2.encode({}), '[]')
  end

  function TestCJson:testEmptyArrayConsts()
    lu.assertEquals(json.encode({a={}, b=json.empty_array}), '{"a":{},"b":[]}')
  end

  function TestCJson:testArrayMt()
    local o = {}
    o[1] = "one"
    o[2] = "two"
    o[4] = "three"
    o.foo = "bar"

    lu.assertEquals(json.encode(o), '{"1":"one","2":"two","4":"three","foo":"bar"}')

    setmetatable(o, json.array_mt)
    lu.assertEquals(json.encode(o), '["one","two",null,"three"]')
  end

  function TestCJson:testEmptyArrayMt()
    local o = {'ljatsh', 34}
    lu.assertEquals(json.encode(o), '["ljatsh",34]')

    o[1] = nil
    o[2] = nil
    lu.assertEquals(json.encode(o), '{}')
    setmetatable(o, json.empty_array_mt)
    lu.assertEquals(json.encode(o), '[]')
  end

  function TestCJson:testDecodeArrayWithArrayMt()
    local o = json.decode('[]')
    lu.assertEquals(json.encode(o), '{}')

    local json2 = json.new()
    json2.decode_array_with_array_mt(true)
    o = json2.decode('[]')
    lu.assertEquals(json2.encode(o), '[]')
    o[2] = 34
    o.name = 'ljatsh'
    lu.assertEquals(json2.encode(o), '[null,34]')
  end

-- end of table TestCJson

return TestCJson
