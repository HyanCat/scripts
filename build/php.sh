#!/bin/sh

DEST_DIR=$1
if [ ! $DEST_DIR ]; then
	DEST_DIR=/usr/local/soft
fi

PHP_VERSION=7.1.3
PHP_LINK=http://cn2.php.net/distributions/php-$PHP_VERSION.tar.gz


###################################################
# PHP

wget $PHP_LINK
tar -zxf php-$PHP_VERSION.tar.gz

cd php-$PHP_VERSION

rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm

yum install -y libxml2-devel bzip2-devel libcurl-devel libpng-devel freetype-devel libc-client-devel libjpeg-devel libmcrypt-devel openssl-devel
ln -s /usr/lib64/libc-client.so /usr/lib/

./configure --prefix=$DEST_DIR/php --with-config-file-path=$DEST_DIR/php/etc --enable-fpm --with-mcrypt --with-zlib --enable-mbstring --with-openssl --with-mysqli --with-mysql-sock --with-gd --with-jpeg-dir --enable-gd-native-ttf --enable-pdo --with-pdo-mysql --with-gettext --with-curl --with-pdo-mysql --enable-sockets --enable-bcmath --enable-xml --with-bz2 --enable-zip --with-freetype-dir --with-imap --with-imap-ssl --with-kerberos --enable-opcache
make
make install
cd -

cd $DEST_DIR/php/etc
cp php-fpm.conf.default php-fpm.conf
cd -

echo "PATH=\$PATH:$DEST_DIR/php/bin:$DEST_DIR/php/sbin" >> ~/.bashrc
