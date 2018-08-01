
local json = require('cjson')
local redis = require('resty.redis')

describe('redis', function()
  local self = {}

  setup(function()
    self.redis = redis:new()
    self.redis:set_timeout(1000)
  end)

  teardown(function()

  end)

  before_each(function()
    local ok, err = self.redis:connect('172.17.0.5', 6379)
    assert.truthy(ok, err)
  end)

  after_each(function()
    local ok, err = self.redis:set_keepalive(5000, 100)
    assert.are.same(1, ok, err)
  end)

  it('testMissingKeyValue', function()
    local res, err = self.redis:get('visits:0:totals')
    assert.are.same(ngx.null, res, 'value of the missing key is ngx.null')
  end)

  it('testCounter', function()
    self.redis:del('visits:1:totals')

    local ok, err = self.redis:set('visits:1:totals', 100)
    assert.are.same(ok, 'OK', err)

    local res, err = self.redis:get('visits:1:totals')
    assert.are.same('100', res, 'the value by set should be string')

    res, err = self.redis:incr('visits:1:totals')
    assert.are.same(101, res, 'incr returns integer')

    res, err = self.redis:decr('visits:1:totals')
    assert.are.same(100, res, 'decr also returns integer')

    res, err = self.redis:incrby('visits:1:totals', 10)
    assert.are.same(110, res, 'incrby returns integer')

    res, err = self.redis:incrby('visits:1:totals', "5")
    assert.are.same(115, res, 'incrby params can be string')

    res, err = self.redis:incrby('visits:1:totals', -10)
    assert.are.same(105, res, 'negative param')

    res, err = self.redis:del('visits:1:totals')
    assert.are.same(1, res, err) -- 1 key should be removed
  end)

  it('testHashset', function()
    self.redis:del('users:lj')

    local res, err = self.redis:hset('users:lj', 'name', 'ljatsh')
    assert.are.same(res, 1, 'field name was created')
    res, err = self.redis:hset('users:lj', 'age', 34)
    assert.are.same(res, 1, 'field age was created')

    -- hget
    res, err = self.redis:hget('users:lj', 'name')
    assert.are.same('ljatsh', res)
    res, err = self.redis:hget('users:lj', 'age')
    assert.are.same('34', res, 'hget returns string')

    -- hdel
    res, err = self.redis:hdel('users:lj', 'missing')
    assert.are.same(0, res, '0 fields was removed')

    res, err = self.redis:hset('users:lj', 'missing', 'missing')
    res, err = self.redis:hdel('users:lj', 'missing')
    assert.are.same(1, res)

    res, err = self.redis:hexists('users:lj', 'missing')
    assert.are.same(0, res)

    res, err = self.redis:hexists('users:lj', 'age')
    assert.are.same(1, res)

    -- hkeys
    res, err = self.redis:hkeys('users:lj')
    assert.are.same({'name', 'age'}, res)

    -- hvals
    res, err = self.redis:hvals('users:lj')
    assert.are.same({'ljatsh', '34'}, res)

    -- hgetall
    res, err = self.redis:hgetall('users:lj')
    assert.are.same({'name', 'ljatsh', 'age', '34'}, res)

    self.redis:del('users:lj')
  end)

  it('testSets', function()
    self.redis:del('circle:lj:family')
    self.redis:del('circle:sj:family')

    -- sadd/smembers/scard
    local res, err = self.redis:sadd('circle:lj:family', 'users:1', 'users:2')
    assert.are.same(2, res)

    res, err = self.redis:sadd('circle:lj:family', 'users:1', 'users:3')
    assert.are.same(1, res)

    res, err = self.redis:smembers('circle:lj:family')
    table.sort(res)
    assert.are.same({'users:1', 'users:2', 'users:3'}, res)

    res, err = self.redis:scard('circle:lj:family')
    assert.are.same(3, res)

    -- srem
    res, err = self.redis:srem('circle:lj:family', 'users:0')
    assert.are.same(0, res)

    res, err = self.redis:srem('circle:lj:family', 'users:2')
    assert.are.same(1, res)

    res, err = self.redis:scard('circle:lj:family')
    assert.are.same(2, res)

    -- sinter/sunion
    res, err = self.redis:sadd('circle:sj:family', 'users:1', 'users:3', 'users:4')
    res, err = self.redis:sinter('circle:lj:family', 'circle:sj:family')
    table.sort(res)
    assert.are.same({'users:1', 'users:3'}, res)

    res, err = self.redis:sunion('circle:lj:family', 'circle:sj:family')
    table.sort(res)
    assert.are.same({'users:1', 'users:3', 'users:4'}, res)

    self.redis:del('circle:lj:family')
    self.redis:del('circle:sj:family')
  end)
end)
