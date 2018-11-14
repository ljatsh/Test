
#include <gtest/gtest.h>
#include "header.hpp"
#include "lua.hpp"

class LuaTest : public ::testing::Test {
  protected:
    void SetUp() override {
      L = create_lua_engine();
    }

    void TearDown() override {
      destroy_lua_engine(L);
      L = nullptr;
    }

    lua_State* L;
};

static int
counter(lua_State *L) {
  int size = lua_gettop(L);
  int value = luaL_checkinteger(L, 1);
  
  // upvalue indexed are pseudo indices
  int index_base = lua_upvalueindex(1);
  int index_step = lua_upvalueindex(2);
  int base = lua_tointeger(L, index_base);
  int step = lua_tointeger(L, index_step);
  int ret = base + step++ + value;

  // save upvalue
  lua_pushinteger(L, step);
  lua_replace(L, index_step);

  lua_pushinteger(L, size);         // size
  lua_pushinteger(L, index_base);   // index_base
  lua_pushinteger(L, index_step);   // index_step
  lua_pushinteger(L, ret);          // ret

  return 4;
}

static int
newCounter(lua_State *L) {
  int base = luaL_checkinteger(L, 1);
  int step = luaL_checkinteger(L, 2);

  lua_pushinteger(L, base);
  lua_pushinteger(L, step);
  lua_pushcclosure(L, counter, 2);      // the two upvalues were poped out

  return 1;
}

TEST_F(LuaTest, CheckVersion) {
  ASSERT_STRCASEEQ("3", LUA_VERSION_MINOR) << "assure we are running Lua 5.3";
}

// only nil itself is nil
TEST_F(LuaTest, LuaTypNil) {
  lua_pushnil(L);
  lua_pushboolean(L, 0);

  EXPECT_TRUE(lua_isnil(L, 1));
  EXPECT_FALSE(lua_isnil(L, 2));
}

// only integer itself can be integer
TEST_F(LuaTest, LuaTypeInteger) {
  lua_pushinteger(L, 1);
  lua_pushnumber(L, 1.2);
  lua_pushstring(L, "1");
  lua_pushboolean(L, 1);

  EXPECT_TRUE(lua_isinteger(L, 1));
  EXPECT_FALSE(lua_isinteger(L, 2));
  EXPECT_FALSE(lua_isinteger(L, 3));
  EXPECT_FALSE(lua_isinteger(L, 4));
}

// number/integer/string can be number
TEST_F(LuaTest, LuaTypeNumber) {
  lua_pushnumber(L, 1.1);
  lua_pushinteger(L, 1);
  lua_pushstring(L, "1");
  lua_pushstring(L, "hello");
  lua_pushboolean(L, 0);

  EXPECT_TRUE(lua_isnumber(L, 1));
  EXPECT_TRUE(lua_isnumber(L, 2));  // integer
  EXPECT_TRUE(lua_isnumber(L, 3));  // valid string
  EXPECT_FALSE(lua_isnumber(L, 4));
  EXPECT_FALSE(lua_isnumber(L, 5)); 
}

// only boolean itself canbe boolean
// boolean is 1 or 0
TEST_F(LuaTest, LuaTypeBoolean) {
  lua_pushboolean(L, 0);
  lua_pushinteger(L, 0);

  EXPECT_TRUE(lua_isboolean(L, 1));
  EXPECT_FALSE(lua_isboolean(L, 2));

  lua_pushboolean(L, 2);
  EXPECT_EQ(1, lua_toboolean(L, 3));
}

// string/integer/number canbe string
TEST_F(LuaTest, LuaTypeString) {
  lua_pushstring(L, "hello");
  lua_pushinteger(L, 2);
  lua_pushnumber(L, 3.4);
  lua_pushboolean(L, 2);
  
  EXPECT_TRUE(lua_isstring(L, 1));
  EXPECT_TRUE(lua_isstring(L, 2)); // integer
  EXPECT_TRUE(lua_isstring(L, 3)); // number
  EXPECT_FALSE(lua_isstring(L, 4));
}

