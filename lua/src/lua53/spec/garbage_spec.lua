
describe('garbage', function()
  local self = {}
  local libtest

  setup(function()
    self.cpath = package.cpath
    package.cpath = package.cpath .. ';./test/?.so'

    libtest = require('libtest')
  end)

  teardown(function()
    package.cpath = self.cpath
  end)

  -- weak reference only makes scene to table, function and userdata
  it('weak table - key', function()
    local t = setmetatable({}, {__mode = 'k'})

    t[{}] = 1
    t[function() end] = 2
    t[1] = 3
    t[true] = 4
    t['a'] = 5
    t[libtest.new_student()] = 6

    collectgarbage()
    assert.are.same(3, t[1])
    assert.are.same(4, t[true])
    assert.are.same(5, t.a)

    t[1] = nil
    t[true] = nil
    t.a = nil

    assert.are.same({}, t)
  end)

  -- the whole entry will be erased if the value was collected
  it('weak table - value', function()
    local t = setmetatable({}, {__mode = 'v'})

    t[1] = {}
    t[2] = function() return 2 end
    t[3] = 3
    t[4] = true
    t[5] = 'a'
    t[6] = libtest.new_student()

    assert.are.same({}, t[1])
    assert.are.same(2, t[2]())
    assert.are.same(3, t[3])
    assert.are.equal(true, t[4])
    assert.are.same('a', t[5])
    assert.are.same(0, t[6]:age())

    collectgarbage()
    assert.is_nil(t[1])
    assert.is_nil(t[2])
    assert.are.same(3, t[3])
    assert.are.equal(true, t[4])
    assert.are.same('a', t[5])
    assert.is_nil(t[6])
  end)

  it('finalizer - finalizer muste be a function', function()
    -- we cannot use spy technology here
    local collects = {}
    local mt = {__gc = function(o) collects[#collects + 1] = tostring(o) end}

    local a = setmetatable({}, mt)
    local addr = tostring(a)
    a = nil
    local b = setmetatable({}, {__call = mt.__gc})
    b = nil
    collectgarbage()
    assert.are.same({addr}, collects)
  end)

  -- At the end of each garbage-collection cycle, finalizers for userdata are called in reversed order
  -- of their creation.
  it('finalizer - called in reverse order', function()
    local collects = {}
    local mt = {__gc = function(o) collects[#collects + 1] = tostring(o) end}

    local a = setmetatable({}, mt)
    local b = setmetatable({}, mt)
    local addr_a = tostring(a)
    local addr_b = tostring(b)
    a = nil
    b = nil
    collectgarbage()

    assert.are.same({addr_b, addr_a}, collects)
  end)

  it('finalizer - resurrection', function()
    -- local mt = {__gc = function(o) print('deallocates', o) end}

    -- local a = setmetatable({}, mt)
    -- print(a)
    -- local b = setmetatable({a = a}, {__gc = function(o) print('reference', o.a) end})
    -- print(b)

    -- a = nil
    -- b = nil
    -- collectgarbage()
  end)
end)