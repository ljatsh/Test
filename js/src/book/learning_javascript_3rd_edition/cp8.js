// Learning JavaScript, 3rd Edition.
// Chapter 8. Arrays and Array Processing.

var assert = require('assert');

// 1. Like memmove, Array.copyWithin can solve overlap issue
// 2. Don't use for...in to traverses Array, because there are sparse Array and non-index enumerable properties(TODO) issue. Perfer forEach/some/every instead.
// 3. Avoid to change array length during forEach.
// 4. find/findIndex is not efficient for sparse Array
// 5. Avoid to sort number Array by the default comparisionFunc
// 6. Be careful that callback in map has 3 parameters! TODO: How to use Array.prototype.map
describe('Arrays', function() {
    it('Creation', function() {
        var obj = {};
        // 1. Literal
        var a = [1, obj, 3];
        assert.equal(a.length, 3);

        // 2. Constructor
        var b = new Array(); // jshint ignore: line
        assert.equal(b.length, 0);
        assert.equal(b[0], undefined, 'access an index larger than the array does not change the array size');
        b[1] = 3;
        assert.equal(b.length, 2, 'assign an index lager than the array does change the array size');
        assert.equal(b[0], undefined);
        assert.equal(b[1], 3);

        var c = new Array(1);
        assert.equal(c.length, 1, '1 number parameter means the array size');
        assert.equal(c[0], undefined);

        var d = new Array('1');
        assert.equal(d.length, 1);
        assert.equal(d[0], '1');

        var e = new Array(1, obj, 3);
        assert.deepEqual(a, e);

        // 3. Array.from
        assert.deepEqual(Array.from('abc'), ['a', 'b', 'c'], 'Array from string');
        function test() {
            return Array.from(arguments);
        }
        assert.deepEqual(test('a', 'b', 'c'), ['a', 'b', 'c'], 'Array from Array-like object(arguments)');

        assert.deepEqual(Array.from([1, 2, 3], x => x << 1), [2, 4, 6], 'mapFunc was set');
        // TODO: sequence generator. Any other ways?
        assert.deepEqual(Array.from({length: 5}, (v, i) => i), [0, 1, 2, 3, 4], 'Object iteration');
    });

    it('Operate on Front or End', function() {
        var a = [1, 2, 3];

        assert.equal(4, a.push(4), 'push returns new length');
        assert.deepEqual(a, [1, 2, 3, 4]);
        assert.equal(a.unshift(0), 5, 'unshift returns new length');
        assert.deepEqual(a, [0, 1, 2, 3, 4]);

        assert.equal(a.shift(), 0, 'shift returns the shifted element');
        assert.equal(a.pop(), 4, 'pop returns the popped element');
        assert.deepEqual(a, [1, 2, 3]);
    });

    it('Operation at any position', function() {
        var a = [1, 2, 3, 4, 5];
        // insert & remove
        var removed = a.splice(1, 0, 10, 11);
        assert.equal(removed.length, 0);
        assert.deepEqual(a, [1, 10, 11, 2, 3, 4, 5]);

        removed = a.splice(1, 2);
        assert.deepEqual(removed, [10, 11]);
        assert.deepEqual(a, [1, 2, 3, 4, 5]);

        removed = a.splice(2, 3, 30, 40, 50);
        assert.deepEqual(removed, [3, 4, 5]);
        assert.deepEqual(a, [1, 2, 30, 40, 50]);

        // replace
        a = [1, 2, 3, 4, 5, 6];
        assert.deepEqual(a.copyWithin(0, 2), [3, 4, 5, 6, 5, 6], 'the past sequence still can have the copy sequence even the copy and past region are overlapped');
        a = [1, 2, 3, 4, 5, 6];
        assert.deepEqual(a.copyWithin(1, 0), [1, 1, 2, 3, 4, 5], 'the past sequence still can have the copy sequence even the copy and past region are overlapped');
    });

    it('Slice', function() {
        assert.deepEqual([1, 2, 3, 4].slice(0, 2), [1, 2]);
        assert.deepEqual([1, 2].slice(), [1, 2], 'a simple way to clone array');
        assert.equal([1, 2].slice(1, 0), 0, 'begin must be less or then end');
        assert.equal([1, 2].slice(1, 1), 0, 'begin must be less or then end');
    });

    it('Search', function() {
        var a = [1, 1, 2, 5, 5, 7];
        assert.equal(a.indexOf(5, 4), 4);
        assert.equal(a.indexOf(5), 3);
        assert.equal(a.lastIndexOf(5), 4);
        assert.equal(a.lastIndexOf(6), -1);

        // find
        //       0. 1. 2. 3.4. 5. 6. 7. 8 9
        var b = [1, 1, 2, , 3, 3, 4, 4, , 5];
        var c = [];
        function search(target, element, index) {
            c.push(index);
            if (target == element)
                return true;

            return false;
        }

        var result = b.find(search.bind(undefined, 3));
        assert.equal(result, 3);
        assert.deepEqual(c, [0, 1, 2, 3, 4]);

        c.splice(0, c.length);
        assert.equal(c.length, 0);
        assert.equal(b.find(search.bind(undefined, 10)), undefined, 'failed to search');

        // findIndex
        c.splice(0, c.length);
        result = b.findIndex(search.bind(undefined, 3));
        assert.equal(result, 4);
        assert.deepEqual(c, [0, 1, 2, 3, 4]);

        c.splice(0, c.length);
        assert.equal(b.findIndex(search.bind(undefined, 10)), -1, 'failed to search');

        // some and every is much more efficient than find
    });

    it('Sort', function() {
        var a = [80, 9, 7];
        assert.deepEqual(a.sort(), [7, 80, 9]);
        assert.deepEqual(a.sort((a, b) => a - b), [7, 9, 80]);
    });

    it('Traversal', function() {
        var a = new Array(3).fill(9);
        delete a[1]; // make a sparse array

        var b = [];
        a.forEach((element, index) => b.push(index));
        assert.deepEqual(b, [0, 2]);
    });

    it('Map and Filter', function() {
        assert.deepEqual([1, 4, 9].map(Math.sqrt), [1, 2, 3]);
        assert.deepEqual([1, 2, 4, 5].filter(x=> x%2 == 0), [2, 4]);
    });
});
