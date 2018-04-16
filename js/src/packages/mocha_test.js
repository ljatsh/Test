
// Mocha Practice
// https://mochajs.org

var assert = require('assert');

describe('MochaTest', function() {
    // Add 1 extra parameter to it to let mocha wait for the callback to be called to complete
    // the test. 
    // Because the 1st parameter in callback is error, so falsy value should pass the test,
    // anything else will cause a failed test.
    it('Asynchronous Test --- Success', function(done) {
        assert.equal(typeof done, 'function');

        setImmediate(done);
    });

    it('Asynchronous Test --- Error', function(done) {
        setImmediate(done, new Error());
    });

    // // Promise 'Return' cannot be with callback together
    // it('Promise Test 1', function() {
    //     return new Promise((resolve) => {
    //         assert.ok(true);
    //         resolve();
    //     });
    // });

    // it('Promise Test 2', function(done) {
    //     new Promise((resolve) => {
    //         assert.ok(true);
    //         resolve(true);
    //     }).then(done);
    // });
});
