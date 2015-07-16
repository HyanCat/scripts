#!/bin/sh

yum update -y
yum install -y gcc gcc-c++

###################################################

DEST_DIR=/usr/local/soft

mkdir source_code
cd source_code

sh ../build/nginx.sh $DEST_DIR
sh ../build/php.sh $DEST_DIR
sh ../build/mysql.sh $DEST_DIR
sh ../build/memcached.sh $DEST_DIR
sh ../build/redis.sh $DEST_DIR
sh ../build/nodejs.sh $DEST_DIR

echo "export PATH" >> ~/.bashrc

source ~/.bashrc

sh ../build/phpext.sh

cd -

echo "all done!"