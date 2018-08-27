
--- 集合
-- 1. 并集：可以理解为加法原理；或者在|A|中，或者在|B|中，但不重复计数
-- 2. 交集：既在|A|中，也在|B|中
-- 3. 乘法：乘法原理,新集合的元素属性分别由来自|A|和|B|的元素组成
--    场景：poker花色，无符号char能表示的个数

--- 排列组合
-- 1. 排列: n个事物按顺序进行排列称为置换(substitution)，共有n！种排列方法(factorial)
--         n个事物选中m个进行排列，共有n*(n-1)*...*(n-m+1)中排列方法(n!/m!)

local sets = {}

local function sets_iterator(s, index)
  local k, v = next(s, index)
  return k
end

local sets_mt = {
  __len = function(s)
    local sum = 0
    for _, _ in pairs(s) do sum = sum + 1 end
    return sum
  end,

  __pairs = function(s) return sets_iterator, s end
}

function sets.new(...)
  local s = {}
  for _, v in ipairs{...} do
    s[v] = true
  end

  return setmetatable(s, sets_mt)
end

function sets.union(s1, s2)
  local s = {}
  for k in pairs(s1) do
    s[k] = true
  end
  for k in pairs(s2) do
    s[k] = true
  end

  return s
end

function sets.intersection(s1, s2)
  local s = {}
  for k in pairs(s1) do
    if s2[k] == true then s[k] = true end
  end

  return s
end

function sets.multiple(s1, s2, factory)
  local s = {}
  for k1 in pairs(s1) do
    for k2 in pairs(s2) do
      s[factory(k1, k2)] = true
    end
  end

  return s
end

function sets.ordered_keys(s)
  local keys = {}
  for k in pairs(s) do
    keys[#keys + 1] = k
  end
  table.sort(keys)

  return keys
end

local function permutation(t)
  
end

return {sets=sets}
