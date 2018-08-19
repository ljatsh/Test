
#ifndef TEST_LUA_ENGINE_H
#define TEST_LUA_ENGINE_H

struct lua_State;

lua_State* create_lua_engine();
void destroy_lua_engine(lua_State* L);

int lua_execute_string(lua_State* L, const char* buff);

#endif // TEST_LUA_ENGINE_H
