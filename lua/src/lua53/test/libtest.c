
#include <lua.h>
#include <lauxlib.h>

static int
sum(lua_State *L) {
  double num1 = luaL_checknumber(L, 1);
  double num2 = luaL_checknumber(L, 2);

  lua_pushnumber(L, num1 + num2);
  return 1;
}

static const struct luaL_Reg mylib[] = {
  {"sum", sum},
  {NULL, NULL}
};

int
luaopen_libtest(lua_State *L) {
  luaL_newlib(L, mylib);
  return 1;
}
