
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

// TODO clousre/usesrdata/table...
