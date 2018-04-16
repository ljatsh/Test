
// Chai-as-promised Practice
// https://www.npmjs.com/package/chai-as-promised

var chai = require('chai');
var chaiAsPromised = require('chai-as-promised');

chai.use(chaiAsPromised);

var assert = chai.assert;

// TODO
describe('Chai-as-promised Test', function() {
    it('Style --- Assert', function() {
        assert.eventually.equal(Promise.resolve(2+2), 4);
    });
});
