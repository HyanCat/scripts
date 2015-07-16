#!/bin/sh

DEST_DIR=$1
if [ ! $DEST_DIR ]; then
	DEST_DIR=/usr/local/soft
fi

MEMCACHED_VERSION=1.4.24
MEMCACHED_LINK=http://www.memcached.org/files/memcached-$MEMCACHED_VERSION.tar.gz

###################################################
# MEMCACHED

wget $MEMCACHED_LINK
tar -zxf memcached-$MEMCACHED_VERSION.tar.gz
cd ./memcached-$MEMCACHED_VERSION
yum install -y libevent-devel
./configure --prefix=$DEST_DIR/memcached
make
make install
cd -
echo "PATH=\$PATH:$DEST_DIR/memcached/bin" >> ~/.bashrc
# memcached -d -m 256 -u root -l 127.0.0.1 -p 12345 -c 1024 -P /tmp/memcached.pid

