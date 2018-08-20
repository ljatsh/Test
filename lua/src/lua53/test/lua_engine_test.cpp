
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
  const char *s1 = "print('hello, lua!')";
  EXPECT_EQ(LUA_OK, lua_execute_string(L, s1));
}

TEST_F(LuaEngineTest, ExecuteFunc) {
  const char *s1 =
  "function sum(...)\n"
  "  local sum = 0\n"
  "  for _, v in ipairs{...} do\n"
  "    sum = sum + v\n"
  "  end\n"
  "  return sum\n"
  "end";

  EXPECT_EQ(LUA_OK, lua_execute_string(L, s1));
  int sum = 0;
  EXPECT_EQ(LUA_OK, lua_execute_func(L, "sum", "dd>d", 1, 2, &sum));
  EXPECT_EQ(3, sum);
}
