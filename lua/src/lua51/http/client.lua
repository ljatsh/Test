
local sock = require('socket')
local lhp = require('http.parser')

local M_ = {}

---
-- @returns response | nil, err
function M_.get()
  -- request parse
  local host = 'www.google.com'
  local port = 80

  -- write
  local socket, err = sock.connect(host, port)
  if socket == nil then
    return nil, err
  end

  local r, err = socket:write('GET / HTTP/1.0\r\nHost: www.google.com\r\n\r\n')
  if not r then
    return nil, err
  end

  -- read & parse
  local response = {
    headers = {},
    finished = false,
  }

  local parser = lhp.request {
    on_header = function(hkey, hval) response.headers[hkey] = hval end,

    on_body = function(body) print('body--->'); print(body) end,

    on_message_begin    = function() print('message begin--->') end,
    on_message_complete = function() print('message completed--->') end,
    on_headers_complete = function() print('headers completed--->') end,

    on_chunk_header   = function(content_length) print('chunk header--->', content_length) end,

    on_chunk_complete = function() response.finished = true end
  }

  local count
  local data
  local bytes_read = 0
  repeat
    bytes_read = 0
    -- count == 0 ? TBD
    count, data = socket:read()
    print(count, data)
    if count == false or count == 0 then
      parser:execute('')
      break
    end

    while bytes_read < count do
      local executed_len = parser:execute(data:sub(bytes_read))
      bytes_read = executed_len + bytes_read
      print('bytes_read = ', bytes_read)
    end
  until false

  if response.finished then
    return response, parser
  end

  --return nil, data
end

return M_
