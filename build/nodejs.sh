#!/bin/sh

DEST_DIR=$1
if [ ! $DEST_DIR ]; then
	DEST_DIR=/usr/local/soft
fi

NODE_VERSION=v0.12.7
NODE_LINK=http://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION.tar.gz

###################################################
# NODEJS

wget $NODE_LINK
tar -zxf node-$NODE_VERSION.tar.gz
cd node-$NODE_VERSION
./configure --prefix=$DEST_DIR/nodejs
make
make install
cd -
echo "PATH=\$PATH:$DEST_DIR/nodejs/bin" >> ~/.bashrc
