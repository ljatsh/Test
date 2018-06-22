
var mongoose = require('mongoose');

var openingTimesSchema = new mongoose.Schema({
  days: {type: String, required: true},
  opening: {type: String},
  closing: {type: String},
  closed: {type: Boolean, default: false, required: true}
});

var reviewSchema = new mongoose.Schema({
  author: {type: String, required: true},
  rating: {type: Number, required: true, min: 0, max: 5},
  reviewText: String,
  createdOn: {type: Date, default: Date.now}
});

var locationSchema = new mongoose.Schema({
  name: {type: String, required: true},
  rating: {type: Number, "default": 0, min: 0, max: 5},
  facilities: [String],
  distance: Number,
  openingTimes: [openingTimesSchema],
  reviews: [reviewSchema]
});

mongoose.model('Location', locationSchema, 'locations');

