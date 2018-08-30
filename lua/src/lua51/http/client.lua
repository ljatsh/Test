
local sock = require('socket')
local headers = require('http.header')
local hreq = require('http.request')
local hresp = require('http.response')
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

  print(tostring(req))
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
    if count == false or count == 0 then
      -- for connection-close
      parser:execute('')
      break
    end

    parser:execute(data)
  until false

  if finished then
    response:set_data(table.concat(bodies, ''))
    return response
  end

  if data ~= nil then
    return nil, data
  end

  return nil, string.format('%d %s %s', parser:error())
end

return M_
