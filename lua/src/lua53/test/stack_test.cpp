
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

class StackTest : public ::testing::Test {
  public:
    void SetUp() override {
      L = create_lua_engine();

      // register C functions
      // luaL_openlibs(_L);
      // lua_pushcfunction(_L, simpleTest1);
      // lua_setglobal(_L, "simpleTest1");

      // ASSERT_EQ(0, luaL_loadfile(_L, "test.lua"));
      // pcall(0, 0, 0);
    }

    virtual void TearDown() {
      ASSERT_TRUE(L != NULL);
      destroy_lua_engine(L);
    }

    // void pcall(int args, int results, int msgh) {
    //   int error = lua_pcall(_L, args, results, msgh);
    //   const char* err_string = NULL;
    //   if (error) {
    //     err_string = lua_tostring(_L, -1);
    //   }

    //   ASSERT_EQ(LUA_OK, error) << err_string;
    // }

    // const char* getName() {
    //   lua_getglobal(_L, "getName");

    //   if (!lua_isfunction(_L, -1))
    //     return NULL;

    //   pcall(0, 1, 0);

    //   if (lua_gettop(_L) != 1)
    //     return NULL;

    //   if (!lua_isstring(_L, -1))
    //     return NULL;

    //   const char* name = lua_tostring(_L, -1);
    //   lua_pop(_L, -1);

    //   return name;
    // }
  
  protected:
    // std::string dump() {
    //   std::ostringstream ss;
    //   for (int i=1; i<=lua_gettop(_L); i++) {
    //     int type_ = lua_type(_L, i);
    //     switch (type_) {
    //       case LUA_TNUMBER:
    //         if (lua_isinteger(_L, i))
    //           ss << ' ' << lua_tointeger(_L, i);
    //         else
    //           ss << ' ' << lua_tonumber(_L, i);
    //         break;
    //       case LUA_TNIL:
    //         ss << " nil";
    //         break;
    //       case LUA_TBOOLEAN:
    //         ss << ' ' << (lua_toboolean(_L, i) ? "true" : "false");
    //         break;
    //       case LUA_TSTRING:
    //         ss << ' ' << lua_tostring(_L, i);
    //         break;
    //       default:
    //         ss << ' ' << "undefined";
    //     }
    //   }

    //   return ss.str().substr(1);
    // }

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

  // // other operations
  // lua_settop(_L, 6);
  // ASSERT_TRUE(lua_isnil(_L, -1));   // 1.2 5 true nil lj@sh nil
  // ASSERT_STRCASEEQ("1.2 5 true nil lj@sh nil", dump().c_str());
  
  // lua_pop(_L, 2);
  // ASSERT_EQ(4, lua_gettop(_L));     // 1.2 5 true nil
  // ASSERT_STRCASEEQ("1.2 5 true nil", dump().c_str());

  // lua_pushvalue(_L, 2);

  // ASSERT_EQ(5, lua_gettop(_L));
  // ASSERT_EQ(5, lua_tonumber(_L, -1)); // 1.2 5 true nil 5
  // ASSERT_STRCASEEQ("1.2 5 true nil 5", dump().c_str());

  // lua_remove(_L, 2);
  // ASSERT_EQ(4, lua_gettop(_L));   // 1.2 true nil 5
  // ASSERT_STRCASEEQ("1.2 true nil 5", dump().c_str());

  // lua_insert(_L, -3);
  // ASSERT_EQ(4, lua_gettop(_L));
  // ASSERT_STRCASEEQ("1.2 5 true nil", dump().c_str());

  // lua_replace(_L, -2);
  // ASSERT_EQ(3, lua_gettop(_L));
  // ASSERT_STRCASEEQ("1.2 5 nil", dump().c_str());

  // lua_pushinteger(_L, 10);
  // lua_pushinteger(_L, 11);
  // lua_pushinteger(_L, 12);
  // lua_pushinteger(_L, 13);
  // ASSERT_STRCASEEQ("1.2 5 nil 10 11 12 13", dump().c_str());
  // lua_rotate(_L, 3, 1);
  // ASSERT_STRCASEEQ("1.2 5 10 11 12 nil 13", dump().c_str());
}

// 1. lua_settable and lua_gettable is the general way to write/read a table
// 2. lua_setfiled and lua_getfild writes/reads a table by string key
// 3. lua_seti and lua_geti writes/reads a table by index
// 4. every read/write API has a corresponed raw API
// TEST_F(StackTest, TestTable) {
//   lua_newtable(_L);
//   ASSERT_TRUE(lua_istable(_L, -1));

//   lua_pushnil(_L);                // table, nil

//   // set table filed by key
//   lua_pushinteger(_L, 34);
//   lua_setfield(_L, 1, "age");

