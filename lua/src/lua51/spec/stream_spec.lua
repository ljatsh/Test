
local luv = require('luv')
local class = require('class')
local stream = require('stream')
local stream_socket = require('stream_socket')
local hp = require('helper')

describe('stream', function()
  local mock_stream = class(stream)

  function mock_stream:close_impl() end
  function mock_stream:write_impl() end
  function mock_stream:read_impl() end

  it('init', function()
    local s = stream.new()
    assert.is.falsy(s:is_open())
    s:set_opened()
    assert.is.truthy(s:is_open())

    s:close()
    assert.is.falsy(s:is_open())
  end)

  it('close', function()
    local s = mock_stream.new()
    spy.on(s, 'close_impl')
    s:close()
    assert.spy(s.close_impl).was.called(0)

    s:set_opened()
    s:close()
    assert.spy(s.close_impl).was.called(1)
  end)

  it('write/read when closed', function()
    local s = mock_stream.new()

    local r, err = s:write('1')
    assert.is.falsy(r)
    assert.are.same('stream was not opened', err)

    local count, data = s:read()
    assert.is.falsy(count)
    assert.is.match('stream was not opened', data)
  end)

  it('write', function()
    local s = mock_stream.new()

    assert.is.falsy(s:is_open())
    s:set_opened()

    local sb = stub.new(s, 'write_impl')

    -- write successfully
    sb.returns(true)
    local r, err = s:write('1')
    assert.is.truthy(r)
    assert.is_nil(err)

    -- write error
    sb.returns(false, 'network error')
    spy.on(s, 'close_impl')
    local r, err = s:write('1')
    assert.is_falsy(r)
    assert.are.same('network error', err)
    assert.is.falsy(s:is_open())
    -- native close should be called to avoid resource leak
    assert.spy(s.close_impl).was.called(1)
  end)

  it('read', function()
    local s = mock_stream.new()
    s:set_opened()

    local sb = stub.new(s, 'read_impl')
    local sp = spy.on(s, 'close_impl')

    -- read successfully
    sb.returns(10, '0123456789')
    local count, data = s:read()
    assert.are.same(10, count)
    assert.are.same('0123456789', data)

    -- read 0
    sb.returns(0, nil)
    count, data = s:read()
    assert.are.same(0, count)
    assert.is_nil(data)
    assert.spy(sp).was.called(0)

    -- read EOF
    sb.returns(nil)
    count, data = s:read()
    assert.is_nil(count)
    assert.is_nil(data)
    assert.is.falsy(s:is_open())
    assert.spy(sp).was.called(1)

    sp:clear()
    s:set_opened()

    -- read failure
    sb.returns(false, 'network error')
    count, data = s:read()
    assert.is.falsy(count)
    assert.are.same('network error', data)
    assert.is.falsy(s:is_open())
    -- native close should be called to avoid resource leak
    assert.spy(sp).was.called(1)
  end)
end)

describe('socket', function()
  local self = {}
  self.net = {}

  local mock_socket = {
    connect = function() end,
    nodelay = function() end,
    close = function() end,
    read = function() end,
    write = function() end
  }

  local function connect(ip, port)
    local s = stub.new(mock_socket, 'connect')
    s.returns('127.0.0.1')

    return (sock.connect(ip, port))
  end

  before_each(function()
    self.net.getaddrinfo = stub.new(luv.net, 'getaddrinfo')
    self.net.getaddrinfo.returns('127.0.0.1')

    self.net.tcp = stub.new(luv.net, 'tcp')
    self.net.tcp.returns(mock_socket)
  end)

  after_each(function()
    self.net.getaddrinfo:revert()
    self.net.tcp:revert()
  end)

  it('init', function()
    local s = stream_socket.new('mysql', 3306)
    assert.are.same('mysql', s.host)
    assert.are.same(3306, s.port)
    assert.are.is_nil(s.s)
    assert.are.is_nil(s.ip)
  end)

  it('connect failure', function()
    local sb = stub.new(mock_socket, 'connect')
    sb.returns(nil, 'connection refused')

    local s = stream_socket.new('mysql', 3306)
    local ret, err = s:connect()
    assert.is_nil(ret)
    assert.are.same('connection refused', err)
    assert.is.falsy(s:is_open())
    assert.stub(sb).was.called_with(mock_socket, '127.0.0.1', 3306)
  end)

  it('connect success', function()
    local sb = stub.new(mock_socket, 'connect')
    sb.returns('127.0.0.1')
    local sp = spy.on(mock_socket, 'nodelay')

    local s = stream_socket.new('mysql', 3306)
    local ret, err = s:connect()
    assert.are.equal(s, ret)
    assert.is_nil(err)
    assert.is.truthy(s:is_open())
    assert.are.same(3306, s.port)

    assert.stub(self.net.getaddrinfo).was.called_with('mysql')
    assert.stub(self.net.tcp).was.called(1)
    assert.spy(mock_socket.nodelay).was.called(1)
    assert.spy(mock_socket.nodelay).was.called_with(mock_socket, true)
    assert.stub(sb).was.called_with(mock_socket, '127.0.0.1', 3306)

    sp:clear()
  end)
end)
