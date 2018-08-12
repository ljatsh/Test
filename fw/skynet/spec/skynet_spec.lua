
local skynet = require('skynet')
local dns = require('skynet.dns')
local httpc = require('http.httpc')
local mysql = require('skynet.db.mysql')
local redis = require('skynet.db.redis')
local handler = require('test_handler')

local function dump(obj)
  local getIndent, quoteStr, wrapKey, wrapVal, dumpObj
  getIndent = function(level)
      return string.rep("\t", level)
  end
  quoteStr = function(str)
      return '"' .. string.gsub(str, '"', '\\"') .. '"'
  end
  wrapKey = function(val)
      if type(val) == "number" then
          return "[" .. val .. "]"
      elseif type(val) == "string" then
          return "[" .. quoteStr(val) .. "]"
      else
          return "[" .. tostring(val) .. "]"
      end
  end
  wrapVal = function(val, level)
      if type(val) == "table" then
          return dumpObj(val, level)
      elseif type(val) == "number" then
          return val
      elseif type(val) == "string" then
          return quoteStr(val)
      else
          return tostring(val)
      end
  end
  dumpObj = function(obj, level)
      if type(obj) ~= "table" then
          return wrapVal(obj)
      end
      level = level + 1
      local tokens = {}
      tokens[#tokens + 1] = "{"
      for k, v in pairs(obj) do
          tokens[#tokens + 1] = getIndent(level) .. wrapKey(k) .. " = " .. wrapVal(v, level) .. ","
      end
      tokens[#tokens + 1] = getIndent(level - 1) .. "}"
      return table.concat(tokens, "\n")
  end
  return dumpObj(obj, 0)
end

describe('skynet', function()
  local text_protocol = handler.h2.text_protocol

  before_each(function()
    handler.h2.text_protocol = text_protocol

    httpc.dns()
  end)

  it('timer', function()
    local now = skynet.now()
    skynet.sleep(1)
    assert.are.same(1, skynet.now() - now)
  end)

  it('service name', function()
    local self = skynet.self()
    assert.is.number(self, 'service address is number')
    assert.is.truthy(self > 0)

    local test = skynet.newservice('test', 'h1')
    assert.is.truthy(test > 0)

    -- local service name must have . suffix
    assert.are.same(test, skynet.localname('.test_h1'))
    assert.is_nil(skynet.localname('.test_unqiue'))
    skynet.name('.test_unique', test)
    assert.are.same(test, skynet.localname('.test_unique'))

    skynet.send(test, 'lua', 'exit')
  end)

  it('service call', function()
    local test = skynet.newservice('test', 'h1')
    local a, b, c, d, e = skynet.call(test, 'lua', 'dup', 'subCommand', 1, {'ljatsh', 34}, true)
    assert.are.same('subCommand', a)
    assert.are.same(1, b)
    assert.are.same({'ljatsh', 34}, c)
    assert.is.truthy(d)
    assert.is_nil(e)

    -- call cannot be used here. Response message is depend on the test service
    skynet.send(test, 'lua', 'exit')
  end)

  -- caller and callee both should register text protocol
  it('protocol text', function()
    local test = skynet.newservice('test', 'h2')
    assert.has.error(function() skynet.send(test, 'text', 'hello, skynet') end, nil, 'cannot send text protocol by default')

    -- pack was called in caller service
    local protocol = handler.h2.text_protocol
    skynet.register_protocol(protocol)
    spy.on(protocol, 'pack')

    assert.has.error(function() skynet.send(test, 'text', 'hello, skynet') end)
    assert.spy(protocol.pack).was.called(1)
    assert.spy(protocol.pack).was.called_with('hello, skynet')

    -- pack should return string or userdata, size
    local s = stub.new(protocol, "pack")
    s.returns('packed')
    spy.on(protocol, 'unpack')
    assert.has.no.error(function() skynet.send(test, 'text', 'hello, skynet') end)
    assert.stub(s).was.called_with('hello, skynet')

    -- unpack was called in the callee service
    skynet.sleep(1)
    assert.spy(protocol.unpack).was.called(0)

    local ret = skynet.call(test, 'text', '')
    assert.are.same('packed', ret)

    s:revert()
    skynet.send(test, 'lua', 'exit')
  end)

  it('dns', function()
    local server = dns.server()
    assert.is.string(server, 'server from /etc/resolver.conf should be configured')
    assert.has.match('^%d+%.%d+%.%d+%.%d+$', server)

    local ip, ips = dns.resolve("github.com")
    assert.has.match('^%d+%.%d+%.%d+%.%d+$', ip)
    assert.is.truthy(#ips >= 1)
    assert.are.same(ip, ips[1], 'the 1st candidate ip is the 1st returned value')

    for k, v in ipairs(ips) do
      assert.has.match('^%d+%.%d+%.%d+%.%d+$', v)
    end

    -- error test
    server = dns.server('8.8.8.8')
    assert.has.error(function() dns.resolve('not_exist_site') end)
    assert.has.no.error(function() pcall(dns.resolve, 'not_exist_site') end)
  end)

  it('http', function()
    httpc.timeout = 100 -- 1 seconds
    local response_headers = {}
    local status, body = httpc.get("baidu.com", "/", response_headers)
    assert.are.same(200, status)
    assert.is.string(body)
    --assert.is.truthy(#response_headers > 0)

    -- error test
    httpc.timeout = 10 -- 0.1 seconds
    assert.has.error(function() httpc.get('8.8.8.8', '/', response_headers) end)
    assert.has.no.error(function() pcall(httpc.get, '8.8.8.8', '/', response_headers) end)
  end)
end)

describe('skynet mysql', function()
  local self = {}
  local mysql_ip = '172.17.0.6'

  local function connect_db(ip, db, compact_array, cb)
    return mysql.connect{
      host = ip,
      port = 3306,
      database = db,
      user = 'root',
      password = 'root',
      max_packet_size = 1024 * 1024,
      compact_arrays = compact_array or false,
      on_connect = cb
    }
  end

  setup(function()
    local t = {cb = function(...) end}
    spy.on(t, 'cb')
    local db = connect_db(mysql_ip, nil, false, t.cb)
    assert.is.table(db)
    assert.spy(t.cb).was.called(1)      -- connected callback should be called

    db:query(
      'DROP DATABASE IF EXISTS skynet_test;' ..
      'CREATE DATABASE skynet_test DEFAULT CHARACTER SET utf8;' ..
      'USE skynet_test;' ..
      'CREATE TABLE t1(name VARCHAR(24) NOT NULL, age TINYINT UNSIGNED DEFAULT 0);'
    )
  end)

  teardown(function()
    local db = connect_db(mysql_ip, 'skynet_test')
    db:query('DROP DATABASE skynet_test')

    db:disconnect()
  end)

  before_each(function()
    self.db = connect_db(mysql_ip, 'skynet_test')
    assert.is.table(self.db)

    self.db:query('DELETE FROM t1;')
  end)

  after_each(function()
    self.db:query('DELETE FROM t1;')
    self.db:disconnect()
  end)

  it('normal usage scenario', function()
    local res = self.db:query("INSERT INTO t1 VALUES ('ljatsh', 34), ('ljatbj', 29);")
    assert.are.same(2, res.affected_rows)

    res = self.db:query('SELECT * FROM t1 ORDER BY age DESC;')
    assert.are.same({{name='ljatsh', age=34}, {name='ljatbj', age=29}}, res)
  end)

  it('compact array', function()
    local db = connect_db(mysql_ip, 'skynet_test', true)

    local res = db:query("INSERT INTO t1 VALUES ('ljatsh', 34), ('ljatbj', 29);")
    assert.are.same(2, res.affected_rows)

    res = db:query('SELECT * FROM t1 ORDER BY age DESC;')
    assert.are.same(res, {{'ljatsh', 34}, {'ljatbj', 29}})
  end)

  it('multiple results', function()
    local res = self.db:query("INSERT INTO t1 VALUES ('ljatsh', 34), ('ljatbj', 29), ('ljatxa', '18')")
    assert.are.same(3, res.affected_rows)

    local res = self.db:query(
      'SELECT * FROM t1 WHERE age=18;' ..
      'SELECT * FROM t1 WHERE age=29;' ..
      'SELECT * FROM t1 WHERE age=34;'
    )

    assert.is.truthy(res.mulitresultset)
    assert.are.same({{name='ljatxa', age=18}}, res[1])
    assert.are.same({{name='ljatbj', age=29}}, res[2])
    assert.are.same({{name='ljatsh', age=34}}, res[3])
  end)
end)

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
