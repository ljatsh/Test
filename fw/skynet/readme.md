SKYNET
======

* http请求，如果超时，则请求co还是会继续等待；这不是个优雅的处理方式
* http,dns出错的处理，比较粗暴，我更青睐返回值方式
* http的SSL支持，参考[这里](https://github.com/dpull/lua-webclient)
* skynet.exit()貌似会等待所有co结束才出来
* require对应接口luaL_requiref， 默认如果文件已经加载(package.loaded)，则直接返回；busted貌似加载一个新的测试文件，会把已经加载的文件清零，导致skynet多测试原件运行有错误