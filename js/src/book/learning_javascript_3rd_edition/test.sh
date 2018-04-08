
#!/bin/bash

#mocha --check-leaks --use_strict `dirname $0`/**/*.js
mocha --check-leaks `dirname $0`/**/*.js
