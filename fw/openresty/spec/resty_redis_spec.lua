
local json = require('cjson')
local redis = require('resty.redis')

describe('redis', function()
  local self = {}

  setup(function()
    self.redis = redis:new()
    self.redis:set_timeout(1000)

    local ok, err = self.redis:connect('172.17.0.5', 6379)
    assert.truthy(ok, err)
  end)

  teardown(function()
    local ok, err = self.redis:set_keepalive(5000, 100)
    assert.are.equal(ok, 1, err)
  end)

  it('testMissingKeyValue', function()
    local res, err = self.redis:get('visits:0:totals')
    assert.are.equal(res, ngx.null, 'value of the missing key is ngx.null')
  end)

  it('testCounter', function()
    self.redis:del('visits:1:totals')

    local ok, err = self.redis:set('visits:1:totals', 100)
    assert.are.equal('OK', ok, err)

    local res, err = self.redis:get('visits:1:totals')
    assert.are.equal(res, '100', 'the value by set should be string')

    res, err = self.redis:incr('visits:1:totals')
    assert.are.equal(res, 101, 'incr returns integer')

    res, err = self.redis:decr('visits:1:totals')
    assert.are.equal(res, 100, 'decr also returns integer')

    res, err = self.redis:incrby('visits:1:totals', 10)
    assert.are.equal(res, 110, 'incrby returns integer')

    res, err = self.redis:incrby('visits:1:totals', "5")
    assert.are.equal(res, 115, 'incrby params can be string')

    res, err = self.redis:incrby('visits:1:totals', -10)
    assert.are.equal(res, 105, 'negative param')

    res, err = self.redis:del('visits:1:totals')
    assert.are.equal(res, 1, err) -- 1 key should be removed
  end)

  it('testHashset', function()
    self.redis:del('users:lj')

    local res, err = self.redis:hset('users:lj', 'name', 'ljatsh')
    assert.are.equal(1, res, 'field name was created')
    res, err = self.redis:hset('users:lj', 'age', 34)
    assert.are.equal(1, res, 'field age was created')

    -- hget
    res, err = self.redis:hget('users:lj', 'name')
    assert.are.equal(res, 'ljatsh')
    res, err = self.redis:hget('users:lj', 'age')
    assert.are.equal(res, '34', 'hget returns string')

    -- hdel
    res, err = self.redis:hdel('users:lj', 'missing')
    assert.are.equal(0, res, '0 fields was removed')

    res, err = self.redis:hset('users:lj', 'missing', 'missing')
    res, err = self.redis:hdel('users:lj', 'missing')
    assert.are.equal(1, res)

    res, err = self.redis:hexists('users:lj', 'missing')
    assert.are.equal(res, 0)

    res, err = self.redis:hexists('users:lj', 'age')
    assert.are.equal(res, 1)

    -- hkeys
    res, err = self.redis:hkeys('users:lj')
    assert.are.equal(#res, 2)

    -- hvals
    res, err = self.redis:hvals('users:lj')
    assert.are.equal(#res, 2)

    -- hgetall
    res, err = self.redis:hgetall('users:lj')
    assert.are.equal(#res, 4)

    self.redis:del('users:lj')
  end)

  it('testSets', function()

  end)
end)
