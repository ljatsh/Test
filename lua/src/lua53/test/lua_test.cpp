
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
TEST_F(LuaTest, LuaTypeBoolean) {
  lua_pushboolean(L, 0);
  lua_pushinteger(L, 0);

  EXPECT_TRUE(lua_isboolean(L, 1));
  EXPECT_FALSE(lua_isboolean(L, 2));
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

// TODO clousre/usesrdata/table...
// TODO lua_rawset/lua_rawset metatables
// TODO error handling, call lua func...
