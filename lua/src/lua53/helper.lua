local M_ = {}

-- http://www.asciitable.com/
function M_.is_printable(s)
  local code = string.byte(s)

  return code >= 0x20 and code <= 0x7E
end

function M_.printable_string()
  local t = {}
  for i=0, 255 do
    local c = string.char(i)
    if M_.is_printable(c) then
      t[#t + 1] = c
    end
  end

  return table.concat(t)
end

function M_.hexdump(s)
  local t = {}
  for offset=0, #s, 15 do
    local addr = string.format('%08x', offset)

    local hex = {}
    local char = {}
    for i=1, 16 do
      local c = s:sub(offset + i, offset + i)
      print(c)
      -- if c == nil then
      --   hex[#hex + 1] = '..'
      -- else
      --   hex[#hex + 1] = string.format('%s', c)

      --   if M_.is_printable(c) then
      --     char[#char + 1] = c
      --   else
      --     char[#char + 1] = '.'
      --   end
      -- end
    end
    print(#hex, #char)

    t[#t + 1] = string.format('%s %s |%s|', addr, table.concat(hex, ' '), table.concat(char))
  end

  return table.concat(t, '\n')
end

return M_