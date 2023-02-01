
// Learning JavaScript, 3rd Edition.
// Chapter 5. Expressions and Operators

var assert = require('assert');
const { expect } = require('chai');

describe('Expressions and Operators', function() {
  // 1. Object destructuring can be done on assignment alone, but is must be surrounded by parentheses.
  // 2. Array destructuring is less power than Python. var [a, b, ...c, d] = [3, 6, 9, 10, 11, 12] is forbidden.
  // 3. Array destructuring make it easy to swap the values of two variables
  // 4. Perfer === and !== to avoid unexpected behavior
  describe('Destructuring Assignment', function() {
    it('Object Destructuring', function() {
      var obj = {a : 1, b : 'ljatsh'};
      var {a, b, c} = obj;
      expect(a).to.be.equal(1);
      expect(b).to.be.equal('ljatsh');
      //expect(c).to.be.undefined;
      expect(c).to.be.equal(undefined);

      // TODO: There are SyntaxError if omit semicolon here.
      // Add semicolon after every block, thouth it is not necessary.
      ({c, a, b} = obj);
      expect(a).to.be.equal(1);
      expect(b).to.be.equal('ljatsh');
      //expect(c).to.be.undefined();
      expect(c).to.be.equal(undefined);
    });

    it('Array Destructuring', function() {
      var [x, y, ...rest] = [3, 6, 9, 10, 11, 12];
      expect(x).to.be.equal(3);
      expect(y).to.be.equal(6);
      expect(rest).be.deep.equal([9, 10, 11, 12]);
      //assert.deepEqual(rest, [9, 10, 11, 12]);

      [x, y] = [y, x];
      expect(x).to.be.equal(6);
      expect(y).to.be.equal(3);
    });

        it('Equality and Inequality Operators', function() {
            // strict equality
            //// strict equality does not perform type conversations
            assert.ok('1' !== 1, 'different types does not strict equal');
            assert.ok(true !== 1, 'different types does not strict equal');

            //// null, undefined and NaN
            assert.ok(null === null);
            assert.ok(undefined === undefined);
            assert.ok(null !== undefined);
            assert.ok(NaN !== NaN, 'NaN does not strict equal to any value, including itself'); // jshint ignore: line
            assert.ok(NaN !== 'a', 'NaN does not strict equal to any value, including itself'); // jshint ignore: line

            //// 0 and -0 are strict equal
            var obj1 = {x:1}, obj2 = {x:1};
            assert.ok(5 === 5);
            assert.ok(0 === -0);
            assert.ok(obj1 !== obj2, 'different object does not strict equal, event if they have the same properties');

            // equality operator
            //// type coversattion may occur bewteen different value types
            assert.ok('1' == 1, 'convert string to number');
            assert.ok(true == 1 && false == 0, 'convert boolean to number(true-->1, false-->0) firstly, and then check equality again');
            assert.ok(true == '1' && false == '0', 'convert boolean to number(true-->1, false-->0) firstly, and then check equality again');

            //// Object vs number/string/ is too complicated.
            assert.ok(obj1 != obj2, 'TODO');

            //// null and undefined are equal
            assert.ok(null == undefined);
        });
    });
});
