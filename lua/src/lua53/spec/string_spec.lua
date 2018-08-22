
local helper = require('helper')
local sp = require('snippets')

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

describe('pattern', function()
  --- character class http://www.lua.org/manual/5.3/manual.html#6.4.1
  -- .: (a dot) represents all characters.
  -- %a: represents all letters.
  -- %c: represents all control characters.
  -- %d: represents all digits.
  -- %g: represents all printable characters except space.
  -- %l: represents all lowercase letters.
  -- %p: represents all punctuation characters.
  -- %s: represents all space characters.
  -- %u: represents all uppercase letters.
  -- %w: represents all alphanumeric characters.
  -- %x: represents all hexadecimal digits.
  -- %x: (where x is any non-alphanumeric character) represents the character x. This is the standard way to escape the magic characters. Any non-alphanumeric character (including all punctuation characters, even the non-magical) can be preceded by a '%' when used to represent itself in a pattern.
  -- [set]: represents the class which is the union of all characters in set. A range of characters can be specified by separating the end characters of the range, in ascending order, with a '-'. All classes %x described above can also be used as components in set. All other characters in set represent themselves. For example, [%w_] (or [_%w]) represents all alphanumeric characters plus the underscore, [0-7] represents the octal digits, and [0-7%l%-] represents the octal digits plus the lowercase letters plus the '-' character.
  -- You can put a closing square bracket in a set by positioning it as the first character in the set. You can put a hyphen in a set by positioning it as the first or the last character in the set. (You can also use an escape for both cases.)
  -- The interaction between ranges and classes is not defined. Therefore, patterns like [%a-z] or [a-%%] have no meaning.
  -- [^set]: represents the complement of set, where set is interpreted as above.
  it('character class', function()
    local char_codes = {}
    for i=0, 255 do char_codes[#char_codes + 1] = i end
    local ascii = string.char(table.unpack(char_codes))

    -- %a [a-zA-Z] [97-122|65-90]
    local ascii_a = {}
    for i=65,90 do ascii_a[#ascii_a + 1] = string.char(i) end
    for i=97,122 do ascii_a[#ascii_a + 1] = string.char(i) end

    local matches = {}
    for x in string.gmatch(ascii, '%a') do matches[#matches + 1] = x end
    assert.are.same(ascii_a, matches)
    matches = {}

    -- %c [0-31|127]
    local ascii_c = {}
    for i=0,31 do ascii_c[#ascii_c + 1] = string.char(i) end
    ascii_c[#ascii_c + 1] = string.char(127)

    for x in string.gmatch(ascii, '%c') do matches[#matches + 1] = x end
    assert.are.same(ascii_c, matches)
    matches = {}

    -- %d [0-9] [48-57]
    local ascii_d = {}
    for i=48,57 do ascii_d[#ascii_d + 1] = string.char(i) end

    for x in string.gmatch(ascii, '%d') do matches[#matches + 1] = x end
    assert.are.same(ascii_d, matches)
    matches = {}

    -- %g [33-126]
    local ascii_g = {}
    for i=33, 126 do ascii_g[#ascii_g + 1] = string.char(i) end

    for x in string.gmatch(ascii, '%g') do matches[#matches + 1] = x end
    assert.are.same(ascii_g, matches)
    matches = {}

    -- %p [33-47|58-64|91-96|123-126]
    local ascii_p = {}
    for i=33, 47 do ascii_p[#ascii_p + 1] = string.char(i) end
    for i=58, 64 do ascii_p[#ascii_p + 1] = string.char(i) end
    for i=91, 96 do ascii_p[#ascii_p + 1] = string.char(i) end
    for i=123, 126 do ascii_p[#ascii_p + 1] = string.char(i) end

    for x in string.gmatch(ascii, '%p') do matches[#matches + 1] = x end
    assert.are.same(ascii_p, matches)
    matches = {}

    -- %s space 32 \t 9 \n 10 vertical tab 11 new page 12 \r 13
    local ascii_s = {string.char(9), string.char(10), string.char(11), string.char(12), string.char(13), string.char(32)}

    for x in string.gmatch(ascii, '%s') do matches[#matches + 1] = x end
    assert.are.same(ascii_s, matches)
    matches = {}
  end)

  it('find', function()
    -- pattern match disabled
    assert.are.same({8, 11, n=2}, table.pack(string.find('Hello, Lua.', 'Lua.', 1, true)))

    -- pattern match
    assert.has.error.match(function() string.find('Hello, Lua.', 'Lua%') end, 'malformed pattern')
    assert.are.same({8, 11, n=2}, table.pack(string.find('Hello, Lua.', 'Lua%.')))
    assert.is_nil(string.find('Hello, Lua.', 'Lua%a'))

    -- with capture
    -- first indice -- start of the whole matched string
    -- second indice -- end of the whole matched string
    assert.are.same({8, 11, 'Lua.', n=3}, table.pack(string.find('Hello, Lua.', '(Lua%.)')))
    assert.are.same({1, 11, 'Hello', 'Lua', n=4}, table.pack(string.find('Hello, Lua.__', '(%w+),%s*(%w+)%.')))
  end)

  it('match', function()
    -- pattern match (just like find, but returns the matched string instead of the indicies)
    assert.has.error.match(function() string.match('Hello, Lua.', 'Lua%') end, 'malformed pattern')
    assert.are.same('Lua.', string.match('Hello, Lua.', 'Lua%.'))
    assert.is_nil(string.match('Hello, Lua.', 'Lua%a'))

    -- with capture (returns each captured value instead of the whole string)
    assert.are.same('Hello, Lua.', string.match('Hello, Lua.__', '%w+,%s*%w+%.'))
    assert.are.same({'Hello', 'Lua', n=2}, table.pack(string.match('Hello, Lua.__', '(%w+),%s*(%w+)%.')))
  end)

  it('gmatch', function()
    -- pattern match
    local s = 'hello world from lua!'
    local t = {}
    for w in string.gmatch(s, '%w+') do
        t[#t + 1] = w
    end
    assert.are.same({'hello', 'world', 'from', 'lua'}, t)

    -- with capture (returns each captured value instead of the whole string)
    s = 'from=world, to = Lua'
    t = {}
    for k, v in string.gmatch(s, '(%w+)%s*=%s*(%w+)') do
        t[k] = v
    end
    assert.are.same({from='world', to='Lua'}, t)
  end)

  it('gsub - string', function()
    -- pattern match
    local s = 'Can you help $name? Monsters are attacking $name.'
    local target = 'Can you help ljatsh? Monsters are attacking ljatsh.'
    assert.are.same({target, 2, n=2}, table.pack(string.gsub(s, '$%w+', 'ljatsh')))

    -- with capture
    s = 'name=ljatsh, age=33'
    assert.are.same('ljatsh is name, 33 is age', string.gsub(s, '(%w+)%s*=%s*(%w+)', '%2 is %1'))
    assert.are.same('ehll,oL au', string.gsub('hello, Lua', '(.)(.)', '%2%1'))
    assert.are.same('h-he-el-ll-lo-o, L-Lu-ua-a', string.gsub('hello, Lua', '%a', '%0-%0'))
  end)

  it('gusb - function', function()
    local t = {}
    function t.f(...) end
    local sb = stub.new(t, 'f')
    sb.on_call_with('$name').returns('ljatsh')
    sb.on_call_with('$team').returns('red-team')
    assert.are.is_table(sb)
    assert.are.same(sb, t.f)

    -- pattern match
    local s = 'Can you help $name? Monsters are attacking $team.'
    local target = 'Can you help ljatsh? Monsters are attacking red-team.'
    assert.are.same({target, 2, n=2}, table.pack(string.gsub(s, '%$%w+', function(...) return sb(...) end)))
    assert.stub(sb).was.called(2)
    assert.stub(sb).was.called_with('$name')
    assert.stub(sb).was.called_with('$team')
    sb:clear()

    -- with capture (all captures are function parameters)
    function t.increase_version(prefix, v)
        return prefix .. tostring(tonumber(v) + 1)
    end
    spy.on(t, 'increase_version')
    s = 'version=1.0, name=test'
    target = 'version=1.1, name=test'
    assert.are.same({target, 1, n=2}, table.pack(string.gsub(s, '(version%s*=%s*%d+.)(%d+)', function(...) return t.increase_version(...) end)))
    assert.spy(t.increase_version).was.called(1)
    assert.spy(t.increase_version).was.called_with('version=1.', '0')
  end)

  it('gsub - table', function()
    -- table was indexed with the first captured string or the whole string
    local t = {
      name = 'ljatsh',
      age = 34,
      f = function() end
    }

    local proxy = setmetatable({}, {
      __index = function(_, k)
        t.f(k)
        return t[k]
      end
    })
    local sp = spy.on(t, 'f')

    local s = 'name=$name, age=$age'
    assert.are.same('name=ljatsh, age=34', string.gsub(s, '$(%w+)', proxy))
    assert.spy(t.f).was.called(2)
    assert.spy(t.f).was.called_with('name')
    assert.spy(t.f).was.called_with('age')
  end)

  it('gsub - other', function()
    -- function/indexed value should be string, number
    -- if the values was false, nil, substitution was skipped. However, every matched string is 
    -- recored as a successful substitution
    local s = 'name=$name, age=$age'
    assert.has.error.match(function() string.gsub(s, '%$(%w+)', function(...) return {} end) end, 'invalid replacement value')
    assert.are.same({s, 2, n=2}, table.pack(string.gsub(s, '%$(%w+)', function(...) return false end)))
  end)

-- function testPatternModifier()
--     -- * matches 0 or more characters of the origin class(as longest as possible)
--     s = "local _name = 'ljatsh'"
--     assert_equal('_name', string.match(s, '[_%a][_%w]*', 6), 'match a identifier')

--     -- + matches 1 or more characters of the origin class(as longest as possible)
--     assert_equal("'ljatsh'", string.match(s, "'[%w]+'"), 'match a non empty literal string')

--     -- ? matches an optional character
--     assert_true(string.find('124', '[+-]?%d+') == 1)
--     assert_true(string.find('+124', '[+-]?%d+') == 1)
--     assert_true(string.find('-124', '[+-]?%d+') == 1)

--     -- - matches 0 or more characters of the origin class(but as shortest as possible)
--     s = 'one|two|three|four'
--     assert_equal('|two|three|', string.match(s, '|.*|'))
--     assert_equal('|two|', string.match(s, '|.-|'))
-- end

-- function testPattern()
--     -- %b matches balanced string
--     assert_equal('a  line',
--                  string.gsub("a (enclosed (in) parentheses) line", "%b()", ""),
--                  'magic character does not take effect here')

--     assert_equal('a - line',
--                  string.gsub("a +enclosed +in- parentheses-- line", "%b+-", ""),
--                  'magic character does not take effect here')
-- end

-- function testCapture()
--     test.assert_list_equal({3, 4, 3, 5},
--                            table.pack(string.find('flaaap', '()aa()')),
--                            [[TODO, I'm cannot understand the sepecial case yet.]])

--     s = [[then he said: "it's all right"!]]
--     assert_equal([[it's all right]],
--                  select(2, string.match(s, "([\"'])(.-)%1")),
--                  '2. cpatures can be used in patterns directly')

--     -- 3. captures can be used in string.gsub
-- end

-- function testSamples()
--     pattern_china_mobile_1 = '^1[358][0-9]%d%d%d%d%d%d%d%d$'
--     assert_true(string.find('15901718900', pattern_china_mobile_1) == 1, 'Lua pattern does not support POSIX regex now') 

--     -- HTTP coding and encoding
-- end
end)

-- TODO
--[[

function testSerialization()
  local function origin(v) return tostring(v) end

  local serialized_result = string.dump(origin)
  local f = load(serialized_result)
  assert_function(f, 'f can be loaded from the serialized chunk')
  assert_not_equal(origin, f, 'f and origin are different functions, but with the same logic')
  assert_equal('1', f(1))
end

]]
