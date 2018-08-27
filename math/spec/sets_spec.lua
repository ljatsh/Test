
local sets = require('sets').sets

describe('sets', function()
  it('creation', function()
    local s = sets.new(1, 2, 3)
    assert.are.same(3, #s)
    assert.are.same({1, 2, 3}, sets.ordered_keys(s))
  end)

  it('union', function()
    local s1 = sets.new(1, 2, 3)
    local s2 = sets.new(2, 4, 5)
    local s = sets.union(s1, s2)
    assert.are.same({1, 2, 3, 4, 5}, sets.ordered_keys(s))
  end)

  it('intersection', function()
    local s1 = sets.new(1, 2, 3)
    local s2 = sets.new(2, 4, 5)
    local s = sets.intersection(s1, s2)
    assert.are.same({2}, sets.ordered_keys(s))
  end)

  it('multiple', function()
    local diamond = 1
    local club = 2
    local heart = 3
    local spade = 4

    local v_A = 1
    local v_2 = 2
    local v_3 = 3
    local v_4 = 4
    local v_5 = 5
    local v_6 = 6
    local v_7 = 7
    local v_8 = 8
    local v_9 = 9
    local v_10 = 10
    local v_J = 11
    local v_Q = 12
    local v_K = 13

    local colors = sets.new(diamond, club, heart, spade)
    local values = sets.new(v_A, v_2, v_3, v_4, v_5, v_6, v_7, v_8, v_9, v_10, v_J, v_Q, v_K)
    local function poker(c, v)
      return {color = c, value = v}
    end

    local pokers = sets.multiple(colors, values, poker)
    assert.are(52, #pokers)
  end)
end)