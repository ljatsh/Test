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
        '1. Size Mode determines node content size:',
        '   CUSTOM: set size manually;',
        '   TRIMMED: use image size with transparent pixels trimmed;',
        '   RAW: use image size without trimming',
        '2. Trim determines render effects.'
      ];
      this.comment.string = comments.join('\n');
    }
});
