use Test::Nginx::Socket 'no_plan';

our $http_config = <<'_EOC_';
  server {
    listen unix:/tmp/nginx.sock;

    location /proxy_test {
      echo "proxy_test";
    }

    location /delay_test {
      content_by_lua_block {
        ngx.say('line1')
        ngx.sleep(0.002)
        ngx.say('line2')
      }
    }

    location /header_test {
      content_by_lua_block {
        ngx.header.Server = 'unix_socket'
        ngx.header.X_name = 'ljatsh'

        local h, err = ngx.req.get_headers()

        for k, v in pairs(h) do
          ngx.say(k, ': ', v)
        end
      }
    }
  }
_EOC_

no_root_location();
run_tests();

__DATA__

=== Test1: proxy_pass
--- http_config eval: $::http_config

--- config
location / {
  proxy_pass http://unix:/tmp/nginx.sock:/proxy_test;
}

--- request
GET /

--- response_body
proxy_test

--- error_code: 200

=== Test2: proxy_read_timeout
--- http_config eval: $::http_config

--- config
location / {
  proxy_pass http://unix:/tmp/nginx.sock:/delay_test;
  proxy_read_timeout 1ms;
}

--- request
GET /

--- response_body_like chomp
504 Gateway Time-out

--- error_code: 504

=== Test3: proxy_header
--- http_config eval: $::http_config

--- config
location /t1 {
  proxy_pass http://unix:/tmp/nginx.sock:/header_test;
}

location /t2 {
  proxy_pass http://unix:/tmp/nginx.sock:/header_test;

  proxy_pass_header Server;
  proxy_hide_header X-name;
}

--- pipelined_requests eval
[
  "GET /t1 HTTP/1.1\r\nHello, Nginx",                       # Header Server, Date... from the proxied server are not passed to the client
  "GET /t1 HTTP/1.1\r\nHello, Nginx",                       # Check the customized header X-name

  "GET /t2 HTTP/1.1\r\nHello, Nginx",                       # Pass the header Server
  "GET /t2 HTTP/1.1\r\nHello, Nginx"                        # Skip the header X-name
]

--- response_headers_like eval
[
  "Server: openresty/.*",
  "X-name: ljatsh",

  "Server: unix_socket",
  "X-name: "
]

# http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_hide_header
# https://metacpan.org/pod/Test::Nginx::Socket#more_headers

