
local parser = require('sprotoparser')
local sproto = require('sproto')
local sprotocore = require('sproto.core')
local util = require('util')

describe('sproto', function()
  local self = {}

  setup(function()
    local schema = parser.parse( [[
      .Person {
        name 0 : string
        id 1 : integer
        email 2 : string
    
        .PhoneNumber {
            number 0 : string
            type 1 : integer
        }
    
        phone 3 : *PhoneNumber
      }
      
      .AddressBook {
          person 0 : *Person
      }

      .Node {
        name 0: string
        data 1: binary
        dead 2: boolean
        age 3: integer
        amount 4: integer(2)
        left 5: *Node
        right 6: *Node(name)
      }
    ]]
    )

    self.so = sproto.new(schema)
  end)

  it('create object', function()
    assert.is_true(self.so:exist_type('Person'))
    assert.is_true(self.so:exist_type('AddressBook'))
    assert.is_false(self.so:exist_type('Addressbook'), 'case sensitive')
    assert.is_false(self.so:exist_type('PhoneNumber'), 'it seems the nested types are hidden')
  end)

  it('schema string', function()
    local sb 
    -- string/numbers/binary can be encoded
    for _, v in pairs({'ljatsh', 1, '1.23', 'x01\x02\x03'}) do
      sb = self.so:encode('Node', {name = v})
      assert.are.same({name = tostring(v)}, self.so:decode('Node', sb))
    end

    -- other stuff cannot be encoded
    for _, v in pairs({{}, true}) do
      assert.has.error(function() self.so:encode('Node', {name = v}) end)
    end
  end)

  it('schema binary', function()
    local sb 
    -- string/numbers/binary can be encoded
    for _, v in pairs({'ljatsh', 1, '1.23', 'x01\x02\x03'}) do
      sb = self.so:encode('Node', {data = v})
      assert.are.same({data = tostring(v)}, self.so:decode('Node', sb))
    end

    -- other stuff cannot be encoded
    for _, v in pairs({{}, true}) do
      assert.has.error(function() self.so:encode('Node', {data = v}) end)
    end
  end)

  it('schema boolean', function()
    local sb 
    -- boolean can be encoded
    for _, v in pairs({true, false}) do
      sb = self.so:encode('Node', {dead = v})
      assert.are.same({dead = v}, self.so:decode('Node', sb))
    end

    -- other stuff cannot be encoded
    for _, v in pairs({0, 0.1, 'hello', {}}) do
      assert.has.error(function() self.so:encode('Node', {dead = v}) end)
    end
  end)

  it('schema integer', function()
    local sb 
    -- integer can be encoded
    for _, v in pairs({34}) do
      sb = self.so:encode('Node', {age = v})
      assert.are.same({age = v}, self.so:decode('Node', sb))
    end

    -- other stuff cannot be encoded
    for _, v in pairs({0.1, 'hello', {}, true}) do
      assert.has.error(function() self.so:encode('Node', {age = v}) end)
    end
  end)

  it('schema decimal', function()
    local sb 
    -- integer/decimal/tonumber(string)-->valid can be encoded
    for _, v in pairs({34, 1.23}) do
      sb = self.so:encode('Node', {amount = v})
      assert.are.same({amount = v}, self.so:decode('Node', sb))
    end

    -- tonumber(string) -->valid can be encoded
    sb = self.so:encode('Node', {amount = '1.23'})
    assert.are.same({amount = 1.23}, self.so:decode('Node', sb))

    -- invalid string/boolean/table can also be encoded
    for _, v in pairs({'1.23hello', true, false, {}}) do
      sb = self.so:encode('Node', {amount = v})
      assert.are.same({amount = 0.0}, self.so:decode('Node', sb))
    end
  end)

  it('schame array', function()
    local t = {name = 'test', left = {{age=34}, {name = 'ljatsh'}}}
    local sb = self.so:encode('Node', t)
    assert.are.same(t, self.so:decode('Node', sb))
  end)

  it('schame map', function()
    -- array can be encoded
    local t = {name = 'test', right = {{name = 'ljatbj', age=31}, {name = 'ljatsh', age=34}}}
    local sb = self.so:encode('Node', t)
    local t2 = self.so:decode('Node', sb)

    assert.are.same({name = 'ljatbj', age=31}, t2.right['ljatbj'])
    assert.are.same({name = 'ljatsh', age=34}, t2.right['ljatsh'])

    -- map can also be encoded
    sb = self.so:encode('Node', t2)
    assert.are.same(t2, self.so:decode('Node', sb))

    -- duplicate elments were encoded as one copy
    t = {name = 'test', right = {{name = 'ljatsh', age=31}, {name = 'ljatsh', age=34}}}
    sb = self.so:encode('Node', t)
    assert.is.unique(self.so:decode('Node', sb).right)

    -- Enhancement
    -- encode/decode mismatch if there exists element without key
    t = {name = 'test', right = {ljatbj={age=31}, ljatsh={name = 'ljatsh', age=34}}}
    sb = self.so:encode('Node', t)
    assert.has.error(function() self.so:decode('Node', sb) end)
  end)

  it('encode compability', function()
    local person = {}

    -- properties cannot be recogonized by schema should not be encoded
    person.test = 'hello'
    local sb = self.so:encode('Person', person)
    local pd = self.so:decode('Person', sb)
    assert.has.no.property('test', pd)
    assert.are.same({}, pd)
  end)

  -- TODO
  --it('wire protocol', function()
  --end)
end)
