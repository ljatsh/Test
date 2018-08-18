
local sp = require('snippets')
local hp = require('helper')

describe('snippets', function()
  it('set_default', function()
    local t = {x = 1, y = 2}
    sp.set_default(t, 0)

    assert.are.same(1, t.x)
    assert.are.same(0, t.z)

    local loops = {}
    for k, v in pairs(t) do loops[k] = v end
    assert.are.same({x = 1, y = 2}, loops)
  end)

  it('proxy', function()
    local obj = {x = 1, y = 2}
    local proxy = sp.proxy(obj)

    -- index
    local s = stub.new(_G, 'print')
    assert.are.same(1, proxy.x)
    assert.stub(s).was.called(1)
    s:clear()

    -- newindex
    assert.is_nil(proxy.z)
    s:clear()
    proxy.z = 1
    assert.stub(s).was.called(1)
    assert.are.same(1, proxy.z)
    s:clear()

    -- iterate
    local loops = {}
    for k, v in pairs(proxy) do loops[k] = v end
    assert.are.same({x = 1, y = 2, z = 1}, loops)
    assert.stub(s).was.called(3)
    s:clear()

    s:revert()

    -- len
    obj = {1, 2, 3}
    proxy = sp.proxy(obj)
    assert.are.same(3, #proxy)
  end)
end)