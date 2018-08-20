
#include <stdio.h>
#include <stdarg.h>
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
destroy_lua_engine(lua_State *L) {
  if (L != NULL) {
    lua_close(L);
  }
}

int
lua_execute_string(lua_State *L, const char *buff) {
  int error = luaL_dostring(L, buff);
  if (error != LUA_OK) {
    fprintf(stderr,  "%s\n", lua_tostring(L, -1));
  }

  return error;
}

int
lua_execute_func(lua_State *L, const char *name, const char *fmt, ...) {
  int ret = LUA_ERRERR;
  va_list ap;
  va_start(ap, fmt);

  do {
    int type = lua_getglobal(L, name);
    if (type != LUA_TFUNCTION) {
      break;
    }

    const char *p = fmt;
    char c;
    while ((c = *p++) != '\0') {
      switch (c) {
        case 'd':
          break;
        case 'f':
          break;
        case 's':
          break;
        case 'b':
          break;
        case '>':
          break;
      }
    }

    ret = LUA_OK;
  } while (0);

  if (ret != LUA_OK) {
    lua_settop(L, 0);
  }

  va_end(ap);

  return ret;
}
