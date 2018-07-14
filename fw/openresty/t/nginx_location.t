use Test::Nginx::Socket 'no_plan';
run_tests()

__DATA__

=== TEST1: Modifier =
1. item1
2. item2

--- config

location = /abc {
  echo "abc";
}

location = /xyz/ {
  echo "xyz";
}

--- pipelined_requests eval
[
 "GET /abc", "GET /abc?a=1&b=2", "GET /abc/",
 "GET /xyz/", "GET /xyz=?a=1&b=2"
]

--- response_body_like eval
["abc\n", "abc\n", "404 Not Found",
 "xyz\n", "404 Not Found"]

--- error_code eval
[200, 200, 404, 200, 404]
