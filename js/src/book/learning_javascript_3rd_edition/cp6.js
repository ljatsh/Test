
// Learning JavaScript, 3rd Edition.
// Chapter 6, Functions

var assert = require('assert');

// 1. Primptive values are passed as value, and Object value are passed as reference
// 2. Parameter destructuring can be mixed with normal parameters
// 3. Prefer ... operator in ES6 than arguments variable
// 4. This is a readonly variable bound to the caller. This also bounds to something(a global object in non-strict mode, while undefined in strict mode) even in a normal function.
// 5. Closure has its own this variable different from this of its parent
// 6. Array Notation binds this to the this of its caller
// 7. Spread operator ... can be used in call
describe('Functions', function() {
    it('Value and Reference passing', function() {
        var a = 1, b = 2, obj = {age : 10};

        function test(a, b, obj) {
            a += 1;
            b += 1;
            obj.age += 1;

            return [a, b, obj];
        }

        var [c, d, e] = test(a, b, obj);
        assert.equal(a, 1);
        assert.equal(b, 2);
        assert.equal(c, 2);
        assert.equal(d, 3);
        assert.equal(obj, e);
        assert.equal(obj.age, 11);
    });

    it('Parameter Destructuring', function() {
        function test1({a, b, c}) {
            return `${a}_${b}_${c}`;
        }

        function test2([a, b, c]) {
            return `${a}_${b}_${c}`;
        }

        function test3(x, {a, b, c}, [y, z]) {
            return `${x}_${a}_${b}_${c}_${y}_${z}`;
        }

        assert.equal(test1({a:1, b:3, c:2, d:'ljatsh'}), '1_3_2');
        assert.equal(test2([1, 3, 2, 4]), '1_3_2');
        assert.equal(test3(10, {a:1, b:3, c:2}, [1, 3, 2, 4]), '10_1_3_2_1_3');
    });

    it('Variant Parameters', function() {
        function test(...args) {
            return args.join();
        }

        assert.equal(test(1, 'ljatsh', false), '1,ljatsh,false');
    });

    it('The key this', function() {
        function test() {
            // return the caller
            return this;
        }

        var a = test();
        assert.ok(a == undefined || a != null);

        var obj = {test : test};
        assert.equal(obj.test(), obj);

        function test2() {
            function inner() { return this; }

            return [this, inner()];
        };

        obj.test2 = test2;
        var [s1, s2] = obj.test2();
        assert.equal(s1, obj);
        assert.notEqual(s2, obj);
    });

    it('Arrow Notation', function() {
        function test() {
            var f = ()=> this;
            return f();
        }
        var obj = {test : test};

        var f1 = () => 1;
        var f2 = x => x * 2;

        assert.equal(f1(), 1);
        assert.equal(f2(2), 4);
        assert.equal(obj.test(), obj);
    });

    it('The call, apply and bind', function() {
        function test(...args) {
            var results = []
            for (var i=0; i<args.length; i++)
                results.push(args[i]);

            results.push(this);
            return results;
        }

        var obj = {};
        assert.deepEqual(test.call(obj), [obj]);
        assert.deepEqual(test.call(obj, 1, 'ljatsh'), [1, 'ljatsh', obj]);
        assert.deepEqual(test.call(obj, ...[1, 'ljatsh']), [1, 'ljatsh', obj]);

        assert.deepEqual(test.apply(obj, [1, 'ljatsh']), [1, 'ljatsh', obj]);

        var test2 = test.bind(obj, 1);
        assert.deepEqual(test2(2, 'ljatsh'), [1, 2, 'ljatsh', obj]);
    });
});
