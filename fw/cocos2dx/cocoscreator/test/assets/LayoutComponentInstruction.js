// Learn cc.Class:
//  - [Chinese] http://docs.cocos.com/creator/manual/zh/scripting/class.html
//  - [English] http://www.cocos2d-x.org/docs/creator/en/scripting/class.html
// Learn Attribute:
//  - [Chinese] http://docs.cocos.com/creator/manual/zh/scripting/reference/attributes.html
//  - [English] http://www.cocos2d-x.org/docs/creator/en/scripting/reference/attributes.html
// Learn life-cycle callbacks:
//  - [Chinese] http://docs.cocos.com/creator/manual/zh/scripting/life-cycle-callbacks.html
//  - [English] http://www.cocos2d-x.org/docs/creator/en/scripting/life-cycle-callbacks.html

// 1. cc.Widget does not rearrange layout if its owner's size were changed.
// 2. If Resize Mode is CONTAINER, children were added after node content size was updated and the node's
//    anchor point and position were not changed.

cc.Class({
  extends: cc.Component,

  properties: {
    horizontalLayout: cc.Node,
    verticalLayout: cc.Node,

    template1: cc.Node,
    template2: cc.Node
  },

  // LIFE-CYCLE CALLBACKS:

  // onLoad () {},

  start: function() {
    for (var i=0; i<10; i++) {
      var button = cc.instantiate(this.template1);
      button.active = true;
      this.verticalLayout.addChild(button);

      var labelComponent = button.getComponentInChildren(cc.Label);
      labelComponent.string = "Item " + (i+1);
    }

    var self = this;
    this.verticalLayout.on('size-changed', function(event) {
      // CocosCreate-->Bug: cc.Widget does not rearrange layout if node size were changed.
      // Make a workaround to solve this issue. How about remove cc.Widget firstly, and then add it back again?
      var widgetComponent = self.verticalLayout.addComponent(cc.Widget);
      widgetComponent.isAlignTop = true;
      widgetComponent.isAlignLeft = true;
      widgetComponent.top = 0;
      widgetComponent.left = 0;
    });

    for (var i=0; i<10; i++) {
      var button = cc.instantiate(this.template2);
      button.active = true;
      this.horizontalLayout.addChild(button);

      var labelComponent = button.getComponentInChildren(cc.Label);
      labelComponent.string = i+1;
    }
  }

  // update (dt) {},
});
