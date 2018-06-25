
#include "lua.hpp"
#include "gtest/gtest.h"

class LuaTest : public ::testing::Test {
  public:
    LuaTest() {
      _Lua = NULL;
    }

    virtual ~LuaTest() {

    }

    virtual void SetUp() {
      _Lua = luaL_newstate();
    }

    virtual void TearDown() {
      ASSERT_TRUE(_Lua != NULL); // TODO
    }

  protected:
    lua_State* _Lua;
};

TEST_F(LuaTest, TestStack) {
  lua_pushnil(_Lua);

  ASSERT_EQ(1, lua_gettop(_Lua)) << "stack size is 1";
  ASSERT_TRUE(lua_isnil(_Lua, 1) && lua_isnil(_Lua, -1));
}
