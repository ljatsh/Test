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
      progressBar: cc.Node,
      background: cc.Node,
      speed: 100          // speed in second
    },

    // LIFE-CYCLE CALLBACKS:

    // onLoad () {},

    start: function() {

    },

    update: function(dt) {
      this.updateWidth(this.progressBar, 600, dt);
      this.updateWidth(this.background, 1000, dt);
    },

    updateWidth: function(target, maxValue, dt) {
      var width = target.width;
      width += this.speed * dt;
      target.width = width > maxValue ? 0 : width;
    }
});
