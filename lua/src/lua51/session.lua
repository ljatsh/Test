
--- session

local luv = require('luv')
local class = require('class')
local stream_socket = require('stream_socket')

local session = class()

--- session status
-- @table status
local status = {
  closed = 1,               -- closed
  connecting = 2,           -- connecting
  connected = 3,            -- connected (authentication logic must be done during this period)
  authenticating = 4,       -- authenticating
  authenticated = 5,        -- authenticated
}

session.status = status

local write_exit = {}

--- player send data transparently on session and will be notified by arrived messages
-- @param host the remote host address
-- @param port the remote host port
-- @param parser process incoming data
-- @param sink session status event sink
function session:ctor(host, port, parser, sink)
  self.socket = stream_socket.new(host, port)
  self.parser = parser
  self.sink = sink
  self.send_head = nil
  self.send_tail = nil
  self.status = status.closed
end

--- start a new thread to drive the work flow
-- @return true | false
-- @return error
function session:start()
  if self.status ~= status.closed then
    return false, 'session is active'
  end

  self.main_thread = luv.fiber.create(function()
    local s, err = self.socket:connect()

    if s == nil then
      if self.sink ~= nil then
        self.sink:on_session_connecting_failure(self, err)
      end
      return
    end

    if self.sink ~= nil then
      self.sink:on_session_connected(self)

      local ret, err = self.sink:on_session_authentication(self)
      if not ret then
        print('authentication error: ', err)
        self.socket:close()
        return
      end

      self.status = status.authenticated

      self:_start_write_thread()
      self:_start_read_thread()

      -- wait
      self.write_thread:join()
      self.write_cond = nil
      self.write_thread = nil

      self.read_thread = nil

      if self.stop_cond then
        self.stop_cond:signal()
      end
    end
  end)
  
  self.main_thread:ready()

  return true
end

--- force stopping the session work flow synchronously
function session:stop()
  if self.status == status.closed then
    return
  end

  self.socket:close()

  assert (self.stop_cond == nil)

  self.stop_cond = luv.cond.create()
  self.stop_cond:wait()

  self.main_thread = nil
end

--- send msg asynchronously in sequence order
-- push msg to the back of sending queue
-- @param data
function session:send(data)
  if self.send_head == nil then
    self.send_head = {data = data, next = nil}
    self.send_tail = self.send_head

    if self.write_cond ~= nil then
      self.write_cond:signal()
    end
    return
  end

  self.send_tail.next = {data = data, next = nil}
  self.send_tail = self.send_tail.next
end

--- wirte data to the underline socket
-- this API blocks current thread. Game developer should not use this API directly
-- @return true | false, err
function session:_write(data)
end

--- pump next avaiable message from session
-- this API blocks current thread. Game developer should not use this API directly
-- @return message | nil, err
function session:_pump_next_message()
end

function session:_start_write_thread()
  assert (self.write_thread == nil)

  local ret = true
  local err

  self.write_thread = luv.fiber.create(function()
    repeat
      while self.send_head ~= nil do
        local data = self.send_head.data

        ret, err = self.socket:write(data)
        if not ret then
          break
        end

        self.send_head = self.send_head.next
      end

      -- exit thread if error occurred
      if not ret then
        break
      end

      self.send_tail = nil

      if self.write_cond == nil then
        self.write_cond = luv.cond.create()
      end
      local ret = self.write_cond:wait()
      if ret == write_exit then
        break
      end
    until false
  end)
end

function session:_start_read_thread()
  assert (self.read_thread == nil)

  self.read_thread = luv.fiber.create(function()
    local count
    local data
    local err
    local msg

    repeat
      count, data = self.socket:read()

      if count == false or count == nil then
        if self.sink ~= nil then
          self.sink:on_session_disconnected(self, data)
        end

        break
      end

      for i=1, count do
        err, msg = self.parser:execute(data:sub(i, i))

        if err ~= nil then
          break
        end

        if msg ~= nil and self.sink ~= nil then
          self.sink:on_session_message(self, msg)
        end
      end

      if err ~= nil then
        self.socket:close()
        if self.sink ~= nil then
          self.sink:on_session_disconnected(self, err)
        end
        break
      end
    until false

    -- notify write thread to exit
    while self.write_cond == nil do
      luv.sleep(0.001)
    end
    self.write_cond:signal(write_exit)

    self.status = status.closed
  end)

  self.read_thread:ready()
end

return session
