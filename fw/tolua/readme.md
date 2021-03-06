
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
    * [Create Instance](#create-instance)
    * [Access Instance Method](#access-instance-method)
    * [Inheritance](#inheritance)
    * [Delete Instance](#delete-instance)
* [Reference](#reference)
* [TODO](#todo)

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

Create Instance
---------------

* 测试代码

```lua
  local s = student:new('lj@sh', 35)
  print(s)

  -- ouput
  -- sutdent 0x1ff37c0 was allocated
  -- userdata: 0x1ff3b38
```

* 相关注册信息

返回的userdata会以student作为mt, userdata本身存储的是native对象的地址

```
  'student': 
  { 0x1ff0740
    'get_age': function 0x1ff0f60
    '__eq': function 0x1ff0d20
    '__gc': function 0x1fef730
    '.call': function 0x1ff0d80
    'tolua_ubox': 
    { 0x1fee930
      lightuserdata 0x1ff37c0: userdata 0x1ff3b38
      mt: 
      { 0x1fee980
        '__mode': 'v'
      }
    }
    'set_age': function 0x1ff0f00
    '__newindex': function 0x1ff07f0
    '__call': function 0x1ff0bd0
    'sub': function 0x1ff21f0
    'delete': function 0x1ff0de0
    '.set': 
    { 0x1ff1b70
      'boy': function 0x1ff1bc0
    }
    '__index': function 0x1ff0790
    'new': function 0x1ff1c50
    '.collector': function 0x1feeb70
    'set_name': function 0x1ff0e40
    'new_local': function 0x1ff1cb0
    '__add': function 0x1ff07c0
    '__div': function 0x1ff0ac0
    'get_name': function 0x1ff0ea0
    '__mul': function 0x1ff0ba0
    '__lt': function 0x1ff0af0
    '.get': 
    { 0x1feebd0
      'boy': function 0x1ff1b10
    }
    '__sub': function 0x1ff0b70
    '__le': function 0x1ff0b20
    mt: table 0x1fefa40
  }
```

* 相关代码

```cpp
TOLUA_API void tolua_pushusertype (lua_State* L, void* value, const char* type)
{
 if (value == NULL)
  lua_pushnil(L);
 else
 {
  luaL_getmetatable(L, type);
  lua_pushstring(L,"tolua_ubox");
  lua_rawget(L,-2);        /* stack: mt ubox */
  if (lua_isnil(L, -1)) {
	  lua_pop(L, 1);
	  lua_pushstring(L, "tolua_ubox");
	  lua_rawget(L, LUA_REGISTRYINDEX);
  };
  lua_pushlightuserdata(L,value);
  lua_rawget(L,-2);                       /* stack: mt ubox ubox[u] */
  if (lua_isnil(L,-1))
  {
   lua_pop(L,1);                          /* stack: mt ubox */
   lua_pushlightuserdata(L,value);
   *(void**)lua_newuserdata(L,sizeof(void *)) = value;   /* stack: mt ubox u newud */
   lua_pushvalue(L,-1);                   /* stack: mt ubox u newud newud */
   lua_insert(L,-4);                      /* stack: mt newud ubox u newud */
   lua_rawset(L,-3);                      /* stack: mt newud ubox */
   lua_pop(L,1);                          /* stack: mt newud */
   /*luaL_getmetatable(L,type);*/
   lua_pushvalue(L, -2);			/* stack: mt newud mt */
   lua_setmetatable(L,-2);			/* stack: mt newud */

   #ifdef LUA_VERSION_NUM
   lua_pushvalue(L, TOLUA_NOPEER);
   lua_setfenv(L, -2);
   #endif
  }
 }
 ...
}
```

[Back to TOC](#table-of-contents)

Access Instance Method
----------------------

* 相关代码
  userdata的index访问顺序如下:
  * 如果peer表中有对应的值，则返回它(TODO)
  * 直接转到类的元表找到对应的键， 如果key为number，则转为访问.geti函数； 否则，按照对应的值、变量的顺序循环访问下去
  找到对应的到处函数后，userdata解释成对应的native对象，进行访问

```cpp
static int class_index_event (lua_State* L)
{
 int t = lua_type(L,1);
	if (t == LUA_TUSERDATA)
	{
		/* Access alternative table */
		#ifdef LUA_VERSION_NUM /* new macro on version 5.1 */
		lua_getfenv(L,1);
		if (!lua_rawequal(L, -1, TOLUA_NOPEER)) {
			lua_pushvalue(L, 2); /* key */
			lua_gettable(L, -2); /* on lua 5.1, we trade the "tolua_peers" lookup for a gettable call */
			if (!lua_isnil(L, -1))
				return 1;
		};
		#else
		lua_pushstring(L,"tolua_peers");
		lua_rawget(L,LUA_REGISTRYINDEX);        /* stack: obj key ubox */
		lua_pushvalue(L,1);
		lua_rawget(L,-2);                       /* stack: obj key ubox ubox[u] */
		if (lua_istable(L,-1))
		{
			lua_pushvalue(L,2);  /* key */
			lua_rawget(L,-2);                      /* stack: obj key ubox ubox[u] value */
			if (!lua_isnil(L,-1))
				return 1;
		}
		#endif
		lua_settop(L,2);                        /* stack: obj key */
		/* Try metatables */
		lua_pushvalue(L,1);                     /* stack: obj key obj */
		while (lua_getmetatable(L,-1))
		{                                       /* stack: obj key obj mt */
			lua_remove(L,-2);                      /* stack: obj key mt */
			if (lua_isnumber(L,2))                 /* check if key is a numeric value */
			{
				/* try operator[] */
				lua_pushstring(L,".geti");
				lua_rawget(L,-2);                      /* stack: obj key mt func */
				if (lua_isfunction(L,-1))
				{
					lua_pushvalue(L,1);
					lua_pushvalue(L,2);
					lua_call(L,2,1);
					return 1;
				}
			}
			else
			{
			 lua_pushvalue(L,2);                    /* stack: obj key mt key */
				lua_rawget(L,-2);                      /* stack: obj key mt value */
				if (!lua_isnil(L,-1))
					return 1;
				else
					lua_pop(L,1);
				/* try C/C++ variable */
				lua_pushstring(L,".get");
				lua_rawget(L,-2);                      /* stack: obj key mt tget */
				if (lua_istable(L,-1))
				{
					lua_pushvalue(L,2);
					lua_rawget(L,-2);                      /* stack: obj key mt value */
					if (lua_iscfunction(L,-1))
					{
						lua_pushvalue(L,1);
						lua_pushvalue(L,2);
						lua_call(L,2,1);
						return 1;
					}
					else if (lua_istable(L,-1))
					{
						/* deal with array: create table to be returned and cache it in ubox */
						void* u = *((void**)lua_touserdata(L,1));
						lua_newtable(L);                /* stack: obj key mt value table */
						lua_pushstring(L,".self");
						lua_pushlightuserdata(L,u);
						lua_rawset(L,-3);               /* store usertype in ".self" */
						lua_insert(L,-2);               /* stack: obj key mt table value */
						lua_setmetatable(L,-2);         /* set stored value as metatable */
						lua_pushvalue(L,-1);            /* stack: obj key met table table */
						lua_pushvalue(L,2);             /* stack: obj key mt table table key */
						lua_insert(L,-2);               /*  stack: obj key mt table key table */
						storeatubox(L,1);               /* stack: obj key mt table */
						return 1;
					}
				}
			}
			lua_settop(L,3);
		}
		lua_pushnil(L);
		return 1;
	}
	else if (t== LUA_TTABLE)
	{
		module_index_event(L);
		return 1;
	}
	lua_pushnil(L);
	return 1;
}
```

Inheritance
-----------

* 父类mt作为子类mt的mt，使得继承成为现实。最终父类mt的mt是tolua_commonclass
* 有继承关系类的mt、对应的const版本类的mt，有继承关系保存在tolua_super中，方便做类型转换
* 如果lua对象是一个基类对象，则不能访问具体类对应的私有方法，如果确实需要访问，只能先做tolua.cast操作

* 相关注册

```
{ 0x1f2e370
  table 0x1f32200: 'stuff'
  'tolua_gc_event': function 0x1f30730
  'tolua_commonclass': 
  { 0x1f30a40
    '__eq': function 0x1f30d50
    '__mul': function 0x1f30bd0
    '__gc': function 0x1f30730
    '__lt': function 0x1f30b20
    '__div': function 0x1f30af0
    '__index': function 0x1f30780
    '__add': function 0x1f30a90
    '__le': function 0x1f30b50
    '__sub': function 0x1f30ba0
    '__newindex': function 0x1f30ac0
    '__call': function 0x1f30c00
  }
  table 0x1f30a40: 'tolua_commonclass'
  '_LOADED': 
  { 0x1f2ee10
    'coroutine': 
    { 0x1f30190
      'resume': function 0x1f303c0
      'yield': function 0x1f30540
      'status': function 0x1f30480
      'wrap': function 0x1f304e0
      'create': function 0x1f2ee60
      'running': function 0x1f30420
    }
    '_G': 
    { 0x1f2e2c0
      'xpcall': function 0x1f2f540
      'tostring': function 0x1f2f420
      'print': function 0x1f2f5c0
      'unpack': function 0x1f2f4e0
      '.set': 
      { 0x1f2f880
        'd': function 0x1f2f8d0
      }
      'getfenv': function 0x1f2efb0
      'setmetatable': function 0x1f2f360
      'next': function 0x1f2f180
      'assert': function 0x1f2ee90
      'stuff': 
      { 0x1f32200
        'get_id': function 0x1f33eb0
        '__eq': function 0x1f32810
        '__mul': function 0x1f32690
        '.call': function 0x1f34020
        'unique': function 0x1f32840
        '__newindex': function 0x1f322b0
        '__call': function 0x1f326c0
        'delete': function 0x1f34050
        '.collector': function 0x1f31c50
        '__gc': function 0x1f30730
        'new_local': function 0x1f33ff0
        '__add': function 0x1f32280
        '__div': function 0x1f325b0
        'new': function 0x1f33fc0
        'tolua_ubox': 
        { 0x1f2f930
          lightuserdata 0x1f329b0: userdata 0x1f35b88
          lightuserdata 0x1f35910: userdata 0x1f35968
          mt: 
          { 0x1f2f980
            '__mode': 'v'
          }
        }
        '__lt': function 0x1f325e0
        '__index': function 0x1f32250
        '__sub': function 0x1f32660
        '__le': function 0x1f32610
        mt: 
        { 0x1f31740
          'get_id': function 0x1f33d10
          'get_age': function 0x1f31f60
          '__eq': function 0x1f31d20
          '__gc': function 0x1f30730
          '.call': function 0x1f31d80
          'create': function 0x1f33da0
          'tolua_ubox': table 0x1f2f930
          'set_age': function 0x1f31f00
          '__newindex': function 0x1f317f0
          '__call': function 0x1f31bd0
          'sub': function 0x1f33d70
          'delete': function 0x1f31de0
          '.set': 
          { 0x1f33690
            'boy': function 0x1f336e0
          }
          '__index': function 0x1f31790
          'new': function 0x1f33770
          '.collector': function 0x1f2fb90
          'set_name': function 0x1f31e40
          'new_local': function 0x1f337d0
          '__add': function 0x1f317c0
          '__div': function 0x1f31ac0
          'get_name': function 0x1f31ea0
          '__mul': function 0x1f31ba0
          '__lt': function 0x1f31af0
          '.get': 
          { 0x1f2fbf0
            'boy': function 0x1f33630
          }
          '__sub': function 0x1f31b70
          '__le': function 0x1f31b20
          mt: table 0x1f30a40
        }
      }
      'tonumber': function 0x1f2f3c0
      'rawequal': function 0x1f2f620
      'collectgarbage': function 0x1f2eef0
      'getmetatable': function 0x1f2f240
      'rawset': function 0x1f2f6e0
      'dump_lua': function 0x1f32870
      'student': table 0x1f31740
      'load': function 0x1f2f0c0
      '_VERSION': 'Lua 5.1'
      'test': function 0x1f32b60
      'pcall': function 0x1f2f1e0
      'tolua': 
      { 0x1f30c60
        'cast': function 0x1f31160
        'type': function 0x1f30cb0
        'releaseownership': function 0x1f30ce0
        'getpeer': function 0x1f31340
        'setpeer': function 0x1f310b0
        'takeownership': function 0x1f31010
        'inherit': function 0x1f311c0
      }
      'coroutine': table 0x1f30190
      'type': function 0x1f2f480
      'newproxy': function 0x1f300f0
      '_G': table 0x1f2e2c0
      'select': function 0x1f2e310
      'gcinfo': function 0x1f2ef50
      'pairs': function 0x1f2ec90
      'rawget': function 0x1f2f680
      'loadstring': function 0x1f2f120
      'ipairs': function 0x1f2ebf0
      'sum': function 0x1f32bc0
      'dofile': function 0x1f2f000
      'setfenv': function 0x1f2f300
      '.get': 
      { 0x1f2f770
        'd': function 0x1f2f7f0
      }
      'error': function 0x1f2f060
      'loadfile': function 0x1f2f2a0
      mt: 
      { 0x1f32740
        '__index': function 0x1f32790
        '__newindex': function 0x1f32ad0
      }
    }
  }
  table 0x1f31fe0: 'const stuff'
  'stuff': table 0x1f32200
  'const stuff': 
  { 0x1f31fe0
    '__eq': function 0x1f322f0
    'tolua_ubox': table 0x1f2f930
    '.collector': function 0x1f33e20
    '__mul': function 0x1f32170
    '__gc': function 0x1f30730
    '__lt': function 0x1f320c0
    '__div': function 0x1f32090
    '__index': function 0x1f31ce0
    '__add': function 0x1f32030
    '__le': function 0x1f320f0
    '__sub': function 0x1f32140
    '__newindex': function 0x1f32060
    '__call': function 0x1f321a0
    mt: table 0x1f32200
  }
  'tolua_ubox': 
  { 0x1f30600
    mt: 
    { 0x1f30650
      '__mode': 'v'
    }
  }
  table 0x1f31740: 'student'
  'student': table 0x1f31740
  table 0x1f313a0: 'const student'
  'const student': 
  { 0x1f313a0
    '__eq': function 0x1f309d0
    'tolua_ubox': table 0x1f2f930
    '.collector': function 0x1f2fbc0
    '__mul': function 0x1f316b0
    '__gc': function 0x1f30730
    '__lt': function 0x1f30970
    '__div': function 0x1f30940
    '__index': function 0x1f308b0
    '__add': function 0x1f308e0
    '__le': function 0x1f309a0
    '__sub': function 0x1f31680
    '__newindex': function 0x1f30910
    '__call': function 0x1f316e0
    mt: table 0x1f31740
  }
  'tolua_gc': 
  { 0x1f30860
  }
  'tolua_super': 
  { 0x1f307e0
    table 0x1f313a0: 
    { 0x1f2fa00
      'const ': true
    }
    table 0x1f31740: 
    { 0x1f31c00
      'const student': true
      '': true
    }
    table 0x1f32200: 
    { 0x1f326f0
      'const student': true
      '': true
      'student': true
      'const stuff': true
    }
    table 0x1f31fe0: 
    { 0x1f33dd0
      'const student': true
      'const ': true
    }
  }
  'tolua_opened': true
} 
```

* 相关代码

```cpp
static void mapinheritance (lua_State* L, const char* name, const char* base)
{
	/* set metatable inheritance */
	luaL_getmetatable(L,name);

	if (base && *base)
		luaL_getmetatable(L,base);
	else {

		if (lua_getmetatable(L, -1)) { /* already has a mt, we don't overwrite it */
			lua_pop(L, 2);
			return;
		};
		luaL_getmetatable(L,"tolua_commonclass");
	};

	set_ubox(L);

	lua_setmetatable(L,-2);
	lua_pop(L,1);
}
```

Delete Instance
---------------

TODO

Reference
---------

* [tolua++ manual](https://www8.cs.umu.se/kurser/TDBD12/VT04/lab/lua/tolua++.html)

TODO
----

* 继承中的tolua_ubox, tolua_super, tolua_cast等细节
* 内存释放机制，如何通过peer扩展类
