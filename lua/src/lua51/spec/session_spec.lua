
local session = require('session')
local parser = require('parser.parser')
local session_event_sink = require('session_event_sink')
local luv = require('luv')

describe('session mgmt', function()
  local self = {}

  before_each(function()
    self.parser = parser.new()
    self.sink = session_event_sink.new()

    self.stub_parser_execute = stub.new(self.parser, 'execute')
    self.spy_sink_connecting_failure = spy.on(self.sink, 'on_session_connecting_failure')
    self.spy_sink_connected = spy.on(self.sink, 'on_session_connected')
    self.stub_sink_authentication = stub.new(self.sink, 'on_session_authentication')
    self.spy_sink_disconnected = spy.on(self.sink, 'on_session_disconnected')
  end)

  it('initialization', function()
    local s = session.new('127.0.0.1', 80, self.parser, self.sink)
    -- not a good test style, but it is useful
    assert.is.no_nil(s.socket)
    assert.are.same('127.0.0.1', s.socket.host)
    assert.are.same(80, s.socket.port)
    assert.are.equal(self.parser, s.parser)
    assert.are.same(self.sink, s.sink)
    assert.are.equal(session.status.closed, s.status)
  end)

  -- TODO stream_socket link error fix in luv

  it('start - successfully', function()
    local s = session.new('127.0.0.1', 80, self.parser, self.sink)
    local stub_socket_connect = stub.new(s.socket, 'connect')
    stub_socket_connect.returns(s.socket)
    -- prevent the working threads from exiting
    local stub_socket_read = stub.new(s.socket, 'read')
    stub_socket_read.by_default.invokes(function()
      luv.sleep(1000)
    end)

    self.stub_sink_authentication.returns(true)
    
    assert.is.truthy(s:start())

    luv.sleep(0.001)
    assert.spy(self.spy_sink_connected).was.called(1)
    --assert.spy(self.spy_sink_connected).was.called_with(self.sink, s)           -- TODO
    assert.stub(self.stub_sink_authentication).was.called(1)
    --assert.stub(self.stub_sink_authentication).was.called_with(self.sink, s)
    assert.are.same(session.status.authenticated, s.status)
    assert.is.not_nil(s.write_thread)
    assert.is.not_nil(s.read_thread)
  end)

  it('start - connect error', function()
    local s = session.new('127.0.0.1', 80, self.parser, self.sink)
    local stub_socket = stub.new(s.socket, 'connect')
    stub_socket.returns(nil, 'connection refused')

    assert.is.truthy(s:start())

    luv.sleep(0.001)
    assert.spy(self.spy_sink_connecting_failure).was.called(1)
    assert.spy(self.spy_sink_connecting_failure).was.called_with(self.sink, s, 'connection refused')
    assert.spy(self.spy_sink_connected).was.called(0)
    assert.are.same(session.status.closed, s.status)
    assert.is_nil(session.write_thread)
    assert.is_nil(session.read_thread)
  end)

  it('start - authentication error', function()
    local s = session.new('127.0.0.1', 80, self.parser, self.sink)
    local stub_socket = stub.new(s.socket, 'connect')
    stub_socket.returns(s.socket)
    spy.on(s.socket, 'close')
    local stub_print = stub.new(_G, 'print')

    self.stub_sink_authentication.returns(false, 'invalid password')

    assert.is.truthy(s:start())

    luv.sleep(0.001)
    assert.spy(self.spy_sink_connected).was.called(1)
    assert.stub(self.stub_sink_authentication).was.called(1)
    assert.stub(stub_print).was.called_at_least(1)
    --assert.stub(stub_print).was.called_with('authentication error: invalid password') -- TODO
    assert.are.same(session.status.closed, s.status)
    assert.is_nil(session.write_thread)
    assert.is_nil(session.read_thread)
    -- the underline socket was closed, but sink should not be notified
    assert.spy(s.socket.close).was.called(1)
    assert.spy(self.spy_sink_disconnected).was.no.called()

    stub_print:revert()
  end)

  it('start - start again failure', function()
    local s = session.new('127.0.0.1', 80, self.parser, self.sink)
    local stub_socket_connect = stub.new(s.socket, 'connect')
    stub_socket_connect.returns(s.socket)
    local stub_socket_read = stub.new(s.socket, 'read')
    stub_socket_read.by_default.invokes(function()
      luv.sleep(1000)
    end)

    self.stub_sink_authentication.returns(true)
    
    assert.is.truthy(s:start())

    luv.sleep(0.001)
    local ret, err = s:start()
    assert.is.falsy(ret)
    assert.are.same('session is active', err)
  end)

  it('stop', function()
    local s = session.new('127.0.0.1', 80, self.parser, self.sink)
    local stub_socket = stub.new(s.socket, 'connect')
    stub_socket.returns(s.socket)
    local cond = luv.cond.create()
    local stub_socket_read = stub.new(s.socket, 'read')
    stub_socket_read.by_default.invokes(function()
      return cond:wait()
    end)
    local stub_socket_close = stub.new(s.socket, 'close')
    stub_socket_close.by_default.invokes(function()
      cond:signal(false, 'closeed by self')
    end)

    self.stub_sink_authentication.returns(true)

    assert.is.truthy(s:start())
    luv.sleep(0.001)
    s:stop()
    assert.are.same(session.status.closed, s.status)
    assert.is_nil(s.main_thread)
    assert.is_nil(s.write_thread)
    assert.is_nil(s.read_thread)
  end)
end)