// 1. lua_settable and lua_gettable is the general way to write/read a table
// 2. lua_setfiled and lua_getfild writes/reads a table by string key
// 3. lua_seti and lua_geti writes/reads a table by index
// 4. every read/write API has a corresponed raw API
TEST_F(LuaTest, LuaTypeTable) {
  lua_newtable(L);
  EXPECT_TRUE(lua_istable(L, 1));

  // get/set field by key
  lua_getfield(L, 1, "age");            // table, nil
  EXPECT_EQ(2, lua_gettop(L));
  EXPECT_TRUE(lua_isnil(L, 2));
  lua_pop(L, 1);

  lua_pushinteger(L, 34);               // table 34
  lua_setfield(L, 1, "age");            // table
  EXPECT_EQ(1, lua_gettop(L));
  lua_getfield(L, 1, "age");            // table 34
  EXPECT_EQ(34, lua_tointeger(L, 2));
  lua_pop(L, 1);                        // table

  // get/set field by index
  lua_geti(L, 1, 10);                   // table nil
  EXPECT_TRUE(lua_isnil(L, 2));
  lua_pop(L, 1);

  lua_pushstring(L, "ljatsh");          // table ljatsh
  lua_seti(L, 1, 10);                   // table
  EXPECT_EQ(1, lua_gettop(L));

  lua_geti(L, 1, 10);                   // table ljatsh
  EXPECT_STRCASEEQ("ljatsh", lua_tostring(L, 2));
  lua_pop(L, 1);
}

// lua_getglobal/lua_setglobal
TEST_F(LuaTest, GlobalVariable) {
  EXPECT_EQ(LUA_TNIL, lua_getglobal(L, "name"));
  EXPECT_EQ(1, lua_gettop(L));
  EXPECT_TRUE(lua_isnil(L, 1));
  lua_pop(L, 1);

  EXPECT_EQ(LUA_OK, lua_execute_string(L, "name = 'ljatsh'"));
  EXPECT_EQ(0, lua_gettop(L));

  EXPECT_EQ(LUA_TSTRING, lua_getglobal(L, "name"));
  EXPECT_EQ(1, lua_gettop(L));
  EXPECT_STRCASEEQ("ljatsh", lua_tostring(L, 1));
  lua_pop(L, 1);

  lua_pushboolean(L, 1);
  lua_setglobal(L, "sex");
  
  EXPECT_EQ(LUA_TBOOLEAN, lua_getglobal(L, "sex"));
  EXPECT_EQ(1, lua_toboolean(L, 1));
  lua_pop(L, 1);
}

TEST_F(LuaTest, CallLuaFunc) {
  const char *s =
  "function sum(...)\n"
  "  local sum = 0\n"
  "  for _, v in ipairs{...} do\n"
  "    sum = sum + v\n"
  "  end\n"
  "  return sum\n"
  "end";

  EXPECT_EQ(LUA_OK, lua_execute_string(L, s));

  EXPECT_EQ(LUA_TFUNCTION, lua_getglobal(L, "sum"));
  lua_pushnumber(L, 1.0);
  lua_pushnumber(L, 1.3);
  lua_pushinteger(L, 3);
  lua_call(L, 3, 1);

  EXPECT_EQ(1, lua_gettop(L));
  EXPECT_FLOAT_EQ(5.3, lua_tonumber(L, -1));
}

