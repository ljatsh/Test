
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

  it('encode', function()
    local t = {
      {
        name = 'ljatsh',
        id = 2,
        email = 'test@test.com',
        phone = {{number='1234567', type=1}, {number='7654321', type=2}}
      },
      {
        name = 'ljatxa',
        id = 1,
        email = 'bs@bs.com',
        phone = {{number='029_1234567', type=3}, {number='7654321', type=4}}
      }
    }

    local b = self.so:encode('AddressBook', {person=t})
    util.hexdump(b)

    local ret = self.so:decode('AddressBook', b)
    print(util.dump(ret))
  end)
end)
