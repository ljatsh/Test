use Test::Nginx::Socket 'no_plan';
run_tests()

__DATA__

=== TEST1: Modifier =
1. The requested document URI must match the specified pattern exactly.
2. The pattern here is limited to a simple literal string; you cannot use a regular expression.

--- config

location = /abc {
  echo "abc";
}

location = /xyz/ {
  echo "xyz";
}

--- pipelined_requests eval
[
  "GET /abc",                                        # exactly match
  "GET /abc?a=1&b=2",                                # regardless of the query string arguments
  "GET /abc/",                                       # trailing slash

  "GET /xyz/",                                       # exactly match
  "GET /xyz",                                        # without trailing slash
  "GET /xyz/index.html"                              # extra characters after the specified pattern
]

--- response_body_like eval
[
  "abc\n",
  "abc\n",
  "404 Not Found",

  "xyz\n",
  "404 Not Found",
  "404 Not Found"
 ]

--- error_code eval
[
  200,
  200,
  404,
  
  200,
  404,
  404]


=== Test 2: No Modifier
1. The requested document URI must begin with the specified pattern
2. You may not use regular expressions.[TODO]

--- config

location /abc {
  echo "abc";
}

--- pipelined_requests eval
[
  "GET /abc",                                       # exactly match
  "GET /abc?a=1",                                   # regardless of the query string arguments
  "GET /abc/index.html",                            # with file name appended
  "GET /abc/res/",                                  # with folder name appended
  "GET /abc/res/index.html",                        # with path name appended

  "GET /abcd"                                       # with any other characters appended
]

--- response_body_like eval
[
  "abc\n",
  "abc\n",
  "abc\n",
  "abc\n",
  "abc\n",

  "abc\n"
]

--- error_code eval
[
  200,
  200,
  200,
  200,
  200,

  200
]


=== Test 3: ~ Modifier
1. The requested URI must be a case-sensitive match to the specified regular expression.

--- config
location ~ ^/abc$ {
  echo "abc";
}

--- pipelined_requests eval
[
  "GET /abc",                                       # matched
  "GET /ABC",                                       # mismatch
  "GET /abc?a=1",                                   # regardless of the query string arguments
  "GET /abc/index.html",                            # mismatch
  "GET /abcd"                                       # mismatch
]

--- response_body_like eval
[
  "abc\n",
  "404 Not Found",
  "abc\n",
  "404 Not Found",
  "404 Not Found"
]

--- error_code eval
[
  200,
  404,
  200,
  404,
  404
]


=== Test 4: ~* Modifier
1. The requested URI must be a case-insensitive match to the specified regular expression.

--- config
location ~* ^/abc$ {
  echo "abc";
}

--- pipelined_requests eval
[
  "GET /abc",                                       # matched
  "GET /ABC"                                        # matched
]

--- response_body_like eval
[
  "abc\n",
  "abc\n"
]

--- error_code eval
[
  200,
  200
]


=== Test 5: Search order and priority
Nginx will search for matching patterns in a specified order:
1. location blocks with = modifier: if the specified string exactly matches the URI, nginx retains the location block
2. location blocks with no modifier: if the specified string exactly matches the URI, nginx retains the location block
3. location blocks with ^~ modifier: if the specified string matches the beginning of the URI, nginx retains the location block
4. location blocks with ~ or ~* modifier: if the specified string matches the URI, nginx retains the location block
5. location blocks with no modifier: if the specified string matches the beginning of the URI, nginx retains the location block

If there are more than 1 patterns match the beginning the URI, nginx selects the location block matches more characters.

--- config
location /doc {
  echo "doc";
}

location ~* ^/document$ {
  echo "document";
}

--- pipelined_requests eval
[
  "GET /document",
  "GET /document/",
  "GET /documents",
  "GET /doca/a"
]

--- response_body_lik eval
[
  "document\n",
  "doc\n",
  "doc\n",
  "doc\n"
]

=== Test 6: Search order and priority

--- config
location /document {
  echo "1";
}

location ~* ^/document$ {
  echo "2";
}

--- pipelined_requests eval
[
  "GET /document",
  "GET /document/"
]

--- response_body_lik eval
[
  "1\n",
  "1\n"
]


=== Test 7: Search order and priority

--- config
location ^~ /doc {
  echo "1";
}

location ~* ^/document$ {
  echo "2";
}

--- pipelined_requests eval
[
  "GET /document",
  "GET /document/"
]

--- response_body_lik eval
[
  "1\n",
  "1\n"
]


=== Test 8: Search order and priority

--- config
location /test/ {
  echo "test";
}

location /test/git {
  echo "git";
}

--- pipelined_requests eval
[
  "GET /test/git",
  "GET /test/git/a",
]

--- response_body_like eval
[
  "git\n",
  "git\n"
]
