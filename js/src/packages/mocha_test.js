
// Mocha Practice
// https://mochajs.org

var chai = require('chai');
var chaiAsPromised = require('chai-as-promised');

chai.use(chaiAsPromised);

var assert = chai.assert;

// 1. Arrow Funtion to Mocha is discouraged. 
describe('MochaTest', function() {
    this.retries(4);
    this.slow(10000);

    // Hooks
    before(function() {
        console.log("before");
    });

    after(function() {
        console.log("after");
    });

    beforeEach(function() {
        console.log("beforeEach ---> no parameters");
    });

    beforeEach("step1", function() {
        console.log("beforeEach ---> step1");
    });

    beforeEach("step2", function() {
        console.log("beforeEach ---> step2");
    });

    beforeEach("asyncStep1", function(done) {
        setImmediate(()=>{
            console.log("beforeEach ---> asyncStep1");
            done();
        });
    });

    afterEach("asyncStep1", function(done) {
        setImmediate(()=>{
            console.log("afterEach ---> asyncStep1");
            done();
        });
    });

    afterEach("step2", function() {
        console.log("afterEach ---> step2");
    });

    afterEach("step1", function() {
        console.log("afterEach ---> step1");
    });

    afterEach(function() {
        console.log("afterEach ---> no parameters");
    });


    // Add 1 extra parameter to it to let mocha wait for the callback to be called to complete
    // the test. 
    // Because the 1st parameter in callback is error, so falsy value should pass the test,
    // anything else will cause a failed test.
    it('Asynchronous Test --- Success', function(done) {
        assert.isFunction(done);

        setImmediate(done);
    });

    it.skip('Asynchronous Test --- Error', function(done) {
        setImmediate(done, new Error());
    });

    // Promise 'Return' cannot be with callback together
    it('Promise Test --- Success', function() {
        return new Promise((resolve) => {
            assert.ok(true);
            resolve();
        });
    });

    it.skip('Promise Test --- Error', function(done) {
        return new Promise((resolve) => {
            assert.ok(true);
            resolve();
        }).then(done);
    });

    it('Delayed Root Suite --- TODO');

    it('Duration', function() {
        assert.isOk(true);
    });

    // TODO. Arrow Notation
    // describe('', ()=> {
    //     it('Arrow Functions', ()=> {
    //         this.timeout(1000);
    //         console.log(typeof this);
    //     });
    // });
});
