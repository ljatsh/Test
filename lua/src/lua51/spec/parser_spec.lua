
local ph = require('parser.parser_header')

describe('parser header', function()
  local version = 5
  local parser = ph.new(version)

  before_each(function()
    parser:reset()
  end)

  it('pack', function()
    -- empty
    local s = parser:pack('')
    assert.are.same({0, 0, 0, 0, version}, {string.byte(s, 1, -1)})

    -- big endian
    s = parser:pack('12345')
    assert.are.same({0, 0, 0, 5, version, 49, 50, 51, 52, 53}, {string.byte(s, 1, -1)})

    local data = string.rep(' ', 258)
    s = parser:pack(data)
    assert.are.same({0, 0, 1, 2, version}, {string.byte(s, 1, 5)})
  end)

  it('execute - empty', function()
    local s = parser:pack('')
    local len = #s
    for i=1, len-1 do
      assert.are.same({n=2}, table.pack(parser:execute(s:sub(i, i))))
    end
    assert.are.same({[2] = '', n=2}, table.pack(parser:execute(s:sub(len, len))))
  end)

  it('execute - single msg', function()
    local s = parser:pack('12345')
    local len = #s
    for i=1, len-1 do
      assert.are.same({n=2}, table.pack(parser:execute(s:sub(i, i))))
    end
    assert.are.same({[2] = '12345', n=2}, table.pack(parser:execute(s:sub(len, len))))
  end)

  it('execute - multiple msgs', function()
    local long_str = string.rep(' ', 1024)
    local s = table.concat({parser:pack('12345'), parser:pack(''), parser:pack(long_str)})
    local msgs = {}
    for i=1, #s do
      local err, msg = parser:execute(s:sub(i, i))
      assert.is_nil(err)
      if msg ~= nil then
        msgs[#msgs + 1] = msg
      end
    end
    assert.are.same({'12345', '', long_str}, msgs)
  end)

  it('execute - incompatible protocol', function()
    local p = ph.new(4)
    local s = p:pack('12345')
    for i=1, 4 do
      assert.are.same({n=2}, table.pack(parser:execute(s:sub(i, i))))
    end
    assert.are.same({'incompatible version', n=2}, table.pack(parser:execute(s:sub(5, 5))))
    assert.are.same({'internal error', n=2}, table.pack(parser:execute(s:sub(6, 6))))

    parser:reset()
    s = parser:pack('12345')
    for i=1, #s-1 do
      assert.are.same({n=2}, table.pack(parser:execute(s:sub(i, i))))
    end
    assert.are.same({[2]='12345', n=2}, table.pack(parser:execute(s:sub(#s, #s))))
  end)
end)
