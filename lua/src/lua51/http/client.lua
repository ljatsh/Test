
local sock = require('socket')
local headers = require('http.header')
local hreq = require('http.request')
local hresp = require('http.response')
local hurl = require('http.url')
local lhp = require('http.parser')

local M_ = {}

---
-- @returns response | nil, err
function M_.request(req, host, port)
  port = port or 80
  req.headers[headers.Host] = host

  -- write
  local socket, err = sock.connect(host, port)
  if socket == nil then
    return nil, err
  end

  local r, err = socket:write(tostring(req))
  if not r then
    return nil, err
  end

  -- read & parse
  local response = hresp.new()
  local bodies = {}
  local finished = false

  local parser
  parser = lhp.response {
    on_header = function(hkey, hval)
      response.headers[hkey] = hval
    end,

    on_headers_complete = function()
      response.status = parser:status_code()
      response.version_major, response.version_minor = parser:version()

      print('on_headers_complete')

      print(parser:method())

      if req:method() == 'HEAD' then
        finished = true
      end
    end,

    on_body = function(body)
      if body ~= nil then
        bodies[#bodies + 1] = body
      end
    end,

    on_message_complete = function()
      finished = true
    end
  }

  local count
  local data
  repeat
    count, data = socket:read()
    print(count)
    if count == false then
      -- for connection-close
      parser:execute('')
      break
    end

    parser:execute(data)

    print(response)

    if finished then
      break
    end
  until false

  if finished then
    response:set_data(table.concat(bodies, ''))
    return response
  end

  print(string.format('%d %s %s', parser:error()))

  if data ~= nil then
    return nil, data
  end

  return nil, string.format('%d %s %s', parser:error())
end

return M_
