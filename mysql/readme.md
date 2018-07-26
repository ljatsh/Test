
MYSQL
=====

Table Of Contents
=================

* [Character Set and Collation](Charset)

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

Reference
=========

* >[TestSuit](https://dev.mysql.com/doc/dev/mysql-server/latest/PAGE_MYSQL_TEST_RUN.html)
