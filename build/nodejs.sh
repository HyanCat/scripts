#!/bin/sh

DEST_DIR=$1
if [ ! $DEST_DIR ]; then
	DEST_DIR=/usr/local/soft
fi


NODE_LINK=http://nodejs.org/dist/v0.12.4/node-v0.12.4.tar.gz

###################################################
# NODEJS

wget $NODE_LINK
tar -zxf node-v0.12.4.tar.gz
cd node-v0.12.4
./configure --prefix=$DEST_DIR/nodejs
make
make install
cd -
echo "PATH=\$PATH:$DEST_DIR/nodejs/bin" >> ~/.bashrc
