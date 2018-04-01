// Learning JavaScript, 3rd Edition.
// Chapter 4. Expressions and Operators

var assert = require('assert');

// 1. Perfer === and !== to avoid unexpected behavior
describe('Expressions and Operators', function() {
    it('Equality and Inequality Operators', function() {
        // strict equality
        //// strict equality does not perform type conversations
        assert.ok('1' !== 1, 'different types does not strict equal')
        assert.ok(true !== 1, 'different types does not strict equal')

        //// null, undefined and NaN
        assert.ok(null === null)
        assert.ok(undefined === undefined)
        assert.ok(null !== undefined)
        assert.ok(NaN !== NaN, 'NaN does not strict equal to any value, including itself')
        assert.ok(NaN !== 'a', 'NaN does not strict equal to any value, including itself')

        //// 0 and -0 are strict equal
        var obj1 = {x:1}, obj2 = {x:1}
        assert.ok(5 === 5)
        assert.ok(0 === -0)
        assert.ok(obj1 !== obj2, 'different object does not strict equal, event if they have the same properties')

        // equality operator
        //// type coversattion may occur bewteen different value types
        assert.ok('1' == 1, 'convert string to number')
        assert.ok(true == 1 && false == 0, 'convert boolean to number(true-->1, false-->0) firstly, and then check equality again')
        assert.ok(true == '1' && false == '0', 'convert boolean to number(true-->1, false-->0) firstly, and then check equality again')

        //// Object vs number/string/ is too complicated.
        assert.ok(obj1 != obj2, 'TODO')

        //// null and undefined are equal
        assert.ok(null == undefined)
    });
});
