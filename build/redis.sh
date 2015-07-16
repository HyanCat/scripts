#!/bin/sh

DEST_DIR=$1
if [ ! $DEST_DIR ]; then
	DEST_DIR=/usr/local/soft
fi

REDIS_LINK=http://download.redis.io/redis-stable.tar.gz

###################################################
# REDIS

wget $REDIS_LINK
tar -zxf redis-stable.tar.gz
cd ./redis-stable
make
cd -
mv redis-stable $DEST_DIR/redis
echo "PATH=\$PATH:$DEST_DIR/redis/src" >> ~/.bashrc