
describe('extension', function()
  local self = {}

  setup(function()
    self.cpath = package.cpath
    package.cpath = package.cpath .. ';./test/?.so'
  end)

  teardown(function()
    package.cpath = self.cpath
  end)

  it('test', function()
    local test = require('libtest')
    assert.are.same(3.0, test.sum(1.4, 1.6))
  end)
end)