
var mongoose = require('mongoose');
var Loc = mongoose.model('Location');

var sendResponse = function(res, status, msg) {
  res.status(status);
  res.json(msg);
};

module.exports.locationList = function(req, res) {
  Loc.find(function(err, objs) {
    sendResponse(res, 200, objs);
  });

  //sendResponse(res, 200, {status: 'success'});
};
