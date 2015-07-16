#!/bin/sh

###################################################
# PHP-EXTENSIONS

yum install -y autoconf

## memcached
yum install -y libmemcached-devel

PHP_MEMCACHED_VER=2.2.0
PHP_MEMCACHED=http://pecl.php.net/get/memcached-$PHP_MEMCACHED_VER.tgz
wget $PHP_MEMCACHED
tar -zxf memcached-$PHP_MEMCACHED_VER.tgz
cd ./memcached-$PHP_MEMCACHED_VER
phpize
./configure
make
make install
cd -

## imagick
yum install -y ImageMagick-devel

PHP_IMAGICK_VER=3.1.2
PHP_IMAGICK=http://pecl.php.net/get/imagick-$PHP_IMAGICK_VER.tgz
wget $PHP_IMAGICK
tar -zxf imagick-$PHP_IMAGICK_VER.tgz
cd ./imagick-$PHP_IMAGICK_VER
phpize
./configure
make
make install
cd -