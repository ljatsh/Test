
local skynet = require('skynet')
local handler = require('test_handler')

describe('skynet', function()
  local text_protocol = handler.h2.text_protocol

  before_each(function()
    handler.h2.text_protocol = text_protocol
  end)

  it('timer', function()
    local now = skynet.now()
    skynet.sleep(1)
    assert.are.same(1, skynet.now() - now)
  end)

  it('service name', function()
    local self = skynet.self()
    assert.is.number(self, 'service address is number')
    assert.is.truthy(self > 0)

    local test = skynet.newservice('test', 'h1')
    assert.is.truthy(test > 0)

    -- local service name must have . suffix
    assert.are.same(test, skynet.localname('.test_h1'))
    assert.is_nil(skynet.localname('.test_unqiue'))
    skynet.name('.test_unique', test)
    assert.are.same(test, skynet.localname('.test_unique'))

    skynet.send(test, 'lua', 'exit')
  end)

  it('service call', function()
    local test = skynet.newservice('test', 'h1')
    local a, b, c, d, e = skynet.call(test, 'lua', 'dup', 'subCommand', 1, {'ljatsh', 34}, true)
    assert.are.same('subCommand', a)
    assert.are.same(1, b)
    assert.are.same({'ljatsh', 34}, c)
    assert.is.truthy(d)
    assert.is_nil(e)

    -- call cannot be used here. Response message is depend on the test service
    skynet.send(test, 'lua', 'exit')
  end)

  -- caller and called both should register text protocol
  it('protocol text', function()
    local test = skynet.newservice('test', 'h2')
    assert.has.error(function() skynet.send(test, 'text', 'hello, skynet') end, nil, 'cannot send text protocol by default')

    -- pack was called in caller service
    local protocol = handler.h2.text_protocol
    skynet.register_protocol(protocol)
    spy.on(protocol, 'pack')

    assert.has.error(function() skynet.send(test, 'text', 'hello, skynet') end)
    assert.spy(protocol.pack).was.called(1)
    assert.spy(protocol.pack).was.called_with('hello, skynet')

    -- pack should return string or userdata, size
    local s = stub.new(protocol, "pack")
    s.returns('packed')
    spy.on(protocol, 'unpack')
    assert.has.no.error(function() skynet.send(test, 'text', 'hello, skynet') end)
    assert.stub(s).was.called_with('hello, skynet')

    -- unpack was called in the callee service
    skynet.sleep(1)
    assert.spy(protocol.unpack).was.called(0)

    local ret = skynet.call(test, 'text', '')
    assert.are.same('packed', ret)

    s:revert()
  end)
end)