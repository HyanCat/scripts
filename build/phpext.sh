#!/bin/sh

###################################################
# PHP-EXTENSIONS

yum install -y autoconf

## memcached
yum install -y libmemcached-devel

PHP_MEMCACHED=http://pecl.php.net/get/memcached-2.2.0.tgz
wget $PHP_MEMCACHED
tar -zxf memcached-2.2.0.tgz
cd ./memcached-2.2.0
phpize
./configure
make
make install
cd -

## imagick
yum install -y ImageMagick-devel

PHP_IMAGICK=http://pecl.php.net/get/imagick-3.1.2.tgz
wget $PHP_IMAGICK
tar -zxf imagick-3.1.2.tgz
cd ./imagick-3.1.2
phpize
./configure
make
make install
cd -