
require "lunit"
require "test_util"

-- temporary tests

module("cp0", lunit.testcase, package.seeall)

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
