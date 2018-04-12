
// Learning JavaScript, 3rd Edition.
// Chapter 9. Objects and Object-Oriented Programming.

var assert = require('assert');

// 1. There are 3 broad categories of objects: Native Object, Host Object and User Defined Object
// 2. Inheritance occurs when quering properties but not setting them
// 3. The delete operator can only delete object's own property
// 4. Prefer in than obj.x !== undefined, because in can distinguish between property missing and undefined property
// 5. Getter and Setter is similar to C# Property
// 6. Every object has constructor property. Object's prototype property cannot be accessed directy.
//    It can be queried by Object.getPropertyOf or by obj.constructor.prototype. However, this does not work for objects
//    crated by Object.create() and it also maybe failed. -- TODO
// 7. Function prototype always contains constructor property pointing to the function itself. Adhere to this idiom.
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
            obj = new Array()
            assert.equal(obj.length, 0);

            // Object.create
            obj = Object.create(Object.prototype, {
                x: {value:2, writeable:true, configurable:true}
            });
            assert.equal(obj.x, 2);
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
            var obj = {x:1, y:2};
            assert.deepEqual(Object.keys(obj), ['x', 'y']);
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
            assert.equal(obj.rw, 0);
            obj.rw = 5;
            assert.equal(obj.rw, 5);

            // read-ancessor
            assert.doesNotThrow(() => {obj.r = 2}, 'set a read-only ancessor does not throw');
            assert.equal(obj.r, 1);

            // write-ancessor
            assert.equal(obj.w, undefined, 'write-only ancessor evaluates undefined');
        });

        it('Property Attributes', function() {
            var obj = {x:1};
            var descriptor = Object.getOwnPropertyDescriptor(obj, 'x');
            //// the default attributes are true if the property is created with object literal
            assert.ok(descriptor.writable);
            assert.ok(descriptor.enumerable);
            assert.ok(descriptor.configurable);

            Object.defineProperty(obj, 'x', {value:2, writable:false});
            Object.defineProperty(obj, 'y', {value:2});

            /// If you are modifying an existing property, the attributes you omitted in definedProperty are left unchanged.
            descriptor = Object.getOwnPropertyDescriptor(obj, 'x');
            assert.equal(obj.x, 2);
            assert.ok(!descriptor.writable);
            //// TODO obj.x = 3 throws in restrict mode
            obj.x = 3;
            assert.equal(obj.x, 2);
            assert.ok(descriptor.enumerable);
            assert.ok(descriptor.configurable);

            //// If you are createing a new property, the attributes are false if they are omitted in definedProperty
            descriptor = Object.getOwnPropertyDescriptor(obj, 'y');
            assert.ok(!descriptor.wrirtable);
            assert.ok(!descriptor.enumerable);
            assert.ok(!descriptor.configurable);
        });

        it('Object Attributes --- prototype', function() {
            // object literal
            var obj = {};
            assert.equal(obj.constructor.prototype, Object.getPrototypeOf(obj), 'object.constructor.prototype is deprecated');
            assert.equal(Object.getPrototypeOf(obj), Object.prototype, 'Object literals use Object.prototype of their prototype');

            var array = [1, 2];
            assert.equal(array.constructor.prototype, Object.getPrototypeOf(array), 'constructor.property is deprecated');
            assert.equal(Object.getPrototypeOf(array), Array.prototype, 'Array literals use Array.prototype of their prototype');

            // objects create by constructor
            obj = {};
            assert.equal(obj.constructor.prototype, Object.getPrototypeOf(obj), 'object.constructor.prototype is deprecated');
            assert.equal(Object.getPrototypeOf(obj), Object.prototype, 'Object literals use Object.prototype of their prototype');

            array = [1, 2];
            assert.equal(array.constructor.prototype, Object.getPrototypeOf(array), 'constructor.property is deprecated');
            assert.equal(Object.getPrototypeOf(array), Array.prototype, 'Array literals use Array.prototype of their prototype');

            // objects create by Object.create
            var prototype = {name:'ljatsh'};
            obj = Object.create(prototype);
            assert.equal(Object.getPrototypeOf(obj), prototype);
            assert.ok(obj.constructor != null, 'objects created by Object.create also has constructor');
            assert.ok(obj.constructor.prototype != Object.getPrototypeOf(obj));

            // TODO: Object.create mechanism
            assert.ok(obj instanceof obj.constructor)
            assert.ok(obj.constructor.prototype.isPrototypeOf(obj));
            var x = Object.getPrototypeOf(obj);
            assert.ok(obj instanceof x.constructor)
            assert.ok(x.isPrototypeOf(obj));
        });

        it('Object Attributes --- class', function() {
            //// default toString returns class attribute ---> [object class] in string format
            function classof(o) {
                if (o === null) return "Null";
                if (o === undefined) return "Undefined";
                return Object.prototype.toString.call(o).slice(8, -1);
            }

            //// objects created by built in constructors contains detailed information
            assert.equal(classof({}), 'Object');
            assert.equal(classof([]), 'Array');
            assert.equal(classof(""), 'String');
            assert.equal(classof(true), 'Boolean');
            assert.equal(classof(/./), 'RegExp');
            assert.equal(classof(new Date()), 'Date');

            //// other objects is Object
            var prototype = {name:'ljatsh'};
            var obj = Object.create(prototype);
            assert.equal(classof(obj), 'Object');

            function F() {}
            obj = new F;
            assert.equal(classof(obj), 'Object');
        });

        it('Object & Constructor', function() {
            function F() {}

            var obj = new F;
            assert.equal(F.prototype.constructor, F, 'function prototype always contains constructor property pointing to the function itself');
            assert.equal(obj.constructor, F, 'object inherites the constructor property');
        });

        // function is object Function
        it('Object & Function', function() {
            function F() {}

            assert.equal(Object.getPrototypeOf(F), Function.prototype);
        });

        it('instanceof operator and Object.isPrototypeOf', function() {
            // instanceof operator checks whether the prototype of a constrctor appears anywhere
            // in the prototype chain of an object. Left operand is the object and right is the
            // constructor

            function F() {}
            var obj = new F;

            assert.ok(obj instanceof F);
            assert.ok(obj instanceof Object);
            assert.ok(F.prototype instanceof Object);

            var prototype = {};
            obj = Object.create(prototype);
            assert.ok(obj instanceof obj.constructor, 'TODO');

            // Object.prototype.isPrototypeOf checks if an object exists in another object's prototype chain
            function Object1() {}
            function Object2() {}

            Object2.prototype = Object.create(Object1.prototype);

            obj = new Object2;
            assert.ok(Object2.prototype.isPrototypeOf(obj));
            assert.ok(Object1.prototype.isPrototypeOf(obj), 'prototype chain');
        });
    });
});
