
export pwd=`pwd`

docker run -it --link mongo_server:mongo --rm -v $pwd:/tmp -w /tmp mongo mongo --host mongo Loc8r initDb.js
