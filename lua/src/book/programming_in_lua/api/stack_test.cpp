
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
  size_t len_ = 8;
  char* szBuffer = static_cast<char*>(std::malloc(len_));
  szBuffer[len_ - 1] = '\0';
  std::strncpy(szBuffer, "lj@sh", len_ - 1);

  lua_pushnumber(_Lua, 1.2f);     // 1
  lua_pushinteger(_Lua, 5);       // 2
  lua_pushboolean(_Lua, 2);       // 3
  lua_pushnil(_Lua);              // 4

  // lua_pushstring create a local copy in lua. It is safe to release c string.
  const char* s_ = lua_pushstring(_Lua, szBuffer); // 5
  ASSERT_STRCASEEQ(szBuffer, s_);
  ASSERT_NE(szBuffer, s_);
  std::memset(szBuffer, 0, len_ - 1);
  free(szBuffer);
  ASSERT_STREQ("lj@sh", s_);

  // Check
  ASSERT_EQ(5, lua_gettop(_Lua)) << "check stack size";

  // index 1
  ASSERT_TRUE(lua_isnumber(_Lua, 1)) << "check 1";
  ASSERT_FLOAT_EQ(1.2f, lua_tonumber(_Lua, 1));
  
  // index 2
  ASSERT_TRUE(lua_isnumber(_Lua, 2)) << "check 2";
  ASSERT_EQ(5, lua_tonumber(_Lua, 2));

  // index 3
  //ASSERT_TRUE(lua_isnumber(_Lua, 3)) << "check 3";
  ASSERT_TRUE(lua_isboolean(_Lua, 3));
  ASSERT_TRUE(lua_toboolean(_Lua, 3));

  // index 4
  ASSERT_TRUE(lua_isnil(_Lua, 4)) << "check 4";

  // index 5
  ASSERT_TRUE(lua_isstring(_Lua, -1)) << "check 5";
  const char* s2_ = lua_tostring(_Lua, -1);
  ASSERT_EQ(s_, s2_);
}
