// Learn cc.Class:
//  - [Chinese] http://docs.cocos.com/creator/manual/zh/scripting/class.html
//  - [English] http://www.cocos2d-x.org/docs/creator/en/scripting/class.html
// Learn Attribute:
//  - [Chinese] http://docs.cocos.com/creator/manual/zh/scripting/reference/attributes.html
//  - [English] http://www.cocos2d-x.org/docs/creator/en/scripting/reference/attributes.html
// Learn life-cycle callbacks:
//  - [Chinese] http://docs.cocos.com/creator/manual/zh/scripting/life-cycle-callbacks.html
//  - [English] http://www.cocos2d-x.org/docs/creator/en/scripting/life-cycle-callbacks.html

cc.Class({
  extends: cc.Component,

  properties: {
    comment: cc.Label
  },

    // LIFE-CYCLE CALLBACKS:

    // onLoad () {},

    start: function() {
      var comments = [
        '1. Exactly fit screen width and height is not preferred. Differenct scale factors would distore the image.',
        '2. Fit both width and height dimension would show black borders on many devices.',
        '3. Good Practice:',
        '   * Avoid to distore the image.',
        '   * Prefer missing background borders than black borders'
      ];
      this.comment.string = comments.join('\n');
    }
});