describe('session send data', function()
  local self = {}

  before_each(function()
    self.parser = parser.new()
    self.sink = session_event_sink.new()

    self.session = session.new('127.0.0.1', 80, self.parser, self.sink)
    local stub_socket_connect = stub.new(self.session.socket, 'connect')
    stub_socket_connect.returns(self.session.socket)
    local stub_sink_authentication = stub.new(self.sink, 'on_session_authentication')
    stub_sink_authentication.returns(true)
    local s = self.session.socket
    local stub_socket_read = stub.new(s, 'read')
    stub_socket_read.by_default.invokes(function()
      luv.sleep(1000)
    end)

    local cond_stop = luv.cond.create()
    local s = self.session.socket
    local stub_socket_close = stub.new(s, 'close')
    stub_socket_close.by_default.invokes(function()
      cond_stop:signal(false, 'closed by self')
    end)
    local stub_socket_read = stub.new(s, 'read')
    stub_socket_read.by_default.invokes(function()
      return cond_stop:wait()
    end)

    assert.is.truthy(self.session:start())
  end)

  after_each(function()
    self.session:stop()
  end)

  it('send data', function()
    local stub_socket_write = stub.new(self.session.socket, 'write')
    stub_socket_write.returns(true)

    self.session:send('0123456789')

    luv.sleep(0.001)
    assert.stub(stub_socket_write).was.called(1)
    assert.stub(stub_socket_write).was.called_with(self.session.socket, '0123456789')
  end)

  it('send data - data should be written one by one after socket writen returned', function()
    local stub_socket_write = stub.new(self.session.socket, 'write')
    stub_socket_write.returns(true)

    self.session:send('0123456789')
    luv.sleep(0.001)
    assert.stub(stub_socket_write).was.called(1)
    stub_socket_write:clear()

    local writen_times = 0
    stub_socket_write.by_default.invokes(function()
      luv.sleep(0.001)
      writen_times = writen_times + 1
      return true
    end)

    self.session:send('hello')
    luv.sleep(0.001)  
    assert.are.same(0, writen_times)

    self.session:send('lua')
    luv.sleep(0.005)

    assert.stub(stub_socket_write).was.called(2)
    assert.stub(stub_socket_write).was.called_with(self.session.socket, 'hello')
    assert.stub(stub_socket_write).was.called_with(self.session.socket, 'lua')
  end)

  it('send data - connect again', function()
    -- TODO
  end)
end)

