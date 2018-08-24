
#include <string.h>
#include <ctype.h>
#include <lua.h>
#include <lauxlib.h>

void
push_lstring_with_space_trimed(lua_State *L, const char *s, int len) {
  if (len == 0) {
    lua_pushstring(L, "");
    return;
  }

  const char* end = s + len - 1;

  // skip left space
  while (isspace(*s))
    s++;

  // skip right space
  while (isspace(*end))
    end--;

  if (s > end) {
    lua_pushstring(L, "");
    return;
  }

  lua_pushlstring(L, s, (int)(end - s + 1));
}

void
push_string_with_space_trimed(lua_State *L, const char *s) {
  push_lstring_with_space_trimed(L, s, strlen(s));
}

static int
sum(lua_State *L) {
  double num1 = luaL_checknumber(L, 1);
  double num2 = luaL_checknumber(L, 2);

  lua_pushnumber(L, num1 + num2);
  return 1;
}

static int
map(lua_State *L) {
  // 1st parameter is table
  luaL_checktype(L, 1, LUA_TTABLE);
  // 2nd parameter is function
  luaL_checktype(L, 2, LUA_TFUNCTION);

  int len = luaL_len(L, 1);
  for (int i=1; i<=len; i++) {
    lua_pushvalue(L, 2);           // t, f, f
    lua_geti(L, 1, i);        // t, f, f, v
    lua_call(L, 1, 1);       // t, f, 1
    lua_seti(L, 1, i);        // t, f
  }

  return 0;
}

static int
split(lua_State *L) {
  const char* s = luaL_checkstring(L, 1);
  const char* delimiter = luaL_checkstring(L, 2);
  int deli_len = strlen(delimiter);

  const char* p = s;
  const char* end = s;
  lua_newtable(L);        // s, delimiter, t
  int i = 1;

  do {
    end = strstr(p, delimiter);

    if (end == NULL) {
      push_string_with_space_trimed(L, p);
    }
    else {
      push_lstring_with_space_trimed(L, p, (int)(end - p));
      p = end + deli_len;
    }

    lua_seti(L, 3, i++);
    if (end == NULL)
      break;

  } while (1);

  return 1;
}

static const struct luaL_Reg mylib[] = {
  {"sum", sum},
  {"map", map},
  {"split", split},
  {NULL, NULL}
};

int
luaopen_libtest(lua_State *L) {
  luaL_newlib(L, mylib);
  return 1;
}
