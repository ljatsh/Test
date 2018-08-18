
#include "gtest/gtest.h"
#include "header.hpp"
#include "lua.hpp"

TEST(LuaEngineTest, InitAndDestroy) {
  lua_State* L = create_lua_engine();
  EXPECT_NE(nullptr, L);

  lua_pushnil(L);
  EXPECT_EQ(1, lua_gettop(L));

  destroy_lua_engine(L);
}
