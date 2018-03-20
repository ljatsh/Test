
print(type(not nil))
print(type(not {}))

--for j, k in pairs(table.pack('1', 'a', 3, {}, function() end)) do print(j, k) end

--print('Hello, Longjun Wang\n')

print(string.byte('Longjun', 1, -1))
print(string.char(string.byte('Longjun', 1, -1)))
print(2^20)

print(string.byte('ab\000c', 3))
print(string.byte('\000'))

print ('\000' == string.sub('ab\000c', 3, 3))
print(string.byte(string.sub('ab\000c', 3, 3), 1, -1))
print(string.char(99))
print(string.byte('ab\000c', 3))

local function test()
    print ('Hello, Lua!')
end

dump_result = string.dump(test)
print(string.byte(dump_result, 1, -1))
local b = loadstring(dump_result)
print(test, b)
b()

print(string.match('@hell1_1@#$..', '^%a+'))

local function print_pattern_classes()
    chars = {}
    for i=0, 255 do table.insert(chars, i) end
    --print(string.gsub(string.char(table.unpack(chars)), '%A', '.'))
    --print(string.gsub(string.char(table.unpack(chars)), '[%G]', '.'))
    s = string.char(table.unpack(chars))

    for _, pattern in ipairs({'%a+', '%c+', '%d+', '%g+', '%l+', '%p+', '%s+', '%u+', '%w+', '%x+'}) do
        r = {}
        for c in string.gmatch(s, pattern) do table.insert(r, c) end
        print(pattern .. ': ' .. table.concat(r))
    end
end

print_pattern_classes()

