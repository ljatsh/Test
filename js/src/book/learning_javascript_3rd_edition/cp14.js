
// Learning JavaScript, 3rd Edition.
// Chapter 14. Asynchronous Programming

var chai = require('chai');
var chaiAsPromised = require('chai-as-promised');

chai.use(chaiAsPromised);

var assert = chai.assert;

// Promise:
//   Gurantee:
//   1. Callback will never to be called before the completion of the current run of the JavaScript event loop.
//   2. Callback added with then can be called even the promise was settled.
//   3. Multile callbacks can be added with then several times to be executed independently in insertion order
  
//   Chain:
//   1. Returned non-promise value from the callback will be propogated.
//   2. Promise value of the returned resolved promise from the callback will be propogated.
//   3. If callback returns a pending promise, resolution/rejection of the new created promise will be subsequent
//      to the resolution/rejection of the pending promise.
//   4. Error Propogation in Promise Chain just like catch clause.

describe('Asynchronous Programming', function() {
    describe('Promise Test', function() {
        it('Promise Signature', function(done) {
            var promise = new Promise((resolve, reject) => {
                assert.isFunction(resolve);
                assert.isFunction(reject);

                resolve();
            });

            promise.then(done);
        });

        // If the callback handler returns a value, the created promise will be resolved with the returned value as its value
        it('Then method ---> 1', function(done) {
            Promise.resolve(3)
                   .then((value) => { return value * 2; })
                   .then((value) => {
                        assert.equal(value, 6);
                        done();
                   });
        });

        // If the callback handler returns a resolved promise, the created promise will be resolved with that promise's value as its value
        it('Then method ---> 2', function(done) {
            var promise = Promise.resolve(3);
            promise.then(()=> { return promise; })
                   .then((value)=> {
                        assert.equal(value, 3);
                        done();
                   });
        });

        // If the callback handler returns a pending promise, the resolution/rejection of the created promise will be
        // subsequent to the resolution/rejection of that pending promise.
        it('Then method ---> 3', function(done) {
            var data = [];

            var promise = new Promise((resolve) => {
                setImmediate(()=> { resolve(3); });
            });
            promise.then((value)=> { data.push(value); });

            Promise.resolve(0)
                   .then(()=> { return promise; })
                   .then((value)=> {
                        assert.equal(value, 3);
                        assert.deepEqual(data, [3]);
                        done();
                   });
        });

        // Callback will never to be called before the completion of the current run of the JavaScript event loop
        it('Promise Gurantee ---> 1', function() {
            var data = [];
            var promise = Promise.resolve().then(()=> { assert.deepEqual(data, [2]); });
            data.push(2);

            return promise;
        });

        // Callback added with then can be called even the promise was settled
        // multile callbacks can be added with then several times to be executed independently in insertion order
        it('Promise Gurantee ---> 2', function(done) {
            var data = [];
            var promise = Promise.resolve(1);

            promise.then((message)=> { data.push(message); });
            promise.then((message)=> { data.push(message * 2); });
            process.nextTick(function() { promise.then((message)=>{ assert.deepEqual(data, [1, 2]);
                                                                    assert.equal(message, 1);
                                                                    done();
                                                                  });
                                        });
        });

        it('Error Propogation', function(done) {
            var data = [];
            var catched = false;
            Promise.reject(100)
                   .then(()=> { data.push(1); })
                   .then(()=> { data.push(2); })
                   .catch((reason)=> {
                        assert.equal(data.length, 0);
                        assert.equal(reason, 100);
                        catched = true;
                   })
                   .then((value)=> {
                                     assert.isUndefined(value);
                                     return Promise.resolve(1);
                                   })
                   .then((value)=> {
                                     data.push(value);
                                     return value;
                                    })
                   .then((value)=> {
                                     throw 99;
                   })
                   .catch((reason)=> {
                                     assert.isTrue(catched);
                                     assert.deepEqual(data, [1]);
                                     assert.equal(reason, 99);
                                     done();
                   });
        });
    });
});
