
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

struct student {
  int age;
  char name[24];
};

const char* student_mt = "libtest.student";

static int
new_student(lua_State* L) {
  int size = lua_gettop(L);
  if (size > 2) {
    luaL_error(L, "invalid parameters of new_student");
    return 0;
  }

  int age = 0;
  const char* name = NULL;
  size_t length = 0;
  if (size >= 1) {
    age = luaL_checkinteger(L, 1);
  }

  if (size == 2) {
    name = luaL_checklstring(L, 2, &length);
  }

  size_t max_length = sizeof(struct student);
  struct student* s = (struct student*)lua_newuserdata(L, max_length);
  memset(s, 0, max_length);
  s->age = age;
  memcpy(s->name, name, length > (max_length - 1) ? (max_length - 1) : length);

  // set metatable
  luaL_getmetatable(L, student_mt);
  lua_setmetatable(L, -2);

  return 1;
}

static int
student_age(lua_State* L) {
  struct student* s = (struct student*)luaL_checkudata(L, 1, student_mt);
  lua_pushinteger(L, s->age);

  return 1;
}

static int
student_set_age(lua_State* L) {
  struct student* s = (struct student*)luaL_checkudata(L, 1, student_mt);
  int age = luaL_checkinteger(L, 2);
  s->age = age;

  return 0;
}

static int
student_name(lua_State* L) {
  struct student* s = (struct student*)luaL_checkudata(L, 1, student_mt);
  lua_pushstring(L, s->name);

  return 1;
}

static int
student_set_name(lua_State* L) {
  struct student* s = (struct student*)luaL_checkudata(L, 1, student_mt);
  size_t length = 9;
  const char* name = luaL_checklstring(L, 2, &length);
  memcpy(s->name, name, length > (sizeof(struct student) - 1) ? (sizeof(struct student) - 1) : length);

  return 0;
}

static const struct luaL_Reg mylib[] = {
  {"sum", sum},
  {"map", map},
  {"split", split},
  {"new_student", new_student},
  {NULL, NULL}
};

static const struct luaL_Reg student_funcs[] = {
  {"age", student_age},
  {"set_age", student_set_age},
  {"name", student_name},
  {"set_name", student_set_name},
  {NULL, NULL}
};

int
luaopen_libtest(lua_State *L) {
  luaL_newmetatable(L, student_mt);
  lua_pushvalue(L, -1);
  lua_setfield(L, -2, "__index");
  luaL_setfuncs(L, student_funcs, 0);

  luaL_newlib(L, mylib);
  return 1;
}
