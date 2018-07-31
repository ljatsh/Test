
local lu = require('luaunit')
local json = require('cjson')
local redis = require('resty.redis')

local TestRedis = {}

  function TestRedis:setUp()
    self.redis = redis:new()
    self.redis:set_timeout(1000)

    local ok, err = self.redis:connect('172.17.0.5', 6379)
    lu.assertTrue(not not ok, err)
  end

  function TestRedis:tearDown()
  end

  function TestRedis:tearMissingKeyValue()
    local res, err = self.redis:get('visits:0:totals')
    lu.assertEquals(res, ngx.null, 'value of the missing key is ngx.null')
  end

  function TestRedis:testCounter()
    self.redis:del('visits:1:totals')

    local ok, err = self.redis:set('visits:1:totals', 100)
    lu.assertEquals('OK', ok, err)

    local res, err = self.redis:get('visits:1:totals')
    lu.assertEquals(res, '100', 'the value by set should be string')

    res, err = self.redis:incr('visits:1:totals')
    lu.assertEquals(res, 101, 'incr returns integer')

    res, err = self.redis:decr('visits:1:totals')
    lu.assertEquals(res, 100, 'decr also returns integer')

    res, err = self.redis:incrby('visits:1:totals', 10)
    lu.assertEquals(res, 110, 'incrby returns integer')

    res, err = self.redis:incrby('visits:1:totals', "5")
    lu.assertEquals(res, 115, 'incrby params can be string')

    res, err = self.redis:incrby('visits:1:totals', -10)
    lu.assertEquals(res, 105, 'negative param')

    res, err = self.redis:del('visits:1:totals')
    lu.assertEquals(res, 1, err) -- 1 key should be removed
  end

  function TestRedis:testHashset()
    self.redis:del('users:lj')

    local res, err = self.redis:hset('users:lj', 'name', 'ljatsh')
    lu.assertEquals(1, res, 'field name was created')
    res, err = self.redis:hset('users:lj', 'age', 34)
    lu.assertEquals(1, res, 'field age was created')

    -- hget
    res, err = self.redis:hget('users:lj', 'name')
    lu.assertEquals(res, 'ljatsh')
    res, err = self.redis:hget('users:lj', 'age')
    lu.assertEquals(res, '34', 'hget returns string')

    -- hdel
    res, err = self.redis:hdel('users:lj', 'missing')
    lu.assertEquals(0, res, '0 fields was removed')

    res, err = self.redis:hset('users:lj', 'missing', 'missing')
    res, err = self.redis:hdel('users:lj', 'missing')
    lu.assertEquals(1, res)

    res, err = self.redis:hexists('users:lj', 'missing')
    lu.assertEquals(res, 0)

    res, err = self.redis:hexists('users:lj', 'age')
    lu.assertEquals(res, 1)

    -- hkeys
    res, err = self.redis:hkeys('users:lj')
    lu.assertEquals(#res, 2)

    -- hvals
    res, err = self.redis:hvals('users:lj')
    lu.assertEquals(#res, 2)

    -- hgetall
    res, err = self.redis:hgetall('users:lj')
    lu.assertEquals(#res, 4)

    self.redis:del('users:lj')
  end

  function TestRedis:testSets()

  end

  

-- end of TestRedis

return TestRedis
