
module.exports.home = function(req, res) {
  res.render('location_list', { title: 'Home' });
};

module.exports.locationInfo = function(req, res) {
  res.render('location_info', { title: 'Location Info' });
};

module.exports.addReview = function(req, res) {
 res.render('location_review_form', { title:'Add review' });
};
