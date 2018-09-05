
local session = require('session')
local parser = require('parser.parser')
local session_event_sink = require('session_event_sink')

describe('session', function()
  local self = {}

  before_each(function()
    self.parser = parser.new()
    self.sink = session_event_sink.new()

    self.stub_parser_execute = stub.new(self.parser, 'execute')
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

  it('start', function()
    local s = session.new('127.0.0.1', 999, self.parser, self.sink)
    
    assert.is.truthy(s:start())
    
    s:stop()
  end)
end)
