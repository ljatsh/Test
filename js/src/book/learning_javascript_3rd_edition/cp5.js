
// Learning JavaScript, 3rd Edition.
// Chapter 5. Expressions and Operators

var assert = require('assert');

describe('Expressions and Operators', function() {
    // 1. Object destructuring can be done on assignment alone, but is must be surrounded by parentheses.
    // 2. Array destructuring is less power than Python. var [a, b, ...c, d] = [3, 6, 9, 10, 11, 12] is forbidden.
    // 3. Array destructuring make it easy to swap the values of two variables
    describe('Destructuring Assignment', function() {
        it('Object Destructuring', function() {
            var obj = {a : 1, b : 'ljatsh'};
            var {a, b, c} = obj;
            assert.equal(a, 1);
            assert.equal(b, 'ljatsh');
            assert.equal(c, undefined);

            // TODO: There are SyntaxError if omit semicolon here.
            // Add semicolon after every block, thouth it is not necessary.
            ({c, a, b} = obj);
            assert.equal(a, 1);
            assert.equal(b, 'ljatsh');
            assert.equal(c, undefined);
        });

        it('Array Destructuring', function() {
            var [x, y, ...rest] = [3, 6, 9, 10, 11, 12];
            assert.equal(x, 3);
            assert.equal(y, 6);
            assert.deepEqual(rest, [9, 10, 11, 12]);

            [x, y] = [y, x];
            assert.equal(x, 6);
            assert.equal(y, 3);
        });
    })
});