// 1. LUA_REGISTRYINDEX is a pseudo stack indices. It can be used in many C API except for thouse
//    which requires valid stack index(lua_remove, lua_insert etc.)
// 2. Registry is the way to share values by C code among different modules.
//    The preferred key is a light userdata with the address of a c object.
// 3. Integer keys should not used as keys. It is used by the reference mechanism.
// 4. Registy has no metatable. A more preferred way to access it is lua_rawgetp/lua_rawsetp
TEST_F(LuaTest, Registry) {
  // lightuserdata key
  static char cKey1, cKey2;

  lua_pushlightuserdata(L, &cKey1);
  lua_pushinteger(L, 10);
  lua_settable(L, LUA_REGISTRYINDEX);

  lua_pushinteger(L, 15);
  lua_rawsetp(L, LUA_REGISTRYINDEX, &cKey2);
  EXPECT_EQ(0, lua_gettop(L));

  lua_rawgetp(L, LUA_REGISTRYINDEX, &cKey1);
  EXPECT_EQ(10, lua_tointeger(L, 1));

  lua_pushlightuserdata(L, &cKey2);
  lua_gettable(L, LUA_REGISTRYINDEX);
  EXPECT_EQ(15, lua_tointeger(L, 2));

  lua_settop(L, 0);

  // global lua value can also be keys. However, it is much less conveninent.
  const char *s = "lua_key = {}";
  EXPECT_EQ(LUA_OK, lua_execute_string(L, s));
  
  EXPECT_EQ(LUA_TTABLE, lua_getglobal(L, "lua_key"));
  lua_pushinteger(L, 13);
  lua_settable(L, LUA_REGISTRYINDEX);
  
  EXPECT_EQ(LUA_TTABLE, lua_getglobal(L, "lua_key"));
  lua_gettable(L, LUA_REGISTRYINDEX);
  EXPECT_EQ(13, lua_tointeger(L, -1));
}

// TEST_F(LuaTest, Reference) {
//   // int ref = luaL_ref(_L, LUA_REGISTRYINDEX);
//   // ASSERT_EQ(LUA_REFNIL, ref) << "a special use case, results in -1 returned from lua_gettop<---TODO";

//   // get the function
//   lua_getglobal(_L, "getFunc");
//   lua_pushinteger(_L, 4);
//   pcall(1, 1, 0);

//   ASSERT_EQ(1, lua_gettop(_L));
//   ASSERT_TRUE(lua_isfunction(_L, 1));
//   int ref = luaL_ref(_L, LUA_REGISTRYINDEX);
//   ASSERT_EQ(0, lua_gettop(_L));

//   // ... do other sutffs

//   // pickup the function
//   lua_rawgeti(_L, LUA_REGISTRYINDEX, ref);
//   ASSERT_TRUE(lua_isfunction(_L, 1));
//   pcall(0, 1, 0);

//   ASSERT_EQ(1, lua_gettop(_L));
//   ASSERT_TRUE(lua_isinteger(_L, 1));
//   ASSERT_EQ(8, lua_tonumber(_L, 1));
//   lua_pop(_L, 1);

//   // release the reference
//   luaL_unref(_L, LUA_REGISTRYINDEX, ref);
// }

// closure upvalue are accessed by pseudo indecis, so it does not occupy stack.
TEST_F(LuaTest, Clousure) {
  lua_pushcfunction(L, newCounter);
  lua_setglobal(L, "newCounter");

  const char *s =
  "assert (type(newCounter) == 'function')\n"
  "local counter1 = newCounter(3, 1)\n"
  "assert (type(counter1) == 'function')\n"
  "local counter2 = newCounter(3, 1)\n"
  "assert (type(counter2) == 'function')\n"
  "a1, b1, c1, d1 = counter1(10)\n"
  "a2, b2, c2, d2 = counter1(10)\n"
  "a3, b3, c3, d3 = counter2(10)";

  EXPECT_EQ(LUA_OK, lua_execute_string(L, s));
  EXPECT_EQ(0, lua_gettop(L));

  EXPECT_EQ(LUA_TNUMBER, lua_getglobal(L, "a1"));
  EXPECT_EQ(LUA_TNUMBER, lua_getglobal(L, "d1"));
  EXPECT_EQ(LUA_TNUMBER, lua_getglobal(L, "a2"));
  EXPECT_EQ(LUA_TNUMBER, lua_getglobal(L, "d2"));
  EXPECT_EQ(LUA_TNUMBER, lua_getglobal(L, "a3"));
  EXPECT_EQ(LUA_TNUMBER, lua_getglobal(L, "d3"));

  EXPECT_EQ(1, lua_tointeger(L, 1));
  EXPECT_EQ(14, lua_tointeger(L, 2));     // 10 + 3 + 1
  EXPECT_EQ(1, lua_tointeger(L, 3));
  EXPECT_EQ(15, lua_tointeger(L, 4));     // 10 + 3 + 2
  EXPECT_EQ(1, lua_tointeger(L, 5));
  EXPECT_EQ(14, lua_tointeger(L, 6));     // 10 + 3 + 1
}

