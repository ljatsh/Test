
var express = require('express');
var router = express.Router();
var ctrlLocation = require('../controllers/location');

router.get('/locations', ctrlLocation.locationList);

module.exports = router;
