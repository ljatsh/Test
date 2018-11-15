
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
end)