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
        '1. Anchor point determines which point of the node itself shoule be taken as the position of the whole node',
        '2. Anchor point is also the coordinate origin of all of its children',
        '3. Node rotates by its anchor point and the rotation value is angle, not radian. When the angle value is positive,' +
           'the node rotates clockwise. Otherwise, the node rotates anticlockwise.',
        '4. Scale does not change node size',
        '5. Color and Opacity affects render effect of all children.'
      ];
      this.comment.string = comments.join('\n');
    }
});