TEST_F(LuaTest, ThreadDataExchange) {
  lua_State *L1 = lua_newthread(L);
  EXPECT_NE(L, L1);
  EXPECT_TRUE(lua_isthread(L, -1));
  EXPECT_EQ(0, lua_gettop(L1));

  lua_pushboolean(L1, 1);
  lua_pushstring(L1, "ljatsh");
  lua_newtable(L1);
  lua_xmove(L1, L, 2);

  EXPECT_EQ(1, lua_gettop(L1));
  EXPECT_EQ(1, lua_toboolean(L1, 1));
  EXPECT_EQ(3, lua_gettop(L));                // thread, 'ljatsh', {}
  EXPECT_STRCASEEQ("ljatsh", lua_tostring(L, 2));
  EXPECT_TRUE(lua_istable(L, 3));
  EXPECT_EQ(0, luaL_len(L, 3));
}

TEST_F(LuaTest, ThreadResume) {
  const char *s =
  "function f(n)\n"
  "  local v = 0\n"
  "  for i=1, n do\n"
  "    v = coroutine.yield(i * 2 + v) or 0\n"
  "  end\n"
  "  return v\n"
  "end";
  EXPECT_EQ(LUA_OK, lua_execute_string(L, s));

  lua_State *L1 = lua_newthread(L);
  EXPECT_EQ(LUA_TFUNCTION, lua_getglobal(L1, "f"));
  lua_pushinteger(L1, 2);                               // f, 3
  
  EXPECT_EQ(LUA_YIELD, lua_resume(L1, L, 1));           // 1
  EXPECT_EQ(1, lua_gettop(L1));
  EXPECT_EQ(2, lua_tointeger(L1, 1));

  // Manual suggests elements from last_resume should be cleared prior to next lua_resume(http://www.lua.org/manual/5.3/manual.html#lua_resume).
  // However, it seems the results from last lua_resume can be processed correctly.
  lua_pushinteger(L1, 2);                               // 1, 2
  EXPECT_EQ(LUA_YIELD, lua_resume(L1, L, 1));           // 5(2*2 + 2)
  EXPECT_EQ(1, lua_gettop(L1));
  EXPECT_EQ(6, lua_tointeger(L1, 1));

  lua_pushinteger(L1, 4);                               // 5, 4
  EXPECT_EQ(LUA_OK, lua_resume(L1, L, 1));              // 4
  EXPECT_EQ(1, lua_gettop(L1));
  EXPECT_EQ(4, lua_tointeger(L1, 1));
}

TEST_F(LuaTest, ThreadResumeInC) {
  //
}

struct userdata_struct {
  int age;
  char name[24];
};

TEST_F(LuaTest, UserData) {
  void* data = lua_newuserdata(L, sizeof(userdata_struct));
  memset(data, 0, sizeof(userdata_struct));

  EXPECT_EQ(1, lua_gettop(L));
  EXPECT_TRUE(lua_isuserdata(L, 1));

  EXPECT_EQ(data, lua_touserdata(L, 1));
}

// TODO usesrdata/lightuserdata/(registry and lua_state)
// TODO lua_rawset/lua_rawset metatables
// TODO error handling, call lua func...
// Garbage collection, week table and reference mechanism
// share upvalues in c functions (luaL_setfuncs)
// yield from c continuations
