
OpenResty
=========

Components
----------

### lua-resty-cjson

* Infinity and Nan is not allowed in JSON specification
* Sparse array is always encoded as json array
* Excessively sparse array encoding can be enabled/disabled
* reference
  * [json](http://www.json.org/)
  * [cjson](https://www.kyne.com.au/~mark/software/lua-cjson-manual.html)
  * [lua-resty-cjson](https://github.com/openresty/lua-cjson)

[Test::Nginx](https://metacpan.org/pod/Test::Nginx)的安装
--------------------------------------------------------

### dependency

```bash
yum install -y which cpan make gcc
```

### install

```bash
cpan -f -i Test::Nginx
```

[lua-resty-moongoo](https://github.com/isage/lua-resty-moongoo)的安装
--------------------------------------------------------------------

### dependency

* cmake
  ```bash
  yum install -y gcc-c++
  curl -fSL https://cmake.org/files/v3.12/cmake-3.12.0.tar.gz -o cmake-3.12.0.tar.gz
  tar xvzf cmake-3.12.0.tar.gz
  ./bootstrap --prefix=/usr -- -DCMAKE_BUILD_TYPE:STRING=Release
  ```

* libbson
  ```bash
  curl -fSL https://github.com/mongodb/mongo-c-driver/releases/download/1.11.0/mongo-c-driver-1.11.0.tar.gz -o mongo-c-driver-1.11.0.tar.gz
  tar xvzf mongo-c-driver-1.11.0.tar.gz
  cd mongo-c-driver-1.11.0
  mkdir cmake-build
  cd cmake-build
  cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local/openresty/bson -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF -DCMAKE_BUILD_TYPE=Release -DENABLE_BSON=ONLY ..
  make install
  ```

### install

```bash
curl -fSL https://github.com/isage/lua-cbson/archive/master.zip -o lua-cbson.zip
unzip lua-cbson.zip -d .
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local/openresty/lualib -DLIBBSON_INCLUDE_DIR:PATH=/usr/local/openresty/bson/include/libbson-1.0 -DLIBBSON_LIBRARY:FILEPATH=/usr/local/openresty/bson/lib64/libbson-1.0.so ..
```

### 参考

* >[cpan源](http://www.361way.com/change-cpan-default-mirror/5094.html)
* >[cmake安装](https://cmake.org/install/)
* >http://mongoc.org/libmongoc/current/installing.html
