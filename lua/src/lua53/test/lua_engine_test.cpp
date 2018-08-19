
#include "gtest/gtest.h"
#include "header.hpp"
#include "lua.hpp"

class LuaEngineTest : public ::testing::Test {
  protected:
    void SetUp() override {
      L = create_lua_engine();
    }

    void TearDown() override {
      destroy_lua_engine(L);
    }

    lua_State* L;
};

TEST_F(LuaEngineTest, InitAndDestroy) {
  EXPECT_NE(nullptr, L);

  lua_pushnil(L);
  EXPECT_EQ(1, lua_gettop(L));
}

TEST_F(LuaEngineTest, ExecuteString) {
  const char* s1 = "print('hello, lua!')";
  EXPECT_EQ(LUA_OK, lua_execute_string(L, s1));
}
