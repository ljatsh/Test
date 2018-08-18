
#include <lauxlib.h>
#include "lua_engine.h"

lua_State*
create_lua_engine() {
  return luaL_newstate();
}

void
destroy_lua_engine(lua_State* L) {
  if (L != NULL) {
    lua_close(L);
  }
}