describe('session receive data', function()
  local self = {}

  before_each(function()
    self.parser = parser.new()
    self.sink = session_event_sink.new()

    self.session = session.new('127.0.0.1', 80, self.parser, self.sink)
    local stub_socket_connect = stub.new(self.session.socket, 'connect')
    stub_socket_connect.returns(self.session.socket)
    local stub_sink_authentication = stub.new(self.sink, 'on_session_authentication')
    stub_sink_authentication.returns(true)
    self.spy_sink_on_session_message = spy.on(self.sink, 'on_session_message')
    self.spy_sink_on_session_disconnected = spy.on(self.sink, 'on_session_disconnected')
    
    self.cond_stop = luv.cond.create()
    local s = self.session.socket
    self.stub_socket_close = stub.new(s, 'close')
    self.stub_socket_close.by_default.invokes(function()
      self.cond_stop:signal(false, 'closed by self')
    end)

    assert.is.truthy(self.session:start())
  end)

  after_each(function()
    self.session:stop()
  end)

  it('read msg', function()
    local stub_socket_read = stub.new(self.session.socket, 'read')
    local done = false
    stub_socket_read.by_default.invokes(function()
      if done then
        return self.cond_stop:wait()
      end

      done = true
      return 10, '0123456789'
    end)

    local stub_parser_execute = stub.new(self.parser, 'execute')
    local data = ''
    stub_parser_execute.by_default.invokes(function(p, chr)
      data = data .. chr

      if chr == '3' or chr == '6' or chr == '9' then
        local msg = data
        data = ''
        return nil, msg
      end
    end)

    luv.sleep(0.001)
    assert.stub(stub_parser_execute).was.called(10)
    assert.spy(self.spy_sink_on_session_message).was.called(3)
    -- assert.spy(self.spy_sink_on_session_message).was.called_with(self.sink, self.session, '0123')      -- TODO
    -- assert.spy(self.spy_sink_on_session_message).was.called_with(self.sink, self.session, '456')
    -- assert.spy(self.spy_sink_on_session_message).was.called_with(self.sink, self.session, '789')
  end)

  it('socket error trigger session close event', function()
    local stub_socket_read = stub.new(self.session.socket, 'read')
    local done = false
    stub_socket_read.by_default.invokes(function()
      if done then
        return nil, 'EOF'
      end

      done = true
      return 10, '0123456789'
    end)

    local stub_parser_execute = stub.new(self.parser, 'execute')
    local data = ''
    stub_parser_execute.by_default.invokes(function(p, chr)
      data = data .. chr

      if #data == 10 then return nil, data end
    end)

    luv.sleep(0.01)
    assert.spy(self.spy_sink_on_session_message).was.called(1)
    --assert.spy(self.spy_sink_on_session_message).was.called_with(self.sink, self.session, '0123456789')

    -- closed
    assert.spy(self.spy_sink_on_session_disconnected).was.called(1)
    --assert.spy(self.spy_sink_on_session_disconnected).was.called_with(self.sink, self.session, 'EOF') -- TODO
    assert.are.same(session.status.closed, self.session.status)
  end)

  it('parser error', function()
    local stub_socket_read = stub.new(self.session.socket, 'read')
    local done = false
    stub_socket_read.by_default.invokes(function()
      if done then
        luv.sleep(1000)
      end

      done = true
      return 10, '0123456789'
    end)

    local stub_parser_execute = stub.new(self.parser, 'execute')
    local data = ''
    stub_parser_execute.by_default.invokes(function(p, chr)
      data = data .. chr

      if #data == 3 then return 'invalid message' end
    end)

    spy.on(self.session.socket, 'close')

    luv.sleep(0.01)
    assert.spy(self.spy_sink_on_session_message).was.called(0)

    -- closed
    assert.spy(self.spy_sink_on_session_disconnected).was.called(1)
    --assert.spy(self.spy_sink_on_session_disconnected).was.called_with(self.sink, self.session, 'invalid message') -- TODO
    assert.are.same(session.status.closed, self.session.status)
    assert.spy(self.session.socket.close).was.called(1)
  end)

  it('parser resume from error', function()
    local stub_socket_read = stub.new(self.session.socket, 'read')
    local times = 0
    stub_socket_read.by_default.invokes(function()
      times = times + 1

      if times == 1 then
        return 1, '1'
      end

      if times == 2 then
        return 2, '2'
      end

      luv.sleep(1000)
    end)

    local stub_parser_execute = stub.new(self.parser, 'execute')
    local data = ''
    stub_parser_execute.by_default.invokes(function(p, chr)
      if chr == '1' then
        return 'invalid message'
      end

      return nil, chr
    end)

    spy.on(self.session.socket, 'close')

    luv.sleep(0.01)
    assert.are.same(session.status.closed, self.session.status)
    assert.stub(stub_socket_read).was.called(1)

    assert(self.session:start())
  end)
end)
