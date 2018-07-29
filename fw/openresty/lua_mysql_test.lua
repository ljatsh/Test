
local lu = require('luaunit')
local json = require('cjson')
local mysql = require('resty.mysql')

local TestMysql = {}

  function TestMysql:setUp()
    local err
    self._db, err = mysql:new()
    lu.assertNotNil(self._db)

    local ok, err, errcode, sqlstate = self._db:connect{
      host = "172.17.0.2",
      port = 3306,
      user = "root",
      password = "root",
      charset = "utf8",
      max_packet_size = 1024 * 1024
    }

    lu.assertTrue(not not ok, err)

    local query = {
      'DROP DATABASE IF EXISTS ngx_test;',
      'CREATE DATABASE ngx_test DEFAULT CHARACTER SET utf8;',
      'USE ngx_test;',
      'CREATE TABLE t1(name VARCHAR(24) NOT NULL, age TINYINT UNSIGNED DEFAULT 0);'
    }

    for _, q in ipairs(query) do
      local res, err, errcode, sqlstate = self._db:query(q)

      lu.assertNotNil(res, err)
    end
  end

  function TestMysql:tearDown()
    self._db:query('DROP DATABASE ngx_test')

    local ok, err = self._db:set_keepalive(5000, 100)
    lu.assertEquals(ok, 1, err)
  end

  function TestMysql:testScenario()
    local res, err, errcode, sqlstate = self._db:query("INSERT INTO t1 VALUES ('ljatsh', 34), ('ljatbj', 29);")
    lu.assertNotNil(res, err)
    lu.assertEquals(res.affected_rows, 2)

    res, err, errcode, sqlstate = self._db:query('SELECT * FROM t1;')
    lu.assertNotNil(res)
    lu.assertEquals(2, #res)
  end

  -- FIXME: server_ver() was lost in reused connection
  -- function TestMysql:testSeverVersion()
  --   lu.assertStrMatches(self._db:server_ver(), '^%d+%.%d+%..*')
  -- end

  -- TODO I cannot understand compact_array now. table.new native API?
  function TestMysql:testCompactArrays()
    local db, err = mysql:new()
    lu.assertNotNil(db)

    local ok, err, errcode, sqlstate = db:connect{
      host = "172.17.0.2",
      port = 3306,
      database = "ngx_test",
      user = "root",
      password = "root",
      charset = "utf8",
      max_packet_size = 1024 * 1024,
      compack_array = true
    }

    lu.assertTrue(not not ok, err)

    local res, err, errcode, sqlstate = self._db:query("INSERT INTO t1 VALUES ('ljatsh', 34), ('ljatbj', 29);")
    lu.assertNotNil(res, err)
    lu.assertEquals(res.affected_rows, 2)

    res, err, errcode, sqlstate = self._db:query('SELECT * FROM t1;')
    lu.assertNotNil(res)
    lu.assertEquals(2, #res)
  end

  function TestMysql:testMultipleResultset()
    local res, err, errcode, sqlstate = self._db:query("INSERT INTO t1 VALUES ('ljatsh', 34), ('ljatbj', 29), ('ljatxa', '18')")
    lu.assertNotNil(res, err)
    lu.assertEquals(res.affected_rows, 3)

    local res, err, errcode, sqlstate = self._db:query(
      'SELECT * FROM t1 WHERE age=18;' ..
      'SELECT * FROM t1 WHERE age=29;' ..
      'SELECT * FROM t1 WHERE age=34;'
    )

    lu.assertEquals(#res, 1, err)
    lu.assertEquals(res[1].name, 'ljatxa', err)

    -- query cannot be sent out now
    res, err2, errcode, sqlstate = self._db:query('SELECT 1;')
    lu.assertNil(res)
    lu.assertStrContains(err2, 'cannot send query')

    local r = {}
    while err == 'again' do
      res, err, errcode, sqlstate = self._db:read_result()
      table.insert(r, res[1].name)
    end

    lu.assertEquals(r, {'ljatbj', 'ljatsh'})

    -- query should be ok now
    res, err, errcode, sqlstate = self._db:query('SELECT 1;')
    lu.assertNotNil(res)
  end

  -- -- TODO: how to test?
  -- function TestMysql:testConnectionPool()
  -- end
  
-- end of TestMysql

return TestMysql