//   ASSERT_EQ(2, lua_gettop(_L));

//   // get field by key
//   lua_getfield(_L, 1, "age");
//   ASSERT_EQ(3, lua_gettop(_L));

//   ASSERT_EQ(34, lua_tointeger(_L, -1));
//   lua_pop(_L, 1);

//   // get a missing field
//   lua_getfield(_L, 1, "name");
//   ASSERT_EQ(3, lua_gettop(_L));

//   ASSERT_TRUE(lua_isnil(_L, -1));
//   lua_pop(_L, 1);

//   // set table field by index
//   lua_pushstring(_L, "lj@sh");
//   lua_seti(_L, 1, 1);

//   ASSERT_EQ(2, lua_gettop(_L));

//   // get table field by index
//   lua_geti(_L, 1, 1);
//   ASSERT_EQ(3, lua_gettop(_L));

//   ASSERT_STREQ("lj@sh", lua_tostring(_L, -1));
//   lua_pop(_L, 1);

//   // TODO--> metamethod trigger

//   // set table field by index(rawset)
//   lua_pushstring(_L, "lj@sh");
//   lua_rawseti(_L, 1, 2);

//   ASSERT_EQ(2, lua_gettop(_L));

//   // get table field by index(rawget)
//   lua_geti(_L, 1, 2);
//   ASSERT_EQ(3, lua_gettop(_L));

//   ASSERT_STREQ("lj@sh", lua_tostring(_L, -1));
//   lua_pop(_L, 1);

//   // set table field by lua_settable
//   lua_pushstring(_L, "sex");
//   lua_pushboolean(_L, true);

//   lua_settable(_L, 1);
//   ASSERT_EQ(2, lua_gettop(_L));

//   lua_pushstring(_L, "sex");
//   lua_gettable(_L, 1);

//   ASSERT_EQ(3, lua_gettop(_L));
//   ASSERT_TRUE(lua_toboolean(_L, -1));
//   lua_pop(_L, 1);

//   // TODO
//   // lua_rawset, lua_rawset is similar to lua_settable and lua_gettable
// }

// TEST_F(StackTest, TestGlobalVariable) {
//   ASSERT_EQ(LUA_TNIL, lua_getglobal(_L, "gMissing"));
//   ASSERT_EQ(1, lua_gettop(_L));
//   ASSERT_TRUE(lua_isnil(_L, -1));
//   lua_pop(_L, 1);

//   ASSERT_EQ(LUA_TSTRING, lua_getglobal(_L, "gName"));
//   ASSERT_EQ(1, lua_gettop(_L));
//   ASSERT_STREQ("lj@sh", lua_tostring(_L, 1));

//   lua_pop(_L, 1);

//   lua_pushstring(_L, "lj@bj");
//   lua_setglobal(_L, "gName");

//   ASSERT_EQ(0, lua_gettop(_L));

//   ASSERT_STRCASEEQ("lj@bj", getName());
// }

// TEST_F(StackTest, TestLuaCallC) {
//   lua_getglobal(_L, "callC");
//   ASSERT_TRUE(lua_isfunction(_L, -1));

//   lua_pushinteger(_L, 3);
//   pcall(1, 3, 0);

//   ASSERT_EQ(3, lua_gettop(_L));
//   ASSERT_EQ(6, lua_tointeger(_L, 1));
//   ASSERT_EQ(1, lua_tointeger(_L, 2));
//   ASSERT_EQ(2, lua_tointeger(_L, 3));
// }

// TEST_F(StackTest, TestRegistry) {
//   // prefer to use lightuserdata as th key
//   static char cKey = '1';

//   lua_pushlightuserdata(_L, &cKey);
//   lua_pushinteger(_L, 10);
//   lua_settable(_L, LUA_REGISTRYINDEX);

//   lua_pushlightuserdata(_L, &cKey);
//   lua_gettable(_L, LUA_REGISTRYINDEX);

//   ASSERT_TRUE(lua_isnumber(_L, 1));
//   ASSERT_EQ(10, lua_tonumber(_L, 1));

//   lua_pop(_L, 1);

//   // from Lua5.2, more convinient API lua_rawsetp and lua_rawgetp are provided.

//   lua_pushboolean(_L, true);
//   lua_rawsetp(_L, LUA_REGISTRYINDEX, &cKey);

//   lua_rawgetp(_L, LUA_REGISTRYINDEX, &cKey);

//   ASSERT_TRUE(lua_isboolean(_L, 1));
//   ASSERT_TRUE(lua_toboolean(_L, 1));

//   // TODO. Lua manual says any lua value can be used as the key of the global table
//   // registry. How to understand this?
// }

// // integer keys of table registry are used to reference lua value
// TEST_F(StackTest, TestReference) {
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
