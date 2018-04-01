
// Learning JavaScript, 3rd Edition.
// Chapter 9. Objects and Object-Oriented Programming.

var assert = require('assert');

// 1. There are 3 broad categories of objects: Native Object, Host Object and User Defined Object
// 2. Inheritance occurs when quering properties but not setting them
// 3. The delete operator can only delete object's own property
// 4. Prefer in than obj.x !== undefined, because in can distinguish between property missing and undefined property
// 5. Getter and Setter is similar to C# Property
describe('OOP', function() {
    describe('Objects', function() {
        it('Object Creation', function() {
            // Object Literals
            var count = 1;
            function nextValue() {
                count++;
                return count;
            }

            //// Property name can contain blank, -
            var obj = {'his-name': 'ljatsh', 'the sex': 'm'};
            var objs = [];
            for (var i=0; i<3; i++) {
                objs.push({'count':nextValue()});
            }

            //// The value of each property is evaluated each time the literal is evaluated.
            assert.deepEqual(objs, [{'count':2}, {'count':3}, {'count':4}]);

            // New constructor
            // TODO

            // Object.create
            // TODO
        });

        it('Property Query and Set', function() {
            var obj = {x: 1};
            var obj2 = Object.create(obj);
            assert.equal(obj2.x, 1);
            obj2.x = 2;
            assert.equal(obj2.x, 2);
            assert.equal(obj.x, 1, 'setting property overrides the prototype property');
        });

        it('Property Delete', function() {
            var obj = {x:1};
            delete obj.x;
            //// cannot delete prototype property
            delete obj.toString;

            assert.equal(obj.x, undefined);
            assert.equal(obj.toString, Object.prototype.toString);
        })

        it('Property Test', function() {
            // in operator
            var obj = {x:1, y:1, '1':'ljatsh'}
            //// in expects string value on its left side
            assert.ok('x' in obj)
            assert.ok(1 in obj, '1 was converted to "1" implicitly') // TODO. implicit value conversion
            assert.ok('toString' in obj, 'in also checks inherited properties')

            // hasOwnProperty
            assert.ok(obj.hasOwnProperty('x'))
            assert.ok(obj.hasOwnProperty(1))
            assert.ok(!obj.hasOwnProperty(2))
            assert.ok(!obj.hasOwnProperty('toString'))
        });

        it('Property Enumerable', function() {
            // Nothing to do
        });

        it('Property Getter and Setter', function() {
            var obj = {
                $rw: 0,
                get rw() { return this.$rw; },
                set rw(value) { this.$rw = value; },

                $r: 1,
                get r() { return this.$r; },

                $w: 2,
                set w(value) { this.$w = value; }
            }

            // read-write ancessor
            assert.equal(obj.rw, 0)
            obj.rw = 5
            assert.equal(obj.rw, 5)

            // read-ancessor
            assert.doesNotThrow(() => {obj.r = 2}, 'set a read-only ancessor does not throw')
            assert.equal(obj.r, 1)

            // write-ancessor
            assert.equal(obj.w, undefined, 'write-only ancessor evaluates undefined')
        });
    });
});
