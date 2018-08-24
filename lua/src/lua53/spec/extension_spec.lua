
describe('extension', function()
  local self = {}

  setup(function()
    self.cpath = package.cpath
    package.cpath = package.cpath .. ';./test/?.so'

    self.test = require('libtest')
  end)

  teardown(function()
    package.cpath = self.cpath
  end)

  it('map', function()
    local t = {1, 5, 9}
    self.test.map(t, function(v) return v * 3 end)
    assert.are.same({3, 15, 27}, t)

    assert.has.error.match(function() self.test.map() end, 'table expected, got no value')
    assert.has.error.match(function() self.test.map({}, 1) end, 'function expected, got number')
    assert.has.error(function() self.test.map({1}, function() assert(false) end) end)
  end)

  it('split', function()
    -- elment count == count of delimiters + 1
    assert.are.same({'', ''}, self.test.split(';', ';'))
    assert.are.same({''}, self.test.split('\r\n\t ', ';'))
    assert.are.same({'1', '3', '1 2', '4', ''}, self.test.split(' 1 ; 3 ; 1 2 ; 4;', ';'))
    assert.are.same({'1', '3', '1 2', '4', ''}, self.test.split(' 1 $$ 3 $$ 1 2 $$ 4$$', '$$'))
  end)
end)