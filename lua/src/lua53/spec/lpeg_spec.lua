
local lpeg = require('lpeg')

local match = lpeg.match      -- match a pattern again a string
local P = lpeg.P              -- match a string literally
local S = lpeg.S              -- match anything in a set
local R = lpeg.R              -- match anything in a range 

--- Reference:
--- http://lua-users.org/wiki/LpegTutorial
--- http://www.inf.puc-rio.br/~roberto/lpeg
--- https://en.wikipedia.org/wiki/Parsing_expression_grammar

--- Tips:
--- 1. match从开头开始，返回匹配的末尾位置 (?)

describe('lpeg #lpeg', function()
  it('check version', function()
    assert.are.same('1.0.2', lpeg.version())
  end)

  it('pattern P #pattern_p', function()
    --- string literally
    assert.are.same(3, match(P'ab', 'abc'))
    assert.is_nil(match(P'ab', ' abc'))

    --- n characters
    assert.are.same(3, match(P(2), '_ab'))
    assert.are.same(3, match(P(2), '_abc'))
    assert.is_nil(match(P(3), '_a'), 'insufficient count')

    --- less than n characters (返回值什么含义?)
    assert.are.same(1, match(P(-3), '12'))
    assert.are.same(1, match(P(-3), '1'))
    assert.is_nil(match(P(-3), '123'))
    assert.is_nil(match(P(-3), '1234'))

    --- boolean
    assert.are.same(1, match(P(true), ''))
    assert.is_nil(match(P(false), ''))

    -- TODO table, function input
  end)

  it('pattern S #pattern_s', function()
    for _, c in ipairs({'+', '-', '*', '-'}) do
      assert.are.same(2, match(S'+-*/', c .. ' '))
    end
  end)

  it('pattern R #pattern_r', function()
    assert.are.same(2, match(R'09', '5a'), 'digit')
    assert.are.same(2, match(R('az', 'AZ'), 'lj'), 'ascii')
    assert.are.same(2, match(R('az', 'AZ'), 'Lj'), 'ascii')

    assert.is_nil(match(R('az', 'AZ'), '1j'))
  end)
end)
