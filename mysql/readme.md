
MYSQL
=====

Table Of Contents
=================

* [Character Set and Collation](#charset)
* [Database](#database)
* [Administration](#administration)
  * [Server Logs](#server_logs)
* [Reference](#reference)

Charset
=======

A character set is a set of symbols and encodings. A collation is a set of rules for comparing characters in a character set.

1. All supported character sets and collations are in information_schema.CHARACTER_SETS and COLLATION
2. **SHOW CHARACTER SET** and **SHOW COLLATION** are preferred way to query available character sets  

   |Collumn Name | Show Name|
   |------------ | ---------|
   |CHARACTER_SET_NAME  |Charset|
   |DEFAULT_COLLATE_NAME|Default collation|
   |DESCRIPTION         |Description|
   |MAXLEN              |Maxlen|

3. [Sample](r/charset.result)

reference
---------

* [Charset](https://dev.mysql.com/doc/refman/5.7/en/charset.html)
* [Information_Schema](https://dev.mysql.com/doc/refman/5.7/en/character-sets-table.html)
* [Show](https://dev.mysql.com/doc/refman/5.7/en/show-character-set.html)

[Back to TOC](#table-of-contents)

Database
========

* create

  ```sql
  CREATE {DATABASE | SCHEMA} [IF NOT EXISTS] db_name
    [create_specification] ...

  create_specification:
    [DEFAULT] CHARACTER SET [=] charset_name
  | [DEFAULT] COLLATE [=] collation_name
  ```

* alter

  ```sql
  ALTER {DATABASE | SCHEMA} [db_name]
    alter_specification ...
  ALTER {DATABASE | SCHEMA} db_name
    UPGRADE DATA DIRECTORY NAME

  alter_specification:
    [DEFAULT] CHARACTER SET [=] charset_name
  | [DEFAULT] COLLATE [=] collation_name
  ```

* drop

  ```sql
  DROP {DATABASE | SCHEMA} [IF EXISTS] db_name
  ```

* [Sample](r/database.result)

reference
---------

* [Syntax](https://dev.mysql.com/doc/refman/5.7/en/create-database.html)

[Back to TOC](#table-of-contents)

Administration
==============

Server Logs
-----------

* general query log可以用来辅助开发
* slow query log可以用来监控
* [Ref](https://dev.mysql.com/doc/refman/5.7/en/server-logs.html)

Reference
=========

* >[TestSuit](https://dev.mysql.com/doc/dev/mysql-server/latest/PAGE_MYSQL_TEST_RUN.html)
* >[Docker](https://hub.docker.com/_/mysql)
