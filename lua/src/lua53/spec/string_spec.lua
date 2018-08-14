
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

    -- long text/binary represend by numbers(/z)
    assert.are.same('hello, "Lua 5.3".', '\x68\x65\x6c\x6c\x6f\x2c\x20\x22\z
                                          \x4c\x75\x61\x20\x35\x2e\x33\x22\x2e')
  end)

  -- http://www.lua.org/manual/5.3/manual.html#6.4
  it('string library', function()
    -- string.byte
    -- string.char
    local s = 'Hello, Lua!'
    assert.are.same(s, string.char(string.byte(s, 1, -1)), 'ASCII char relevant operations')

    -- string.rep
    assert.are.same(' ; ; ', string.rep(' ', 3, ';'))

    -- string.reverse
    assert.are.same('hello', string.reverse('olleh'))

    -- string.lower and string.upper
    assert.are.same('hello', string.lower('Hello'))
    assert.are.same('HELLO', string.upper('Hello'))

    -- string.len
    assert.are.same(5, string.len('hello'))
  end)

  it('other', function()
    assert.are.same(' !"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~', helper.printable_characters())
    --helper.hexdump('\x68\x65\x6c\x6c\x6f\x2c\x20\x22\x4c\x75\x61\x20\x35\x2e\x33\x22\x2e')
  end)
end)

-- pack format http://www.lua.org/manual/5.3/manual.html#6.4.2
describe('binary', function()
  it('pack endian', function()
    -- big endian
    local s = string.pack('>i4', 0x01020304)
    assert.are.same('\x01\x02\x03\x04', s)

    s = string.pack('>h', 0x0304)
    assert.are.same('\x03\x04', s)

    -- little endian
    s = string.pack('<i4', 0x01020304)
    assert.are.same('\x04\x03\x02\x01', s)

    s = string.pack('<H', 0x0304)
    assert.are.same('\x04\x03', s)

    -- endian has no meaning to string and byte
    s = string.pack('>zb', 'hello', 0x01)
    assert.are.same('hello\0\x01', s)
    s = string.pack('<zb', 'hello', 0x01)
    assert.are.same('hello\0\x01', s)
  end)

  -- http://www.lua.org/manual/5.3/manual.html#6.4.2
  it('pack aliggment', function()
    -- it seems the native alignment size is 1
    assert.are.same(9, string.packsize('bd'))
    assert.are.same(10, string.packsize('!2bd'))
    assert.are.same(12, string.packsize('!4bd'))
  end)

  it('pack integer', function()
    -- byte
    local s = string.pack('bB', 0x7f, 0xff)
    assert.are.same({0x7f, 0xff, 3, n=3}, table.pack(string.unpack('bB', s)))

    -- short
    s = string.pack('hH', 0x7fff, 0xffff)
    assert.are.same({0x7fff, 0xffff, 5, n=3}, table.pack(string.unpack('hH', s)))

    -- long (8 bytes on 64-bit machine and 4 bytes on 32-bit machine)
    s = string.pack('lL', 0x7fffffff, 0xffffffff)
    assert.are.same({0x7fffffff, 0xffffffff, 17, n=3}, table.pack(string.unpack('lL', s)))

    -- integer with variable width
    s = string.pack('i1i2i3i4i5I1I2I3I4I5', 0x7f, 0x7fff, 0x7fffff, 0x7fffffff, 0x7fffffffff,
                                        0xff, 0xffff, 0xffffff, 0xffffffff, 0xffffffffff)
    assert.are.same({0x7f, 0x7fff, 0x7fffff, 0x7fffffff, 0x7fffffffff,
                     0xff, 0xffff, 0xffffff, 0xffffffff, 0xffffffffff,
                     31, n=11}, table.pack(string.unpack('i1i2i3i4i5I1I2I3I4I5', s)))

    -- overflow
    assert.has.error.match(function() string.pack('b', 0xff) end, '(integer overflow)')
    assert.has.no.error(function() string.unpack('i12', string.pack('i12', math.maxinteger)) end)
    assert.has.error.match(function() string.unpack('i12', 'aaaaaaaaaaaa') end, 'does not fit into Lua Integer')
  end)

  it('pack float', function()
    -- single float
    assert.are.same(4, string.packsize('f'))
    local s = string.pack('f', 0.00001)
    assert.is.near(0.00001, string.unpack('f', s), 0.0000001)

    -- double float
    assert.are.same(8, string.packsize('d'))
    local s = string.pack('d', 0.00001)
    assert.are.same({0.00001, 9, n=2}, table.pack(string.unpack('d', s)))
  end)

  it('pack string', function()
    -- zero-terminaled strings
    local s = string.pack('z', 'hello')
    assert.are.same({'hello', 7, n=2}, table.pack(string.unpack('z', s)))

    -- fixed size string (if n > string.len, zero bytes were padded)
    s = string.pack('c10', 'hello')
    assert.are.same({'hello\x00\x00\x00\x00\x00', 11, n=2}, table.pack(string.unpack('c10', s)))
    assert.are.same('hello', string.gsub('hello\x00\x00\x00\x00\x00', '\x00+$', ''))

    -- varialbe length string
    s = string.pack('s1', 'hello, lua')
    assert.are.same({'hello, lua', 12, n=2}, table.pack(string.unpack('s1', s)))

    -- overflow
    assert.has.error.match(function() string.pack('c3', 'hello') end, 'string longer than given size')
    assert.has.no.error(function() string.pack('s1', string.rep(' ', 255)) end)
    assert.has.error.match(function() string.pack('s1', string.rep(' ', 256)) end, '(string length does not fit in given size)')
    -- size_t bytes represents string length
    assert.has.no.error(function() string.pack('s', string.rep(' ', 256)) end)
  end)
end)
