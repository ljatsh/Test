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
    borderWidth: 1.0,
    ignoreScale: true
  },

  // LIFE-CYCLE CALLBACKS:

  // onLoad () {},

  start () {
    this.drawNode = new cc.DrawNode();
    this.node._sgNode.addChild(this.drawNode);

    this.draw();

    var self = this;

    // register several events
    // http://www.cocos2d-x.org/docs/creator/manual/en/scripting/internal-events.html?h=event
    this.node.on('size-changed', function(event) {
      self.draw();
      //console.log('size-changed');
    });
    this.node.on('anchor-changed', function(event) {
      self.draw();
      //console.log('anchor-changed');
    });
    this.node.on('scale-changed', function(event) {
      self.draw();
      //console.log('scale-changed');
    });
    this.node.on('rotation-changed', function(event) {
      self.draw();
      //console.log('rotation-changed');
    });
    this.node.on('position-changed', function(event) {
      self.draw();
      //console.log('position-changed');
    });
  },

  draw: function() {
    this.drawNode.clear();

    var size = this.node.getContentSize();
    var anchorPoint = this.node.getAnchorPoint();
    var anchorPointPosition = cc.p(size.width * anchorPoint.x, size.height * anchorPoint.y);

    var points = [cc.p(0, 0), cc.p(size.width, 0), cc.p(size.width, size.height), cc.p(0, size.height), cc.p(0, 0)];
    for (var i=0; i<4; i++) {
      var from = cc.pSub(points[i+1], anchorPointPosition);
      var to = cc.pSub(points[i], anchorPointPosition);

      this.drawNode.drawSegment(from, to, this.borderWidth, this.borderColor);
    }

    this.drawNode.drawDot(anchorPoint, this.anchorPointRadius, this.anchorPointColor);

    if (!this.ignoreScale) {
      this.drawNode.setScale(1/this.node.scaleX, 1/this.node.scaleY);
    }
  }

  // update (dt) {

  // },
});
