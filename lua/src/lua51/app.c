
#include <unistd.h>
#include <sys/time.h>
#include <lua.h>
#include <lauxlib.h>

static int stop_flag = 0;
static char update_key;

double
now_time() {
  struct timeval current_time;
  gettimeofday(&current_time,NULL);
  return current_time.tv_sec*1000 + current_time.tv_usec*0.001; // milliseconds
}

static int
now(lua_State *L) {
  lua_pushnumber(L, now_time());

  return 1;
}

static int
run(lua_State *L) {
  luaL_checktype(L, 1, LUA_TFUNCTION);
  double frequency = luaL_checknumber(L, 2) * 1000;

  lua_pushlightuserdata(L, &update_key);
  lua_pushvalue(L, 1);
  lua_settable(L, LUA_REGISTRYINDEX);

  double delta = 0.0;
  double last = now_time();
  double current = last;
  stop_flag = 0;
  while (!stop_flag) {
    if (delta > frequency) {
      // update
      lua_pushlightuserdata(L, &update_key);
      lua_gettable(L, LUA_REGISTRYINDEX);
      current = now_time();
      lua_pushnumber(L, current - last);
      lua_pcall(L, 1, 0, 0);

      delta -= frequency;
      last = current;
    }

    usleep(10000);
    delta += 10;
  }

  return 0;
}

static int
stop(lua_State *L) {
  stop_flag = 1;
  return 0;
}

static int
_sleep(lua_State *L) {
  double duration = luaL_checknumber(L, 1);
  usleep(duration * 1000000);

  return 0;
}

static const struct luaL_Reg app[] = {
  {"now", now},
  {"run", run},
  {"stop", stop},
  {"sleep", _sleep},
  {NULL, NULL}
};

int
luaopen_app(lua_State *L) {
  luaL_register(L, "app", app);
  return 1;
}
