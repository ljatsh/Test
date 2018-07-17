use Test::Nginx::Socket 'no_plan';
run_tests();

__DATA__

=== TEST 1: hello, world
This is just a simple demonstration of the
echo directive provided by ngx_http_echo_module.

--- config
location = /t {
  echo "hello, world!";
}

--- request
GET /t

--- response_body
hello, world!

--- error_code: 200

=== TEST 2: lua-resty-moongoo depencency
Test wheter lua-resty-moongoo was installed correctly

--- http_config
init_worker_by_lua_block {
  
}

--- config
location = /t {
  content_by_lua_block {
    local moongoo = require("resty.moongoo")
    local cbson = require("cbson")

    local mg, err = moongoo.new("mongodb://192.168.0.130/?w=2")
    if not mg then
      error(err)
    end

    local col = mg:db("test"):collection("test")

    -- Insert document
    local ids, err = col:insert({ foo = "bar"})

    -- Close connection or put in OpenResty connection pool

    mg:close()
    print('done')

    ngx.say("hello, world!")
  }
}

--- request
GET /t

--- response_body
hello, world!
