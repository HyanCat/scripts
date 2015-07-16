#!/bin/sh

DEST_DIR=$1
if [ ! $DEST_DIR ]; then
	DEST_DIR=/usr/local/soft
fi


MEMCACHED_LINK=http://www.memcached.org/files/memcached-1.4.24.tar.gz

###################################################
# MEMCACHED

wget $MEMCACHED_LINK
tar -zxf memcached-1.4.24.tar.gz
cd ./memcached-1.4.24
yum install -y libevent-devel
./configure --prefix=$DEST_DIR/memcached
make
make install
cd -
echo "PATH=\$PATH:$DEST_DIR/memcached/bin" >> ~/.bashrc
# memcached -d -m 256 -u root -l 127.0.0.1 -p 12345 -c 1024 -P /tmp/memcached.pid

