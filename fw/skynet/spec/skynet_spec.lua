
require('skynet.manager')
local skynet = require('skynet')

describe('skynet', function()
  it('timer', function()
    local now = skynet.now()
    skynet.sleep(1)
    assert.are.same(1, skynet.now() - now)

    now = skynet.time()
    skynet.sleep(100)
    assert.are.same(1, skynet.time() - now)
  end)

  it('service name', function()
    local self = skynet.self()
    assert.is.number(self, 'service address is number')
    assert.is.truthy(self > 0)

    local test = skynet.newservice('test', 'h1')
    assert.is.truthy(test > 0)
    -- TODO
    -- assert.are.same(test, skynet.localname('test_h1'))
    -- assert.is_nil(skynet.localname('test_unqiue'))
    -- skynet.name('test_unique', test)
    -- assert.are.same(test, skynet.localname('test_unique'))

    --skynet.kill(test)
  end)

  -- it('service call', function()
  --   local test = skynet.newservice('test', 'h1')
  --   local a, b, c, d, e = skynet.call(test, 'lua', 'dup', 'subCommand', 1, {'ljatsh', 34}, true)
  --   assert.are.same('subCommand', a)
  --   assert.are.same(1, b)
  --   assert.are.same({'ljatsh', 34}, c)
  --   assert.is.truthy(d)
  --   assert.is_nil(e)

  --   skynet.call(test, 'lua', 'exit')
  -- end)
end)