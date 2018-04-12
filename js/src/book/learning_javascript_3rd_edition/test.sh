
#!/bin/bash

#mocha --check-leaks --use_strict `dirname $0`/**/*.js

jshint `dirname $0`

if [ $? -ne 0 ]; then
    echo "JSHint check error"
    exit $?
fi

mocha --check-leaks `dirname $0`/**/*.js
