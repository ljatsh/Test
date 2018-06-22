
var chai = require('chai');
var mongoClient = require('mongodb').MongoClient;

var assert = chai.assert;

var url = 'mongodb://localhost:27017';
var dbname = 'test_js';

// http://mongodb.github.io/node-mongodb-native/2.2/quick-start/quick-start/
// https://docs.mongodb.com/manual/tutorial/getting-started/

// https://stackoverflow.com/questions/8360318/global-leak-errors-in-mocha

describe('MongoDbDriverTuturial', function() {
  var _client = null;
  var _db = null;
  var _collection_test1 = null;

  before(function(done) {
    mongoClient.connect(url, function(err, client) {
      assert.isNull(err);

      _client = client;
      _db = client.db(dbname);
      _collection_test1 = _db.collection('test1');
      // TODO db properties check

      done();
    });
  });

  after(function() {
    _collection_test1.remove();
    _client.close();
  });

  beforeEach(function() {
    _collection_test1.remove();
  });

  afterEach(function() {
    
  });

  it('InsertOneTest', function(done) {
    _collection_test1.insertOne({
      name: 'lj@sh',
      age: 34
    }, function(err, result) {
      assert.isNull(err);
      
      _collection_test1.find({name: 'lj@sh'}).toArray(function(err, docs) {
        assert.strictEqual(1, docs.length);

        var doc = docs[0];
        assert.strictEqual('lj@sh', doc.name);
        assert.strictEqual(34, doc.age);
        assert.isNotNull(doc._id);
      
        done();
      });
    });
  });

  it('InsertManyTest', function(done) {
    _collection_test1.insertMany([
      {name: 'lj@sh', age: 34},
      {name: 'lj@bj', age: 40}
    ], function(err, results) {
      assert.isNull(err);
      assert.strictEqual(2, results.insertedCount);

      done();
    } );
  });

  it('Test2', function() {
    //assert.isNotNull(this.db);
  });
});
