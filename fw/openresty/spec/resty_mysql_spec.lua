
local json = require('cjson')
local mysql = require('resty.mysql')

local function create_connection(db, database, compact_arrays)
  local ok, err, errcode, sqlstate = db:connect{
    host = "172.17.0.6",
    port = 3306,
    database = database,
    user = "root",
    password = "root",
    charset = "utf8",
    compact_arrays = compact_arrays and true or false,
    max_packet_size = 1024 * 1024
  }

  return ok, err, errcode, sqlstate
end

describe('mysql', function()
  local self = {}

  setup(function()
    local err
    self.db, err = mysql:new()
    assert.is.not_nil(self.db)

    local ok, err = create_connection(self.db)
    assert.is.truthy(ok, err)

    local res, err = self.db:query(
      'DROP DATABASE IF EXISTS ngx_test;' ..
      'CREATE DATABASE ngx_test DEFAULT CHARACTER SET utf8;' ..
      'USE ngx_test;' ..
      'CREATE TABLE t1(name VARCHAR(24) NOT NULL, age TINYINT UNSIGNED DEFAULT 0);'
    )

    assert.is.truthy(res)
    while err == 'again' do
      res, err = self.db:read_result()
    end
  end)

  teardown(function()
    create_connection(self.db, 'ngx_test')
    self.db:query('DROP DATABASE ngx_test')

    assert.is.truthy(self.db:close())
  end)

  before_each(function()
    local ok, err = create_connection(self.db, 'ngx_test')
    assert.is.truthy(ok, err)

    assert.is.truthy(self.db:query('DELETE FROM t1;'))
  end)

  after_each(function()
    assert.is.truthy(self.db:query('DELETE FROM t1;'))

    local ok, err = self.db:set_keepalive(5000, 100)
    assert.are.same(1, ok, err)
  end)

  it('try usage', function()
    local res, err = self.db:query("INSERT INTO t1 VALUES ('ljatsh', 34), ('ljatbj', 29);")
    assert.is.not_nil(res, err)
    assert.are.same(2, res.affected_rows)

    res, err = self.db:query('SELECT * FROM t1;')
    assert.are.same({{name='ljatsh', age=34}, {name='ljatbj', age=29}}, res)
  end)

  -- FIXME: server_ver() was lost in reused connection
  -- function TestMysql:testSeverVersion()
  --   lu.assertStrMatches(self._db:server_ver(), '^%d+%.%d+%..*')
  -- end

  it('compact array', function()
    local db, err = mysql:new()

    local ok, err = create_connection(db, 'ngx_test', true)
    assert.is.truthy(ok, err)

    local res, err = db:query("INSERT INTO t1 VALUES ('ljatsh', 34), ('ljatbj', 29);")
    assert.is.table(res)
    assert.are.same(2, res.affected_rows)

    res, err = db:query('SELECT * FROM t1;')
    assert.are.same(res, {{'ljatsh', 34}, {'ljatbj', 29}})
  end)

  it('multiple results', function()
    local res, err = self.db:query("INSERT INTO t1 VALUES ('ljatsh', 34), ('ljatbj', 29), ('ljatxa', '18')")
    assert.are.same(3, res.affected_rows)

    local res, err = self.db:query(
      'SELECT * FROM t1 WHERE age=18;' ..
      'SELECT * FROM t1 WHERE age=29;' ..
      'SELECT * FROM t1 WHERE age=34;'
    )

    assert.are.same(res, {{name='ljatxa', age=18}})

    -- query cannot be sent out now
    local res, err2 = self.db:query('SELECT 1;')
    assert.is_nil(res)
    assert.is.match('cannot send query', err2)

    local r = {}
    while err == 'again' do
      res, err = self.db:read_result()
      table.insert(r, res[1].name)
    end

    assert.are.same({'ljatbj', 'ljatsh'}, r)

    -- query should be ok now
    res, err = self.db:query('SELECT 1;')
    assert.not_nil(res)
  end)

  -- -- TODO: how to test?
  -- function TestMysql:testConnectionPool()
  -- end
end)
