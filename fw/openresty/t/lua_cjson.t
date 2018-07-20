
use Test::Nginx::Socket 'no_plan';
run_tests();

__DATA__

=== Test1: encode
The main usage scenarios

--- config
location /t {
  content_by_lua_block {
    local cjson = require('cjson')

    -- simple types
    ngx.say(cjson.encode(100))
    ngx.say(cjson.encode(0.5112))
    ngx.say(cjson.encode(nil))
    ngx.say(cjson.encode(true))
    ngx.say(cjson.encode('hello'))
    ngx.say(cjson.encode({}))
    ngx.say(cjson.encode({100, 0.5112, nil, false, {}}))       -- array

    -- next is used to iterate the object. It is not covenient to test object with multiple fields.
    ngx.say(cjson.encode({name='ljatsh'}))                     -- object
  }
}

--- request
GET /t

--- response_body
100
0.5112
null
true
"hello"
{}
[100,0.5112,null,false,{}]
{"name":"ljatsh"}


=== Test2: decode

--- config
location /t {
  content_by_lua_block {
    local cjson = require('cjson')

    local function format(data)
      -- 'null' was converted to NULL lightuserdata
      if data == cjson.null then return "nil" end

      if type(data) ~= "table" then return tostring(data) end
      local r = {}
      for k, v in pairs(data) do
        table.insert(r, format(k) .. '=' .. format(v))
      end

      return '{' .. table.concat(r, ';') .. '}'
    end
    
    local d
    for _, v in ipairs({'100',
                        '0.5112',
                        'null',
                        'true',
                        '{}',
                        '[100,0.5112,null,false,{}]',
                        '{"name":"ljatsh"}'
                        }) do
      d = cjson.decode(v)
      ngx.say(type(d) .. '|' .. format(d))
    end
  }
}

--- request
GET /t

--- response_body
number|100
number|0.5112
userdata|nil
boolean|true
table|{}
table|{1=100;2=0.5112;3=nil;4=false;5={}}
table|{name=ljatsh}
