
require('pack')

-- copied from Lua5.3
describe('pack', function()
  it('pack endian', function()
    -- big endian
    local s = string.pack('>i', 0x01020304)
    assert.are.same('\x01\x02\x03\x04', s)

    s = string.pack('>h', 0x0304)
    assert.are.same('\x03\x04', s)

    -- little endian
    s = string.pack('<i', 0x01020304)
    assert.are.same('\x04\x03\x02\x01', s)

    s = string.pack('<H', 0x0304)
    assert.are.same('\x04\x03', s)

    -- endian has no meaning to string and byte
    s = string.pack('>zb', 'hello', 0x01)
    assert.are.same('hello\0\x01', s)
    s = string.pack('<zb', 'hello', 0x01)
    assert.are.same('hello\0\x01', s)
  end)

  it('pack integer', function()
    -- byte
    local s = string.pack('b', 0x7f)
    assert.are.same({2, 0x7f, n=2}, table.pack(string.unpack(s, 'b')))

    -- short
    s = string.pack('h', 0x7fff)
    assert.are.same({3, 0x7fff, n=2}, table.pack(string.unpack(s, 'h')))

    -- long (8 bytes on 64-bit machine and 4 bytes on 32-bit machine)
    s = string.pack('l', 0x7fffffff)
    assert.are.same({9, 0x7fffffff, n=2}, table.pack(string.unpack(s, 'l')))

    -- integer with variable width
    s = string.pack('i4', 0x7f, 0x7fff, 0x7fffff, 0x7fffffff)
    assert.are.same({17, 0x7f, 0x7fff, 0x7fffff, 0x7fffffff, n=5}, table.pack(string.unpack(s, 'i4')))
  end)

  it('pack string', function()
    -- zero-terminaled strings
    local s = string.pack('z', 'hello\0lua')
    assert.are.same({7, 'hello', n=2}, table.pack(string.unpack(s, 'z')))

    -- varialbe length string
    s = string.pack('p', 'hello, lua')
    assert.are.same({12, 'hello, lua', n=2}, table.pack(string.unpack(s, 'p')))
  end)
end)
