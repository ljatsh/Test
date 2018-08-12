local mysql = require('skynet.db.mysql')

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