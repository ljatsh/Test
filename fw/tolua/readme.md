
Table of Contents
=================

* [Install](#install)
* [Samples](#samples)
  * [tarray](#tarray)
* [Tips]
  * [C Function](#c-function)
  * [C Variable](#c-variable)
* [Reference](#reference)

Install
-------

* ```scons install```
* bin/tolua++, include/tolua++.h, lib/libtolua++.a会被安装到/usr/local
* ```scons test```
* 直接运行测试脚本

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

tolua_module

Reference
---------

* [tolua++ manual](https://www8.cs.umu.se/kurser/TDBD12/VT04/lab/lua/tolua++.html)
