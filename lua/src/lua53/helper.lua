local M_ = {}

-- http://www.asciitable.com/
function M_.is_printable(code)
  return code >= 0x20 and code <= 0x7E
end

function M_.printable_characters()
  local t = {}
  for i=0, 255 do
    if M_.is_printable(i) then
      t[#t + 1] = string.format('%c', i)
    end
  end

  return table.concat(t)
end

-- http://lua-users.org/wiki/HexDump
function M_.hexdump(s)
  local t = {}
  for offset=1, #s, 16 do
    io.write(string.format('%08x ', offset-1))
    local chunk = s:sub(offset, offset + 15)
    chunk:gsub('.', function(c) io.write(string.format('%02x ', string.byte(c))) end)
    -- padding
    io.write(string.rep(' ',3*(16-#chunk)))
    io.write(string.format(' |%s|\n', chunk:gsub('%c', '.')))
  end
end

return M_