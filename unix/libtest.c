
#include <lua.h>
#include <lauxlib.h>
#include <stdio.h>

// https://linux.die.net/man/3/tmpnam
static int
get_tmpfile_name(lua_State* L) {
  if (lua_gettop(L) > 0) {
    return luaL_error(L, "invalid parameters were passed to get_tmpfile_name, %d were given, expecting 1 or 0", lua_gettop(L));
  }

  char* name = tmpnam(NULL);
  if (name == NULL)
    lua_pushnil(L);
  else
    lua_pushstring(L, name);

  return 1;
}

static const struct luaL_Reg mylib[] = {
  {"tmpnam", get_tmpfile_name},
  {NULL, NULL}
};

int
luaopen_test(lua_State *L) {
  luaL_newlib(L, mylib);
  return 1;
}
