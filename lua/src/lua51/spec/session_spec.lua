
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

  after_each(function()

  end)

  it('initialization', function()
    local s = session.new('127.0.0.1', 80, self.p_sb)
    -- not a good test style, but it is useful
    assert.is.no_nil(s.socket)
    assert.are.same('127.0.0.1', s.socket.host)
    assert.are.same(80, s.socket.port)
    assert.are.equal(self.p_sb, s.parser)
    assert.is_nil(s.sink)
    assert.are.equal(session.status.closed, s.status)
  end)

  -- TODO stream_socket link error fix in luv

  it('start - successfully', function()
    local s = session.new('127.0.0.1', 80, self.parser, self.sink)
    local stub_socket = stub.new(s.socket, 'connect')
    stub_socket.returns(s.socket)

    self.stub_sink_authentication.returns(true)
    
    assert.is.truthy(s:start())

    luv.sleep(0.001)
    assert.spy(self.spy_sink_connected).was.called(1)
    --assert.spy(self.spy_sink_connected).was.called_with(self.sink, s)           -- TODO
    assert.stub(self.stub_sink_authentication).was.called(1)
    --assert.stub(self.stub_sink_authentication).was.called_with(self.sink, s)
    assert.are.same(session.status.authenticated, s.status)
  end)

  it('start - connect error', function()
    local s = session.new('127.0.0.1', 80, self.parser, self.sink)
    local stub_socket = stub.new(s.socket, 'connect')
    stub_socket.returns(nil, 'connection refused')

    assert.is.truthy(s:start())

    luv.sleep(0.001)
    assert.spy(self.spy_sink_connecting_failure).was.called(1)
    --assert.spy(self.spy_sink_connecting_failure).was.called_with(s, 'connection refused')   -- TODO
    assert.spy(self.spy_sink_connected).was.called(0)
    assert.are.same(session.status.closed, s.status)
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
    -- the underline socket was closed, but sink should not be notified
    assert.spy(s.socket.close).was.called(1)
    assert.spy(self.spy_sink_disconnected).was.no.called()

    stub_print:revert()
  end)

  it('start - start again failure', function()
    local s = session.new('127.0.0.1', 80, self.parser, self.sink)
    local stub_socket = stub.new(s.socket, 'connect')
    stub_socket.returns(s.socket)

    self.stub_sink_authentication.returns(true)
    
    assert.is.truthy(s:start())

    luv.sleep(0.001)
    local ret, err = s:start()
    assert.is.falsy(ret)
    assert.are.same('session is active', err)
  end)
end)

describe('session data processing', function()
  local self = {}

  before_each(function()
    self.parser = parser.new()
    self.sink = session_event_sink.new()

    self.session = session.new('127.0.0.1', 80, self.parser, self.sink)
    local stub_socket_connect = stub.new(self.session.socket, 'connect')
    stub_socket_connect.returns(self.session.socket)
    local stub_sink_authentication = stub.new(self.sink, 'on_session_authentication')
    stub_sink_authentication.returns(true)

    assert.is.truthy(self.session:start())
    luv.sleep(0.001)
  end)

  after_each(function()

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
end)
