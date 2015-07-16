#!/bin/sh

DEST_DIR=$1
if [ ! $DEST_DIR ]; then
	DEST_DIR=/usr/local/soft
fi


MYSQL_LINK=http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.25.tar.gz


###################################################
# MYSQL

wget $MYSQL_LINK
tar -zxf mysql-5.6.25.tar.gz

cd mysql-5.6.25
yum install -y cmake ncurses-devel
yum install -y perl-Module-Install

cmake . -DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo -DCMAKE_INSTALL_PREFIX:PATH=$DEST_DIR/mysql -DCOMMUNITY_BUILD:BOOL=ON -DENABLED_PROFILING:BOOL=ON -DENABLE_DEBUG_SYNC:BOOL=OFF -DINSTALL_LAYOUT:STRING=STANDALONE -DMYSQL_DATADIR:PATH=$DEST_DIR/mysql/data -DMYSQL_MAINTAINER_MODE:BOOL=OFF -DWITH_EMBEDDED_SERVER:BOOL=ON -DWITH_EXTRA_CHARSETS:STRING=all -DWITH_SSL:STRING=bundled -DWITH_UNIT_TESTS:BOOL=OFF -DWITH_ZLIB:STRING=bundled -LH
make
make install
cd -

#===================== config =====================
groupadd mysql
useradd -r -g mysql mysql

mkdir /var/log/mariadb

cd $DEST_DIR/mysql
chown -R mysql:mysql .
scripts/mysql_install_db --user=mysql
chown -R root .
chown -R mysql:mysql data
echo "socket = /tmp/mysql.sock" >> my.cnf
#bin/mysqld_safe --user=mysql &
cp support-files/mysql.server /etc/init.d/mysql.server
service mysql.server start

cd -

echo "PATH=\$PATH:$DEST_DIR/mysql/bin" >> ~/.bashrc
