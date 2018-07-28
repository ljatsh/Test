
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
      database = "ngx_test",
      user = "root",
      password = "root",
      charset = "utf8",
      max_packet_size = 1024 * 1024,
    }

    lu.assertTrue(not not ok, err)
  end

  function TestMysql:tearDown()
    local ok, err = self._db:set_keepalive(5000, 100)
    lu.assertEquals(ok, 1, err)
  end

  function TestMysql:testScenario()
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

    local res, err, errcode, sqlstate = self._db:query("INSERT INTO t1 VALUES ('ljatsh', 34), ('ljatbj', 29);")
    lu.assertNotNil(res, err)
    lu.assertEquals(res.affected_rows, 2)

    res, err, errcode, sqlstate = self._db:query('SELECT * FROM t1;')
    lu.assertNotNil(res)
    lu.assertEquals(2, #res)
  end

-- end of TestMysql

return TestMysql
