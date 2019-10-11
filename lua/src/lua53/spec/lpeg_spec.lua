
local lpeg = require('lpeg')

local match = lpeg.match      -- match a pattern again a string
local P = lpeg.P              -- match a string literally
local S = lpeg.S              -- match anything in a set
local R = lpeg.R              -- match anything in a range 

--- Reference:
--- http://lua-users.org/wiki/LpegTutorial
--- http://www.inf.puc-rio.br/~roberto/lpeg
--- https://en.wikipedia.org/wiki/Parsing_expression_grammar

describe('lpeg #lpeg', function()
  it('check version', function()
    assert.are.same('1.0.2', lpeg.version())
  end)

  it('pattern P #pattern_p', function()
    --- string literally
    -- 从开头开始，返回匹配的末尾位置
    assert.are.same(3, match(P'ab', 'abc'))
    assert.is_nil(match(P'ab', ' abc'))
  end)
end)
