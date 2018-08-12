SKYNET
------

* http请求，如果超时，则请求co还是会继续等待；这不是个优雅的处理方式
* http,dns出错的处理，比较粗暴，我更青睐返回值方式
* http的SSL支持，参考[这里](https://github.com/dpull/lua-webclient)
* skynet.exit()貌似会等待所有co结束才出来