
#include <stdio.h>
#include <lauxlib.h>
#include <lualib.h>
#include "lua_engine.h"

lua_State*
create_lua_engine() {
  lua_State* L = luaL_newstate();
  luaL_openlibs(L);

  return L;
}

void
destroy_lua_engine(lua_State* L) {
  if (L != NULL) {
    lua_close(L);
  }
}

int
lua_execute_string(lua_State* L, const char* buff) {
  int error = luaL_dostring(L, buff);
  if (error != LUA_OK) {
    fprintf(stderr,  "%s\n", lua_tostring(L, -1));
  }

  return error;
}
