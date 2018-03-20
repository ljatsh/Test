
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

function string.ltrim(input)
    return string.gsub(input, "^[ \t\n\r]+", "")
end

function string.rtrim(input)
    return string.gsub(input, "[ \t\n\r]+$", "")
end

function string.trim(input)
    input = string.gsub(input, "^[ \t\n\r]+", "")
    return string.gsub(input, "[ \t\n\r]+$", "")
end

function string.split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end

local function dump_value_(v)
    if type(v) == "string" then
        v = "\"" .. v .. "\""
    end
    return tostring(v)
end

function dump(value, description, nesting)
    if type(nesting) ~= "number" then nesting = 3 end

    local lookupTable = {}
    local result = {}

    local traceback = string.split(debug.traceback("", 2), "\n")
    print("dump from: " .. string.trim(traceback[3]))

    local function dump_(value, description, indent, nest, keylen)
        description = description or "<var>"
        local spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(dump_value_(description)))
        end
        if type(value) ~= "table" then
            result[#result +1 ] = string.format("%s%s%s = %s", indent, dump_value_(description), spc, dump_value_(value))
        elseif lookupTable[tostring(value)] then
            result[#result +1 ] = string.format("%s%s%s = *REF*", indent, dump_value_(description), spc)
        else
            lookupTable[tostring(value)] = true
            if nest > nesting then
                result[#result +1 ] = string.format("%s%s = *MAX NESTING*", indent, dump_value_(description))
            else
                result[#result +1 ] = string.format("%s%s = {", indent, dump_value_(description))
                local indent2 = indent.."    "
                local keys = {}
                local keylen = 0
                local values = {}
                for k, v in pairs(value) do
                    keys[#keys + 1] = k
                    local vk = dump_value_(k)
                    local vkl = string.len(vk)
                    if vkl > keylen then keylen = vkl end
                    values[k] = v
                end
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end)
                for i, k in ipairs(keys) do
                    dump_(values[k], k, indent2, nest + 1, keylen)
                end
                result[#result +1] = string.format("%s}", indent)
            end
        end
    end
    dump_(value, description, "- ", 1)

    for i, line in ipairs(result) do
        print(line)
    end
end

--dump(getmetatable(''))
print(''..2)

