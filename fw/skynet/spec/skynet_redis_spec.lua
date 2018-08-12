
local redis = require('skynet.db.redis')

describe('skynet redis', function()
  local self = {}
  local redis_ip = '172.17.0.5'

  setup(function()

  end)

  teardown(function()

  end)

  before_each(function()
    self.redis = redis.connect{
      host = redis_ip,
      port = 6379,
      db = 0
    }
  end)

  after_each(function()
    self.redis:disconnect()
    self.redis = nil
  end)

  it('testMissingKeyValue', function()
    local res = self.redis:get('visits:0:totals')
    assert.is_nil(res, 'value of the missing key is ngx.null')
  end)

  it('testCounter', function()
    

    local ok = self.redis:set('visits:1:totals', 100)
    assert.are.same('OK', ok)

    local res = self.redis:get('visits:1:totals')
    assert.are.same('100', res, 'the value by set should be string')

    res = self.redis:incr('visits:1:totals')
    assert.are.same(101, res, 'incr returns integer')

    res = self.redis:decr('visits:1:totals')
    assert.are.same(100, res, 'decr also returns integer')

    res = self.redis:incrby('visits:1:totals', 10)
    assert.are.same(110, res, 'incrby returns integer')

    res = self.redis:incrby('visits:1:totals', "5")
    assert.are.same(115, res, 'incrby params can be string')

    res = self.redis:incrby('visits:1:totals', -10)
    assert.are.same(105, res, 'negative param')

    res = self.redis:del('visits:1:totals')
    assert.are.same(1, res) -- 1 key should be removed
  end)

  it('testHashset', function()
    self.redis:del('users:lj')

    local res = self.redis:hset('users:lj', 'name', 'ljatsh')
    assert.are.same(res, 1, 'field name was created')
    res, err = self.redis:hset('users:lj', 'age', 34)
    assert.are.same(res, 1, 'field age was created')

    -- hget
    res = self.redis:hget('users:lj', 'name')
    assert.are.same('ljatsh', res)
    res = self.redis:hget('users:lj', 'age')
    assert.are.same('34', res, 'hget returns string')

    -- hdel
    res = self.redis:hdel('users:lj', 'missing')
    assert.are.same(0, res, '0 fields was removed')

    res = self.redis:hset('users:lj', 'missing', 'missing')
    res = self.redis:hdel('users:lj', 'missing')
    assert.are.same(1, res)

    res = self.redis:hexists('users:lj', 'missing')
    assert.are.same(0, res)

    res = self.redis:hexists('users:lj', 'age')
    assert.are.same(1, res)

    -- hkeys
    res = self.redis:hkeys('users:lj')
    assert.are.same({'name', 'age'}, res)

    -- hvals
    res = self.redis:hvals('users:lj')
    assert.are.same({'ljatsh', '34'}, res)

    -- hgetall
    res = self.redis:hgetall('users:lj')
    assert.are.same({'name', 'ljatsh', 'age', '34'}, res)

    self.redis:del('users:lj')
  end)

  it('testSets', function()
    self.redis:del('circle:lj:family')
    self.redis:del('circle:sj:family')

    -- sadd/smembers/scard
    local res = self.redis:sadd('circle:lj:family', 'users:1', 'users:2')
    assert.are.same(2, res)

    res = self.redis:sadd('circle:lj:family', 'users:1', 'users:3')
    assert.are.same(1, res)

    res = self.redis:smembers('circle:lj:family')
    table.sort(res)
    assert.are.same({'users:1', 'users:2', 'users:3'}, res)

    res = self.redis:scard('circle:lj:family')
    assert.are.same(3, res)

    -- srem
    res = self.redis:srem('circle:lj:family', 'users:0')
    assert.are.same(0, res)

    res = self.redis:srem('circle:lj:family', 'users:2')
    assert.are.same(1, res)

    res = self.redis:scard('circle:lj:family')
    assert.are.same(2, res)

    -- sinter/sunion
    res = self.redis:sadd('circle:sj:family', 'users:1', 'users:3', 'users:4')
    res = self.redis:sinter('circle:lj:family', 'circle:sj:family')
    table.sort(res)
    assert.are.same({'users:1', 'users:3'}, res)

    res = self.redis:sunion('circle:lj:family', 'circle:sj:family')
    table.sort(res)
    assert.are.same({'users:1', 'users:3', 'users:4'}, res)

    self.redis:del('circle:lj:family')
    self.redis:del('circle:sj:family')
  end)
end)
