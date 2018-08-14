
local helper = require('helper')

describe('string', function()
  -- lua string is literal
  it('creation', function()
    -- escaped char \" can be typed shortly in single quoted string
    assert.are.same('hello, \"Lua 5.3\".', 'hello, "Lua 5.3".')

    -- long text literal
    local s = [=[
      local a = {}
      local b = {}
      local c = a[b[1]]

      --[[
        a.__index = {}
      ]]
    ]=]
    assert.has.match('local c = a%[b%[1%]%]', s)
    assert.has.match('a.__index = {}', s)

    -- represend by numbers
    -- \ddd prefer 3 digits with 0 padding
    -- \xhh perfer 2 digits with 0 padding
    --[[
    local t = table.pack(string.byte('hello, "Lua 5.3".', 1, -1))
    local dec = {}
    local hex = {}
    for _, c in ipairs(t) do
      table.insert(dec, string.format('\\%03d', c))
      table.insert(hex, string.format('\\x%x', c))
    end

    print(table.concat(dec))
    print(table.concat(hex))
    -- \104\101\108\108\111\044\032\034\076\117\097\032\053\046\051\034\046
    -- \x68\x65\x6c\x6c\x6f\x2c\x20\x22\x4c\x75\x61\x20\x35\x2e\x33\x22\x2e
    ]]
    assert.are.same('hello, "Lua 5.3".', '\104\101\108\108\111\044\032\034\076\117\097\032\053\046\051\034\046')
    assert.are.same('hello, "Lua 5.3".', '\x68\x65\x6c\x6c\x6f\x2c\x20\x22\x4c\x75\x61\x20\x35\x2e\x33\x22\x2e')
  end)

  -- http://www.lua.org/manual/5.3/manual.html#6.4
  it('string library', function()
    -- string.byte
    -- string.char
    local s = 'Hello, Lua!'
    assert.are.same(s, string.char(string.byte(s, 1, -1)), 'ASCII char relevant operations')


  end)

  it('other', function()
    assert.are.same(' !"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~', helper.printable_characters())
    helper.hexdump('\x68\x65\x6c\x6c\x6f\x2c\x20\x22\x4c\x75\x61\x20\x35\x2e\x33\x22\x2e')
  end)
end)
