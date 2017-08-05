#!/bin/sh

DEST_DIR=$1
if [ ! $DEST_DIR ]; then
	DEST_DIR=/usr/local/soft
fi

mkdir -p $DEST_DIR

NODE_VERSION=v8.2.1
NODE_LINK=https://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION-linux-x64.tar.xz

###################################################
# NODEJS

wget $NODE_LINK
tar -xf node-$NODE_VERSION-linux-x64.tar.xz
mv node-$NODE_VERSION-linux-x64 $DEST_DIR/node

echo "PATH=\$PATH:$DEST_DIR/node/bin" >> ~/.bashrc
