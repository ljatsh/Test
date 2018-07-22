use Test::Nginx::Socket 'no_plan';
run_tests();

__DATA__

=== Test1: Request processed order

--- http_config
init_by_lua_block {
  local log = string.format('init_by_lua_block, nginx version %d, ngx lua version %d',
                            ngx.config.nginx_version, ngx.config.ngx_lua_version)
  print(log)
}

init_worker_by_lua_block {
  print('init_workder_by_lua_block')
}

--- config
location /t {
  content_by_lua_block {
    ngx.say('hello')
  }
}

--- request
GET /t

--- response_body
hello

--- error_code: 200
