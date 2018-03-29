

// Learning JavaScript, 3rd Edition.
// Chapter 3. Literals and Variables

var assert = require('assert');

describe('Primitive types and Objects', function() {
    // 1. Number.isNaN is different from global isNan. Number.isNaN determines whether the passed value is NaN and its type is Number. While global isNaN converts the passed value to Number.
    // 2. Both equality operators, == and ===, evaluating to false when checking NaN is Nan. This is why Number.isNaN() becomes necessary.
    describe('Number', function() {
        it('NaN', function() {
            assert.notEqual(Number.isNaN, isNaN, 'global isNan is different from Number.isNaN');

            // 'NaN', undefined, {}, 'blabla' should be true with global isNaN
            assert.ok(!Number.isNaN('NaN'));
            assert.ok(!Number.isNaN(undefined));
            assert.ok(!Number.isNaN({}));
            assert.ok(!Number.isNaN('blabla'));

            assert.ok(isNaN('NaN'));
            assert.ok(isNaN(undefined));
            assert.ok(isNaN({}));
            assert.ok(isNaN('blabla'));

            assert.ok(!(NaN == NaN), 'Nan == Nan is false');
            assert.ok(!(NaN === NaN), 'Nan === Nan is false');

            assert.ok(Number.isNaN(NaN));
            assert.ok(Number.isNaN(Number.NaN));
            assert.ok(Number.isNaN(0/0));
        });

        it('Infinity', function() {
            assert.ok(!Number.isFinite(1/0));
        });

        it('Convered from string', function() {
            assert.equal(Number.parseInt('5.6'), 5, 'numbers after dot are omitted');
            assert.equal(Number.parseInt(' 5 '), 5, 'leading spaces are ignored');
            assert.equal(Number.parseInt('ab', 16), 0xab, 'hexdecimal parsing');
            assert.ok(Number.isNaN(Number.parseInt('ab')));
            assert.equal(Number.parseInt, parseInt, 'global parseInt is alias of Number.parseInt');

            assert.equal(1.5, Number.parseFloat('1.5'));
            assert.equal(1.5, Number.parseFloat('1.5a'), 'first non digit character and remain ones are omitted');
            assert.equal(Number.parseFloat, parseFloat, 'global parseFloat is alias of Number.parseFloat');
        });

        it('Converts to string', function() {
            assert.equal((16.7).toString(), '16.7', 'default radix is 10');
            assert.equal((16).toString(16), '10', 'hexdecimal format');
            assert.equal((-16).toString(2), '-10000', 'binary format');
        });

        it('The valueOf', function() {
            var numObj = new Number(11);
            var num = numObj.valueOf();
            assert.equal(num, 11);
            assert.equal(typeof(numObj), 'object');
            assert.equal(typeof(num), 'number');
        });
    });

    // 1. undefined, null, NaN, 0, '', false is falsy. Anything else is truthy
    describe('Boolean', function() {
        it('The falsy and truthy', function() {
            assert.ok(!undefined);
            assert.ok(!null);
            assert.ok(!NaN);
            assert.ok(!0);
            assert.ok(!'');
            assert.ok(!false);

            assert.ok(new Boolean(false), 'any object is truthy, including objects whose valueOf returns false');
            assert.ok([], 'array is truthy, event it is empty');
            assert.ok(' ', 'non empty string is truthy');
            assert.ok('false');
        });
    });

    // 1. searchValue in lastIndexOf has special meaning
    describe('String', function() {
        it('Normal Operations', function() {
            var s = 'Hello, JavaScript!';
            assert.equal(s.charAt(4), 'o', 'index begins from 0');
            assert.equal(s.charAt(100), '', 'empty string is returned if index is invalid');
            assert.equal(s.indexOf('o,'), 4);
            assert.equal(s.indexOf('ss'), -1);
            assert.equal(s.lastIndexOf('a'), 10);
            assert.equal(s.lastIndexOf('', 3), 3, 'if searchValue is empty string, the fromIndex is returned');
            assert.equal(s.substr(2, 3), 'llo');
            assert.equal(s.substr(-5), 'ript!', 'negative index starts counting from the end of the string');
            assert.equal(s.substring(2, 5), 'llo', 'indexEnd is exlcuded');
            assert.equal(s.substring(5, 2), 'llo', 'if indexStart is greater than indexEnd, two indexes were swapped');
            assert.equal(s.substring(2, 2), '');
        });

        it('Split and Join', function() {
            // TODO RegExp
        });

        // 1. null is object while undefined id undefined
        // 2. prefer null when unsure
        it('The null and undefined', function() {
            assert.equal(typeof(null), 'object');
            assert.equal(typeof(undefined), 'undefined');
        });
    });
})
