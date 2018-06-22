
module.exports.home = function(req, res) {
  res.render('location_list', { 
    title: 'Loc8r - find a place to work with wifi',
    pageHeader: {
      title: 'Loc8r',
      strapline: 'Find places to work with wifi near you!'
    },
    locations: [{
        name: 'Starcups',
        address: '125 High Street, Reading, RG6 1PS',
        rating: 3,
        facilities: ['Hot drinks', 'Food', 'Premium wifi'],
        distance: '100m'
      },{
        name: 'Cafe Hero',
        address: '125 High Street, Reading, RG6 1PS',
        rating: 4,
        facilities: ['Hot drinks', 'Food', 'Premium wifi'],
        distance: '200m'
      },{
        name: 'Burger Queen',
        address: '125 High Street, Reading, RG6 1PS',
        rating: 2,
        facilities: ['Food', 'Premium wifi'],
      distance: '250m'
    }]    // end of location
   });
};

module.exports.locationInfo = function(req, res) {
  res.render('location_info', {
    title: 'Location Info',
    location: {
      name: 'Burger Queen',
      address: '125 High Street, Reading, RG6 1PS',
      rating: 2,
      facilities: ['Food', 'Premium wifi'],
      distance: '250m',
      openingTimes: [ {
        days: 'Monday - Friday',
        opening: '7:00am',
        closing: '7:00pm',
        closed: false
      }, {
        days: 'Saturday',
        opening: '8:00am',
        closing: '5:00pm',
        closed: false
        }, {
          days: 'Sunday',
          closed: true
        }
      ],
      reviews: [ {
        author: 'lj@sh',
        rating: 5,
        reviewText: 'What\'s a greate place! I can sit here to enjoy reading.',
        createdOn: '2018-06-15 18:31:05'
      }, {
        author: 'anoymous',
        rating: 3,
        reviewText: 'Not so good',
        createdOn: '2018-06-17 14:07:09'
      }
      ]
    } // end of location
  });
};

module.exports.addReview = function(req, res) {
 res.render('location_review_form', { title:'Add review' });
};
