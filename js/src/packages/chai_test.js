
// Chai Practice
// http://www.chaijs.com/
// Assert Styple API: http://www.chaijs.com/api/assert/

var chai = require('chai');
var assert = chai.assert;

describe('ChaiTest', function() {
    it('Style --- Assert', function() {
        function Test() {
        }

        var obj1 = {a:1};
        var obj2 = {b:2};
        var obj3 = Object.create(obj1, {c1: {value:3, writable:false},
                                        c2: {value:4, writable:false}});

        assert.isOk({});
        assert.isNotOk(undefined);
        assert.equal([1].length, '1');
        assert.notEqual([1].length, 2);
        assert.strictEqual([1].length, 1);
        assert.notStrictEqual([1].length, '1');
        assert.deepEqual([1, 2, 3], [1, 2, 3]);
        assert.notDeepEqual({name:'ljatsh', age:34}, {name:'ljatsh2', age:34});

        // Comparision
        assert.isAbove(5, 2);
        assert.isAtLeast(2, 2);
        assert.isBelow(2, 5);
        assert.isAtMost(2, 3);

        // Boolean & Null & Undefined & Nan Check
        assert.isTrue(true);
        assert.isNotTrue({});
        assert.isFalse(false);
        assert.isNotFalse(undefined);
        assert.isNull(null);
        assert.isNotNull(undefined);
        assert.isNaN(Number.parseInt('ab'));
        assert.isNotNaN(1/0);
        assert.exists({});
        assert.notExists(null);
        assert.notExists(undefined);
        assert.isUndefined(undefined);
        assert.isDefined(1);

        // Type Check
        assert.isFunction(x=>1);
        assert.isNotFunction(1);
        assert.isObject(Object.create({}));
        assert.isNotObject('Hello');
        assert.isArray([1]);
        assert.isNotArray({});
        assert.isString('Hello');
        assert.isNotString(1);
        assert.isNumber(1);
        assert.isNotNumber('1');
        assert.isFinite(0xffffffffffffffff);
        assert.isBoolean(true);
        assert.isNotBoolean(NaN);
        assert.typeOf('1', 'string');
        assert.notTypeOf('1', 'Number');
        assert.instanceOf(new Test(), Test);
        assert.notInstanceOf(Object.create(null), Object);

        // Set Check
        //// 1. include can be used in array, string and properties of object. Strict equality(===) is used
        //// 2. deepInclude can be used in array and properties of object. Deep equality is used
        //// 3. nestedInclude can be used in properties of object. dot and bracket in property names should be escaped.
        assert.include([obj1, obj2], obj1);
        assert.notInclude([obj1, obj2], {b:2});
        assert.include('abcd', 'bc');
        assert.notInclude('abcd', 'bce');
        assert.include({obj1:obj1, obj2:obj2}, {obj2:obj2});
        assert.notInclude({obj1:obj1, obj2:obj2}, {obj2:{b:2}});
        assert.deepInclude([obj1, obj2], {b:2});
        assert.notDeepInclude([obj1, obj2], {b:3});
        assert.deepInclude({obj1:obj1, obj2:obj2}, {obj2:{b:2}});
        assert.notDeepInclude({obj1:obj1, obj2:obj2}, {obj2:{b:3}});
        assert.nestedInclude({a:{b:1, c:2}}, {'a.b':1});
        assert.nestedInclude({a:{b:1, '.c':2}}, {'a.\\.c':2});
        assert.nestedInclude({a:{'[b]':1}}, {'a.\\[b\\]':1});
        assert.notNestedInclude({a:{b:1, c:2}}, {'a.c':3});
        assert.deepNestedInclude({a:{b:[{x:1}]}}, {'a.b[0]':{x:1}});
        assert.notDeepNestedInclude({a:{'b[0]':[{x:1}]}}, {'a.b\\[0\\][0]':{x:2}});
        assert.ownInclude(obj3, {c1:3, c2:4});
        assert.include(obj3, {a:1});
        assert.notOwnInclude(obj3, {a:1});

        // TODO Match
    }); 

    it('Style --- Expect', function() {
        // TODO
    });
});