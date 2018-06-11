var express = require('express');
var router = express.Router();
var ctrlLocation = require('../controllers/location');
var ctrlAbout = require('../controllers/about');

/* GET home page. */
router.get('/', ctrlLocation.home);
router.get('/location', ctrlLocation.locationInfo);
router.get('/location/review/new', ctrlLocation.addReview);

router.get('/about', ctrlAbout.about);

module.exports = router;
