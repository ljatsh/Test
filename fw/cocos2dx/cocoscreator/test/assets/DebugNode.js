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
    // foo: {
    //     // ATTRIBUTES:
    //     default: null,        // The default value will be used only when the component attaching
    //                           // to a node for the first time
    //     type: cc.SpriteFrame, // optional, default is typeof default
    //     serializable: true,   // optional, default is true
    // },
    // bar: {
    //     get () {
    //         return this._bar;
    //     },
    //     set (value) {
    //         this._bar = value;
    //     }
    // },

    //debugTarget: cc.Node,

    anchorPointColor: cc.color(255, 0, 0),
    borderColor: cc.color(255, 0, 0),
    anchorPointRadius: 5.0,
    borderWidth: 1.0
  },

  // LIFE-CYCLE CALLBACKS:

  // onLoad () {},

  start () {
    this.drawNode = new cc.DrawNode();
    this.node._sgNode.addChild(this.drawNode);

    var size = this.node.getContentSize();
    var anchorPoint = this.node.getAnchorPoint();
    var anchorPointPosition = cc.p(size.width * anchorPoint.x, size.height * anchorPoint.y);

    this.drawNode.drawSegment(cc.pSub(cc.p(0, 0), anchorPointPosition), cc.pSub(cc.p(size.width, 0), anchorPointPosition), this.borderWidth, this.borderColor);
    this.drawNode.drawSegment(cc.pSub(cc.p(size.width, 0), anchorPointPosition), cc.pSub(cc.p(size.width, size.height), anchorPointPosition), this.borderWidth, this.borderColor);
    this.drawNode.drawSegment(cc.pSub(cc.p(size.width, size.height), anchorPointPosition), cc.pSub(cc.p(0, size.height), anchorPointPosition), this.borderWidth, this.borderColor);
    this.drawNode.drawSegment(cc.pSub(cc.p(0, size.height), anchorPointPosition), cc.pSub(cc.p(0, 0), anchorPointPosition), this.borderWidth, this.borderColor);

    this.drawNode.drawDot(anchorPoint, this.anchorPointRadius, this.anchorPointColor);
  },

  // update (dt) {

  // },
});
