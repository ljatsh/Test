
--- http client

local stream_socket = require('stream_socket')
local headers = require('http.header')
local hreq = require('http.request')
local hresp = require('http.response')
local hurl = require('http.url')
local lhp = require('http.parser')

local M_ = {}

--- perform http request
-- @param req http request
-- @param host
-- @param port
-- @param on_body if on_body is not nil, body data will not be cached
-- @returns response
-- @returns body(error if response is nil)
function M_.do_http(req, host, port, on_body)
  port = port or 80
  --req.headers[headers.Host] = host

  -- connect
  local socket = stream_socket.new(host, port)
  local ret, err = stream_socket:connect()
  if ret == nil then
    return nil, err
  end

  -- write
  local r, err = socket:write(tostring(req))
  if not r then
    return nil, err
  end

  -- read & parse
  local response = hresp.new()
  local finish_header = false
  local finish_message = false

  local t =  {
    on_header = function(hkey, hval)
      response.headers:set(hkey, hval)
    end,

    on_headers_complete = function()
      response.status = parser:status_code()
      response.version_major, response.version_minor = parser:version()
      finish_header = true

      -- if req:method() == 'HEAD' then
      --   finished = true
      -- end
    end,

    on_message_complete = function()
      finish_message = true
    end,

    on_body = on_body
  }

  if t.on_body == nil then
    local bodies = {}
    t.on_body = function(body)
      if body ~= nil then
        bodies[#bodies + 1] = body
      end
    end
  end

  local parser = lhp.response(t)

  local count
  local data
  repeat
    count, data = socket:read()

    -- error occurred
    if count == false then
      break
    end

    -- EOF occurred
    if count == nil then
      -- check Connection: close
      if finish_header and string.lower(response.headers:get(headers.Connection) or '') == 'close' then
        count, data = parser:execute('')
      else
        count, data = false, 'connection closed by peer'
      end

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
