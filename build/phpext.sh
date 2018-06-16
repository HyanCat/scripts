#!/bin/sh

###################################################
# PHP-EXTENSIONS
###################################################

## memcached
yum install -y libmemcached-devel

pecl install memcached

## imagick
yum install -y ImageMagick-devel

pecl install imagick

## mongodb
pecl install mongodb


wget http://www.imagemagick.org/download/ImageMagick.tar.gz
tar -zxf ImageMagick.tar.gz
