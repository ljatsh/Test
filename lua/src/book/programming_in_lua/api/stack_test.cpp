
#include "lua.hpp"
#include "gtest/gtest.h"

class LuaTest : public ::testing::Test {
  public:
    LuaTest() {
      _lua = NULL;
    }

    virtual ~LuaTest() {

    }

    virtual void SetUp() {
      _lua = luaL_newstate();
    }

    virtual void TearDown() {
      ASSERT_TRUE(_lua != NULL); // TODO
    }
  
  protected:
    std::string dump() {
      std::ostringstream ss;
      for (int i=1; i<=lua_gettop(_lua); i++) {
        int type_ = lua_type(_lua, i);
        switch (type_) {
          case LUA_TNUMBER:
            if (lua_isinteger(_lua, i))
              ss << ' ' << lua_tointeger(_lua, i);
            else
              ss << ' ' << lua_tonumber(_lua, i);
            break;
          case LUA_TNIL:
            ss << " nil";
            break;
          case LUA_TBOOLEAN:
            ss << ' ' << (lua_toboolean(_lua, i) ? "true" : "false");
            break;
          case LUA_TSTRING:
            ss << ' ' << lua_tostring(_lua, i);
            break;
          default:
            ss << ' ' << "undefined";
        }
      }

      return ss.str().substr(1);
    }

  protected:
    lua_State* _lua;
};

TEST_F(LuaTest, TestVersion) {
  ASSERT_STRCASEEQ("3", LUA_VERSION_MINOR) << "assure we are running Lua 5.3";
}

TEST_F(LuaTest, TestStack) {
  size_t len_ = 8;
  char* szBuffer = static_cast<char*>(std::malloc(len_));
  szBuffer[len_ - 1] = '\0';
  std::strncpy(szBuffer, "lj@sh", len_ - 1);

  lua_pushnumber(_lua, 1.2f);     // 1
  lua_pushinteger(_lua, 5);       // 2
  lua_pushboolean(_lua, 2);       // 3
  lua_pushnil(_lua);              // 4

  // lua_pushstring create a local copy in lua. It is safe to release c string.
  const char* s_ = lua_pushstring(_lua, szBuffer); // 5
  ASSERT_STRCASEEQ(szBuffer, s_);
  ASSERT_NE(szBuffer, s_);
  std::memset(szBuffer, 0, len_ - 1);
  free(szBuffer);
  ASSERT_STREQ("lj@sh", s_);

  // Check
  ASSERT_EQ(5, lua_gettop(_lua)) << "check stack size";

  // index 1
  ASSERT_TRUE(lua_isnumber(_lua, 1)) << "check 1";
  ASSERT_FLOAT_EQ(1.2f, lua_tonumber(_lua, 1));
  
  // index 2
  ASSERT_TRUE(lua_isinteger(_lua, 2)) << "check 2";
  ASSERT_EQ(5, lua_tointeger(_lua, 2));

  // index 3
  ASSERT_FALSE(lua_isnumber(_lua, 3)) << "lua boolean cannot be converted to number";
  ASSERT_TRUE(lua_isboolean(_lua, 3)) << "check 3";
  ASSERT_TRUE(lua_toboolean(_lua, 3));

  // index 4
  ASSERT_TRUE(lua_isnil(_lua, 4)) << "check 4";

  // index 5
  ASSERT_TRUE(lua_isstring(_lua, -1)) << "check 5";
  const char* s2_ = lua_tostring(_lua, -1);
  ASSERT_EQ(s_, s2_);

  // other operations
  lua_settop(_lua, 6);
  ASSERT_TRUE(lua_isnil(_lua, -1));   // 1.2 5 true nil lj@sh nil
  ASSERT_STRCASEEQ("1.2 5 true nil lj@sh nil", dump().c_str());
  
  lua_pop(_lua, 2);
  ASSERT_EQ(4, lua_gettop(_lua));     // 1.2 5 true nil
  ASSERT_STRCASEEQ("1.2 5 true nil", dump().c_str());

  lua_pushvalue(_lua, 2);

  ASSERT_EQ(5, lua_gettop(_lua));
  ASSERT_EQ(5, lua_tonumber(_lua, -1)); // 1.2 5 true nil 5
  ASSERT_STRCASEEQ("1.2 5 true nil 5", dump().c_str());

  lua_remove(_lua, 2);
  ASSERT_EQ(4, lua_gettop(_lua));   // 1.2 true nil 5
  ASSERT_STRCASEEQ("1.2 true nil 5", dump().c_str());

  lua_insert(_lua, -3);
  ASSERT_EQ(4, lua_gettop(_lua));
  ASSERT_STRCASEEQ("1.2 5 true nil", dump().c_str());

  lua_replace(_lua, -2);
  ASSERT_EQ(3, lua_gettop(_lua));
  ASSERT_STRCASEEQ("1.2 5 nil", dump().c_str());

  lua_pushinteger(_lua, 10);
  lua_pushinteger(_lua, 11);
  lua_pushinteger(_lua, 12);
  lua_pushinteger(_lua, 13);
  ASSERT_STRCASEEQ("1.2 5 nil 10 11 12 13", dump().c_str());
  lua_rotate(_lua, 3, 1);
  ASSERT_STRCASEEQ("1.2 5 10 11 12 nil 13", dump().c_str());
}
