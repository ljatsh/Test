
local luv = require('luv')

local M_ = {}

-- local default_filter = {
--   -- message to binary
--   serialize = function(msg)
--     return tostring(msg)
--   end,

--   -- 
--   on_data = function(data)
--   end
-- }

local mt

--- connect to host in block mode
-- @ip host
-- @port port
-- @return sock, or nil + error if error occurs
function M_.connect(ip, port)
  assert (coroutine.running() ~= nil)

  -- TODO getaddrinfo crash issue
  local host = luv.net.getaddrinfo(ip)
  local sock = luv.net.tcp()
  local h, err = sock:connect(host, port)
  if h == nil then
    return nil, err
  end

  sock:nodelay(true)

  return setmetatable({
    sock = sock,
    ip = host,
    port = port,
    filter = filter,
    connected = true
  }, mt)
end

--- close
function M_.close(sock)
  if sock.connected then
    sock.sock:close()
    sock.connected = false
  end
end

--- write bin in block mode
-- uv_write can be called parallel and data were writen in order.
-- luv.socket.write returns boolean, error
-- @sock
-- @msg
-- @return true|false, err
function M_.write(sock, bin)
  assert (coroutine.running() ~= nil)

  if not sock.connected then
    return false, 'socket was already disconnected'
  end

  local r, err = sock.sock:write(bin)
  if not r then
    sock:close()
    return false, err
  end

  return true
end

--- read bin in block mode
-- luv.socket.read returns false, error|count, binary
-- @returns false, error|count, binary
function M_.read(sock)
  assert (coroutine.running() ~= nil)

  if not sock.connected then
    return nil, 'socket was already disconnected'
  end

  local count, bin = sock.sock:read()
  if count == false then
    sock:close()
  end

  return count, bin
end

mt = {
  __index = {
    write = M_.write,
    read = M_.read,
    close = M_.close
  }
}

return M_
