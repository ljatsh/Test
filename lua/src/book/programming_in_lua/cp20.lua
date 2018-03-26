
require "lunit"
require "test_util"

-- Programming in Lua-->String Library
-- http://www.lua.org/pil/20.html

module("cp20", lunit.testcase, package.seeall)

    function testConstruction()
        assert_equal('\000', string.sub('ab\000c', 3, 3))
        assert_equal('123;123', string.rep('123', 2, ';'))
    end

    function testByte()
        local s = 'Hello, Lua!'
        assert_equal(s, string.char(string.byte(s, 1, -1)), 'byte and char are byte relevant operations')
    end

    function testTransform()
        assert_equal('lua', string.lower('Lua'))
        assert_equal('LUA', string.upper('Lua'))
    end

    function testLength()
        assert_equal(5, string.len('abc\000d'), 'embedded zero bytes are counted')
    end

    function testSerialization()
        local function origin(v) return tostring(v) end

        local serialized_result = string.dump(origin)
        local f = load(serialized_result)
        assert_function(f, 'f can be loaded from the serialized chunk')
        assert_not_equal(origin, f, 'f and origin are different functions, but with the same logic')
        assert_equal('1', f(1))
    end

    function testFind()
        test.assert_list_equal({8, 11},
                               table.pack(string.find('Hello, Lua.', 'Lua.', 1, true)),
                               "pattern matching is disabled")

        test.assert_list_equal({8, 11, 'Lua.'},
                               table.pack(string.find('Hello, Lua.', '(Lua.+)')),
                               "simple pattern matching")

        assert_nil(string.find('Hello, Lua.', 'Lua%a'), "mismatched pattern")
    end

    function testGmatch()
        s = 'hello world from lua!'
        t = {}
        for w in string.gmatch(s, '%w+') do
            table.insert(t, w)
        end
        test.assert_list_equal({'hello', 'world', 'from', 'lua'}, t, 'the whole pattern is a capture')

        s = 'from=world, to = Lua'
        t = {}
        for k, v in string.gmatch(s, '(%w+)%s*=%s*(%w+)') do
            table.insert(t, string.format('%s=%s', k, v))
        end
        test.assert_list_equal({'from=world', 'to=Lua'}, t, 'mutiple captures were returned')
    end

    function testGsub()
        local function increase_version(prefix, v)
            return prefix .. tostring(tonumber(v) + 1)
        end
        s = 'version=1.0, name=test'
        test.assert_list_equal({'version=1.1, name=test', 1},
                               table.pack(string.gsub(s, '(version%s*=%d+%.)(%d)', increase_version)),
                               'replaced by function return')

        s = 'name=$name, age=$age'
        assert_equal('name=ljatsh, age=33',
                     string.gsub(s, '$(%w+)', {name='ljatsh', age=33}),
                     'replaced by table value by the given capture key')

        s = 'name=ljatsh, age=33'
        assert_equal('ljatsh is name, 33 is age',
                     string.gsub(s, '(%w+)%s*=%s*(%w+)', '%2 is %1'),
                     '%1-9 stands for the corresponded capture if replace is string')
    end

    function testMatch()
        assert_equal('Lua.',
                     string.match('Hello, Lua.', 'Lua.+'),
                     "simple pattern matching")

        assert_nil(string.match('Hello, Lua.', 'Lua%a'), "mismatched pattern")
    end

    function testPatternModifier()
        -- * matches 0 or more characters of the origin class(as longest as possible)
        s = "local _name = 'ljatsh'"
        assert_equal('_name', string.match(s, '[_%a][_%w]*', 6), 'match a identifier')

        -- + matches 1 or more characters of the origin class(as longest as possible)
        assert_equal("'ljatsh'", string.match(s, "'[%w]+'"), 'match a non empty literal string')

        -- ? matches an optional character
        assert_true(string.find('124', '[+-]?%d+') == 1)
        assert_true(string.find('+124', '[+-]?%d+') == 1)
        assert_true(string.find('-124', '[+-]?%d+') == 1)

        -- - matches 0 or more characters of the origin class(but as shortest as possible)
        s = 'one|two|three|four'
        assert_equal('|two|three|', string.match(s, '|.*|'))
        assert_equal('|two|', string.match(s, '|.-|'))
    end

    function testPattern()
        -- %b matches balanced string
        assert_equal('a  line',
                     string.gsub("a (enclosed (in) parentheses) line", "%b()", ""),
                     'magic character does not take effect here')

        assert_equal('a - line',
                     string.gsub("a +enclosed +in- parentheses-- line", "%b+-", ""),
                     'magic character does not take effect here')
    end

    function testCapture()
        test.assert_list_equal({3, 4, 3, 5},
                               table.pack(string.find('flaaap', '()aa()')),
                               [[TODO, I'm cannot understand the sepecial case yet.]])

        s = [[then he said: "it's all right"!]]
        assert_equal([[it's all right]],
                     select(2, string.match(s, "([\"'])(.-)%1")),
                     '2. cpatures can be used in patterns directly')

        -- 3. captures can be used in string.gsub
    end

    function testSamples()
        pattern_china_mobile_1 = '^1[358][0-9]%d%d%d%d%d%d%d%d$'
        assert_true(string.find('15901718900', pattern_china_mobile_1) == 1, 'Lua pattern does not support POSIX regex now') 

        -- HTTP coding and encoding
    end
