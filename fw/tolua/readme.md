
Table of Contents
=================

* [Install](#install)
* [Samples](#samples)
  * [tarray](#tarray)
* [Reference](#reference)

Install
-------

* ```scons install```
* bin/tolua++, include/tolua++.h, lib/libtolua++.a会被安装到/usr/local
* ```scons test```
* 直接运行测试脚本

Samples
-------

貌似除了tclass，其他的例子都是tolua的格式，测试文件有问题

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

Reference
---------

* [tolua++ manual](https://www8.cs.umu.se/kurser/TDBD12/VT04/lab/lua/tolua++.html)
