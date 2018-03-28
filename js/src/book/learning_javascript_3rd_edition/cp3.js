

// Learning JavaScript, 3rd Edition.
// Chapter 3. Literals and Variables

var assert = require('assert')

describe('Primitive types and Objects', function() {
    // 1. Number.isNaN is different from global isNan. Number.isNaN determines whether the passed value is NaN and its type is Number. While global isNaN converts the passed value to Number.
    // 2. Both equality operators, == and ===, evaluating to false when checking NaN is Nan. This is why Number.isNaN() becomes necessary.
    describe('Number', function() {
        it('NaN', function() {
            assert.notEqual(Number.isNaN, isNaN, 'global isNan is different from Number.isNaN')

            // 'NaN', undefined, {}, 'blabla' should be true with global isNaN
            assert.ok(!Number.isNaN('NaN'))
            assert.ok(!Number.isNaN(undefined))
            assert.ok(!Number.isNaN({}))
            assert.ok(!Number.isNaN('blabla'))

            assert.ok(isNaN('NaN'))
            assert.ok(isNaN(undefined))
            assert.ok(isNaN({}))
            assert.ok(isNaN('blabla'))

            assert.ok(!(NaN == NaN), 'Nan == Nan is false')
            assert.ok(!(NaN === NaN), 'Nan === Nan is false')

            assert.ok(Number.isNaN(NaN))
            assert.ok(Number.isNaN(Number.NaN))
            assert.ok(Number.isNaN(0/0))
        })

        it('Infinity', function() {
            assert.ok(!Number.isFinite(1/0))
        })

        it('Convered from string', function() {
            assert.equal(Number.parseInt('5.6'), 5, 'numbers after dot are omitted')
            assert.equal(Number.parseInt(' 5 '), 5, 'leading spaces are ignored')
            assert.equal(Number.parseInt('ab', 16), 0xab, 'hexdecimal parsing')
            assert.ok(Number.isNaN(Number.parseInt('ab')))
            assert.equal(Number.parseInt, parseInt, 'global parseInt is alias of Number.parseInt')

            assert.equal(1.5, Number.parseFloat('1.5'))
            assert.equal(1.5, Number.parseFloat('1.5a'), 'first non digit character and remain ones are omitted')
            assert.equal(Number.parseFloat, parseFloat, 'global parseFloat is alias of Number.parseFloat')
        })

        it('Converts to string', function() {
            assert.equal((16.7).toString(), '16.7', 'default radix is 10')
            assert.equal((16).toString(16), '10', 'hexdecimal format')
            assert.equal((-16).toString(2), '-10000', 'binary format')
        })

        it('valueOf', function() {
            var numObj = new Number(11)
            var num = numObj.valueOf()
            assert.equal(num, 11)
            assert.equal(typeof(numObj), 'object')
            assert.equal(typeof(num), 'number')
        })
    })

    describe('Boolean', function() {
        it('test', function() {
            
        })
    })
})

