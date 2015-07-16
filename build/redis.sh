#!/bin/sh

DEST_DIR=$1
if [ ! $DEST_DIR ]; then
	DEST_DIR=/usr/local/soft
fi

REDIS_VERSION=stable
REDIS_LINK=http://download.redis.io/redis-$REDIS_VERSION.tar.gz

###################################################
# REDIS

wget $REDIS_LINK
tar -zxf redis-$REDIS_VERSION.tar.gz
cd ./redis-$REDIS_VERSION
make
cd -
mv redis-$REDIS_VERSION $DEST_DIR/redis
echo "PATH=\$PATH:$DEST_DIR/redis/src" >> ~/.bashrc