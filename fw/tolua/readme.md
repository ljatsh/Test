
Table of Contents
=================

* [Install](#install)
* [Samples](#samples)
  * [tarray](#tarray)
* [Tips]
  * [C Function](#c-function)
  * [C Variable](#c-variable)
  * [Class](#class)
    * [Static Function](#static-function)
* [Reference](#reference)

Install
-------

* ```scons install```
* bin/tolua++, include/tolua++.h, lib/libtolua++.a会被安装到/usr/local
* ```scons test```
* 直接运行测试脚本

[Back to TOC](#table-of-contents)

Samples
-------

貌似除了tclass，其他的例子都是tolua的格式，测试文件有问题。tolua++有参数控制索引是否-1

tarray
------

数组a的导出，老版本
```cpp
/* get function: a */
static int tolua_get_tarray_a(lua_State* tolua_S)
{
 int tolua_index;
#ifndef TOLUA_RELEASE
 {
 tolua_Error tolua_err;
 if (!tolua_isnumber(tolua_S,2,0,&tolua_err))
 tolua_error(tolua_S,"#vinvalid type in array indexing.",&tolua_err);
 }
#endif
 tolua_index = (int)tolua_tonumber(tolua_S,2,0)-1;
#ifndef TOLUA_RELEASE
 if (tolua_index<0 || tolua_index>=10)
 tolua_error(tolua_S,"array indexing out of range.",NULL);
#endif
 tolua_pushnumber(tolua_S,(double)a[tolua_index]);
 return 1;
}
```

新版本
```cpp
/* get function: a of class  Array */
#ifndef TOLUA_DISABLE_tolua_get_tarray_Array_a
static int tolua_get_tarray_Array_a(lua_State* tolua_S)
{
 int tolua_index;
  Array* self;
 lua_pushstring(tolua_S,".self");
 lua_rawget(tolua_S,1);
 self = (Array*)  lua_touserdata(tolua_S,-1);
#ifndef TOLUA_RELEASE
 {
  tolua_Error tolua_err;
  if (!tolua_isnumber(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in array indexing.",&tolua_err);
 }
#endif
 tolua_index = (int)tolua_tonumber(tolua_S,2,0);
#ifndef TOLUA_RELEASE
 if (tolua_index<0 || tolua_index>=10)
  tolua_error(tolua_S,"array indexing out of range.",NULL);
#endif
 tolua_pushnumber(tolua_S,(lua_Number)self->a[tolua_index]);
 return 1;
}
#endif //#ifndef TOLUA_DISABLE
```
新版本的数组索引转换有明显错误

[Back to TOC](#table-of-contents)

Tips
----

C Function
----------

C的导出函数都写入到LUA_GLOBALSINDEX, 等同于_G。

* 相关注册信息

```
_G
{
  'test': function 0x1fcb840
  'sum': function 0x1fcb8a0
}
```

[Back to TOC](#table-of-contents)

C Variable
----------

全局的变量导出是会被警告的--```** tolua warning: Mapping variable to global may degrade performance.```。
变量的读写会以函数的的形式存在一个mt的.get和.set子表中， 这个mt会被设置成模块(如果是全局，则是_G)的元表，原来的元表会以现元表的元表而存在

* 相关注册信息

```
_G
{
  '.get':
  { 0x1fc9b60
    'd': function 0x1fc9be0
  }
  '.set':
  { 0x1fc9c70
    'd': function 0x1fc9cc0
  }
  mt:
  { 0x1fcb760
    '__index': function 0x1fcb7b0
    '__newindex': function 0x1fcb810
  }
}
```

* 相关代码

```cpp
TOLUA_API void tolua_module (lua_State* L, const char* name, int hasvar)
{
  ...
  if (hasvar)
	{
		if (!tolua_ismodulemetatable(L))  /* check if it already has a module metatable */
		{
			/* create metatable to get/set C/C++ variable */
			lua_newtable(L);
			tolua_moduleevents(L);
			if (lua_getmetatable(L,-2))
				lua_setmetatable(L,-2);  /* set old metatable as metatable of metatable */
			lua_setmetatable(L,-2);
		}
	}
}

static int module_index_event (lua_State* L)
{
	lua_pushstring(L,".get");
	lua_rawget(L,-3);
	if (lua_istable(L,-1))
	{
		lua_pushvalue(L,2);  /* key */
		lua_rawget(L,-2);
		if (lua_iscfunction(L,-1))
		{
			lua_call(L,0,1);
			return 1;
		}
		else if (lua_istable(L,-1))
			return 1;
	}
	/* call old index meta event */
	if (lua_getmetatable(L,1))
	{
		lua_pushstring(L,"__index");
		lua_rawget(L,-2);
		lua_pushvalue(L,1);
		lua_pushvalue(L,2);
		if (lua_isfunction(L,-1))
		{
			lua_call(L,2,1);
			return 1;
		}
		else if (lua_istable(L,-1))
		{
			lua_gettable(L,-3);
			return 1;
		}
	}
	lua_pushnil(L);
	return 1;
}
```

[Back to TOC](#table-of-contents)

Class
-----

一个class在_G中引入一个新的模块表，同时这模块表有{}='module_name'的映射

* 相关注册信息

```
table 0x2426740: 'student'
'student': 
{ 0x2426740
  'get_age': function 0x2426f60
  '__eq': function 0x2426d20
  '__gc': function 0x2425730
  '.call': function 0x2426d80
  'tolua_ubox': 
  { 0x2424930
    mt: 
    { 0x2424980
      '__mode': 'v'
    }
  }
  'set_age': function 0x2426f00
  '__newindex': function 0x24267f0
  '__call': function 0x2426bd0
  'sub': function 0x24281f0
  'delete': function 0x2426de0
  '.set': 
  { 0x2427b70
    'boy': function 0x2427bc0
  }
  '__index': function 0x2426790
  'new': function 0x2427c50
  '.collector': function 0x2424b70
  'set_name': function 0x2426e40
  'new_local': function 0x2427cb0
  '__add': function 0x24267c0
  '__div': function 0x2426ac0
  'get_name': function 0x2426ea0
  '__mul': function 0x2426ba0
  '__lt': function 0x2426af0
  '.get': 
  { 0x2424bd0
    'boy': function 0x2427b10
  }
  '__sub': function 0x2426b70
  '__le': function 0x2426b20
  mt: 
  { 0x2425a40
    '__eq': function 0x2425d50
    '__mul': function 0x2425bd0
    '__gc': function 0x2425730
    '__lt': function 0x2425b20
    '__div': function 0x2425af0
    '__index': function 0x2425780
    '__add': function 0x2425a90
    '__le': function 0x2425b50
    '__sub': function 0x2425ba0
    '__newindex': function 0x2425ac0
    '__call': function 0x2425c00
  }
}
```

* 相关代码

注册模块时，会先创建一class名命名的metatable
```cpp
static void tolua_reg_types (lua_State* tolua_S)
{
#ifndef Mtolua_typeid
#define Mtolua_typeid(L,TI,T)
#endif
 tolua_usertype(tolua_S,"student");
 Mtolua_typeid(tolua_S,typeid(student), "student");
}

TOLUA_API void tolua_usertype (lua_State* L, const char* type)
{
 char ctype[128] = "const ";
 strncat(ctype,type,120);

	/* create both metatables */
 if (tolua_newmetatable(L,ctype) && tolua_newmetatable(L,type))
	 mapsuper(L,type,ctype);             /* 'type' is also a 'const type' */
}
```

[Back to TOC](#table-of-contents)

Static Function
---------------

静态函数会直接索引到class元表中对应的方法，一个参数要求是class元表，因此要要以student:sub(10, 5)访问

* 相关函数

```cpp
#ifndef TOLUA_DISABLE_tolua_texample_student_sub00
static int tolua_texample_student_sub00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"student",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
  ...
}

/* the equivalent of lua_is* for usertable */
static  int lua_isusertable (lua_State* L, int lo, const const char* type)
{
	int r = 0;
	if (lo < 0) lo = lua_gettop(L)+lo+1;
	lua_pushvalue(L,lo);
	lua_rawget(L,LUA_REGISTRYINDEX);  /* get registry[t] */
	if (lua_isstring(L,-1))
	{
		r = strcmp(lua_tostring(L,-1),type)==0;
		if (!r)
		{
			/* try const */
			lua_pushstring(L,"const ");
			lua_insert(L,-2);
			lua_concat(L,2);
			r = lua_isstring(L,-1) && strcmp(lua_tostring(L,-1),type)==0;
		}
	}
	lua_pop(L, 1);
	return r;
}
```

[Back to TOC](#table-of-contents)

Reference
---------

* [tolua++ manual](https://www8.cs.umu.se/kurser/TDBD12/VT04/lab/lua/tolua++.html)
