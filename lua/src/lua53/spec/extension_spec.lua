
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

  it('userdata', function()
    local s = self.test.new_student()
    assert.are.same(0, s:age())
    assert.are.same('', s:name())

    s:set_age(11)
    s:set_name('ljatsh')
    assert.are.same(11, s:age())
    assert.are.same('ljatsh', s:name())

    s = self.test.new_student(12)
    assert.are.same(12, s:age())
    assert.are.same('', s:name())

    s = self.test.new_student(13, 'ljatsh')
    assert.are.same(13, s:age())
    assert.are.same('ljatsh', s:name())

    assert.has.error.match(function() self.test.new_student(13, 'ljatsh', false) end, 'invalid parameters')
  end)
end)