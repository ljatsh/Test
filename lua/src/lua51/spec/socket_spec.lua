
local luv = require('luv')
local sock = require('socket')
local hp = require('helper')

describe('socket', function()
  local self = {}
  self.net = {}

  local mock_sock = {
    connect = function() end,
    nodelay = function() end,
    close = function() end,
    read = function() end,
    write = function() end
  }

  local function connect(ip, port)
    local s = stub.new(mock_sock, 'connect')
    s.returns('127.0.0.1')

    return (sock.connect(ip, port))
  end

  before_each(function()
    self.net.getaddrinfo = stub.new(luv.net, 'getaddrinfo')
    self.net.getaddrinfo.returns('127.0.0.1')

    self.net.tcp = stub.new(luv.net, 'tcp')
    self.net.tcp.returns(mock_sock)
  end)

  after_each(function()
    self.net.getaddrinfo:revert()
    self.net.tcp:revert()
  end)

  it('connect failure', function()
    local s = stub.new(mock_sock, 'connect')
    s.returns(nil, 'connection refused')

    local socket, err = sock.connect('mysql', 3306)
    assert.is_nil(socket)
    assert.are.same('connection refused', err)
  end)

  it('connect success', function()
    local s = stub.new(mock_sock, 'connect')
    s.returns('127.0.0.1')
    spy.on(mock_sock, 'nodelay')

    local socket, err = sock.connect('mysql', 3306)
    assert.are.same({sock = mock_sock,
                     ip = '127.0.0.1',
                     port = 3306,
                     connected = true}, socket)
    assert.is_nil(err)

    assert.stub(self.net.getaddrinfo).was.called_with('mysql')
    assert.stub(self.net.tcp).was.called(1)
    assert.spy(mock_sock.nodelay).was.called(1)
    assert.spy(mock_sock.nodelay).was.called_with(mock_sock, true)

    -- mt
    assert.is_function(socket.write)
    assert.is_function(socket.read)
    assert.is_function(socket.close)
  end)

  it('close', function()
    local socket = connect('mysql', 3306)
    assert.is.truthy(socket.connected)

    spy.on(mock_sock, 'close')

    socket:close()
    assert.is.falsy(socket.connected)
    assert.spy(mock_sock.close).was.called(1)
  end)

  it('write/read when disconnected', function()
    local socket = connect('mysql', 3306)
    socket:close()

    local r, err = socket:write('1')
    assert.is.falsy(r)
    assert.is.match('disconnected', err)

    local count, bin = socket:read()
    assert.is_nil(count)
    assert.is.match('disconnected', bin)
  end)

  it('write', function()
    local socket = connect('mysql', 3306)
    assert.is.table(socket)

    local s = stub.new(mock_sock, 'write')

    -- write successfully
    s.returns(true)
    local r, err = socket:write('1')
    assert.is.truthy(r)
    assert.is_nil(err)

    -- write error
    s.returns(false, 'network error')
    spy.on(mock_sock, 'close')
    local r, err = socket:write('1')
    assert.is_falsy(r)
    assert.are.same('network error', err)
    assert.is.falsy(socket.connected)
    -- native close should be called to avoid resource leak
    assert.spy(mock_sock.close).was.called()

    s:clear()
  end)

  it('read', function()
    local socket = connect('mysql', 3306)
    assert.is.table(socket)

    local s = stub.new(mock_sock, 'read')

    -- read successfully
    s.returns(10, '0123456789')
    local count, bin = socket:read()
    assert.are.same(10, count)
    assert.are.same('0123456789', bin)

    -- read failure
    s.returns(false, 'network error')
    spy.on(mock_sock, 'close')
    count, bin = socket:read()
    assert.is.falsy(count)
    assert.are.same('network error', bin)
    assert.is.falsy(socket.connected)
    -- native close should be called to avoid resource leak
    assert.spy(mock_sock.close).was.called()

    s:clear()
  end)
end)