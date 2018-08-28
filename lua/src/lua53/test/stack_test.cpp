
#include <cstring>
#include "header.hpp"
#include "lua.hpp"
#include "gtest/gtest.h"

int simpleTest1(lua_State* L) {
  int size1 = lua_gettop(L);

  int v = luaL_checknumber(L, -1);

  lua_pushinteger(L, v * 2);

  int size2 = lua_gettop(L);

  lua_pushinteger(L, size1);
  lua_pushinteger(L, size2);

  return 3;
}

std::string dump_stack(lua_State* L) {
  std::ostringstream ss;
  for (int i=1; i<=lua_gettop(L); i++) {
    int type = lua_type(L, i);
    switch (type) {
      case LUA_TNUMBER:
        if (lua_isinteger(L, i))
          ss << ' ' << lua_tointeger(L, i);
        else
          ss << ' ' << lua_tonumber(L, i);
        break;
      case LUA_TNIL:
        ss << " nil";
        break;
      case LUA_TBOOLEAN:
        ss << ' ' << (lua_toboolean(L, i) ? "true" : "false");
        break;
      case LUA_TSTRING:
        ss << ' ' << lua_tostring(L, i);
        break;
      default:
        ss << ' ' << "undefined";
    }
  }

  return ss.str().substr(1);
}

class StackTest : public ::testing::Test {
  public:
    void SetUp() override {
      L = create_lua_engine();
    }

    virtual void TearDown() {
      ASSERT_TRUE(L != NULL);
      destroy_lua_engine(L);
    }

  protected:
    lua_State* L;
};

TEST_F(StackTest, NormalOperation) {
  lua_pushnumber(L, 1.2f);     // 1
  lua_pushinteger(L, 5);       // 2
  lua_pushboolean(L, 2);       // 3
  lua_pushnil(L);              // 4

  // lua_pushstring create a local copy in lua. So, it is safe to release c string.
  const char* buff_origin = "ljatsh";
  const char* buff_lua = lua_pushstring(L, buff_origin); // 5
  EXPECT_STRCASEEQ(buff_origin, buff_lua);
  EXPECT_NE(buff_origin, buff_lua);

  EXPECT_EQ(5, lua_gettop(L));

  // index 1
  EXPECT_TRUE(lua_isnumber(L, 1));
  EXPECT_FLOAT_EQ(1.2f, lua_tonumber(L, 1));
  
  // index 2
  EXPECT_TRUE(lua_isinteger(L, 2));
  EXPECT_EQ(5, lua_tointeger(L, 2));

  // index 3
  EXPECT_TRUE(lua_isboolean(L, 3));
  EXPECT_TRUE(lua_toboolean(L, 3));

  // index 4
  EXPECT_TRUE(lua_isnil(L, 4));

  // index 5
  EXPECT_TRUE(lua_isstring(L, 5));
  const char* buff_lua_2 = lua_tostring(L, 5);
  EXPECT_EQ(buff_lua, buff_lua_2);
  EXPECT_STRCASEEQ(buff_lua, buff_lua_2);
}

TEST_F(StackTest, StackManipulation) {
  // lua_settop index can be negative
  lua_settop(L, 3);
  EXPECT_STRCASEEQ("nil nil nil", dump_stack(L).c_str());
  
  lua_settop(L, -2);
  EXPECT_STRCASEEQ("nil nil", dump_stack(L).c_str());

  // lua_insert (move top to given index, index cannot be lt size)
  lua_pushinteger(L, 1);                    // nil nil 1
  lua_insert(L, 1);                         // 1 nil nil
  EXPECT_STRCASEEQ("1 nil nil", dump_stack(L).c_str());

  lua_pushinteger(L, 2);
  lua_insert(L, 4);                         // 1 nil nil 2, index == size
  EXPECT_STRCASEEQ("1 nil nil 2", dump_stack(L).c_str());

  // lua_remove (remove given index)
  lua_remove(L, 3);
  lua_remove(L, 2);
  EXPECT_STRCASEEQ("1 2", dump_stack(L).c_str());

  // lua_pushvalue (copy the element at given index to the top)
  lua_pushnil(L);                 // 1 2 nil
  lua_pushvalue(L, 1);            // 1 2 nil 1
  EXPECT_STRCASEEQ("1 2 nil 1", dump_stack(L).c_str());

  // lua_copy (copy to valid index, size does not change)
  lua_copy(L, 3, 1);             // nil 2 nil 1
  EXPECT_STRCASEEQ("nil 2 nil 1", dump_stack(L).c_str());

  // lua_replace (replace the elment at given index with top element, size shrinks)
  lua_replace(L, 1);              // 1 2 nil
  EXPECT_STRCASEEQ("1 2 nil", dump_stack(L).c_str());

  // lua_rotate
  lua_pushboolean(L, 1);
  lua_pushboolean(L, 0);
  lua_pushstring(L, "hello");     // 1 2 nil true false hello

  lua_rotate(L, 3, 1);            // 1 2 hello nil true false
  EXPECT_STRCASEEQ("1 2 hello nil true false", dump_stack(L).c_str());
  lua_rotate(L, 4, 2);            // 1 2 hello true false nil
  EXPECT_STRCASEEQ("1 2 hello true false nil", dump_stack(L).c_str());
  lua_rotate(L, 2, -1);           // 1 hello true false nil 2
  EXPECT_STRCASEEQ("1 hello true false nil 2", dump_stack(L).c_str());
}
