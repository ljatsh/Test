
function table.len(v)
    sum = 0
    for _, _ in pairs(v) do sum = sum + 1 end

    return sum
end

function handler1(method, param1)
    return function(...)
        return method(param1, ...)
    end
end

function handler2(method, param1, param2)
    return function(...)
        return method(param1, param2, ...)
    end
end

function handler3(method, param1, param2, param3)
    return function(...)
        return method(param1, param2, param3, ...)
    end
end
