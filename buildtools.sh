#!/bin/sh


yum update -y
yum install -y gcc gcc-c++

###################################################

NGINX_LINK=http://nginx.org/download/nginx-1.8.0.tar.gz
ZLIB_LINK=http://zlib.net/zlib-1.2.8.tar.gz
PHP_LINK=http://cn2.php.net/distributions/php-5.6.10.tar.gz
MYSQL_LINK=http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.25.tar.gz
REDIS_LINK=http://download.redis.io/redis-stable.tar.gz
MEMCACHED_LINK=http://www.memcached.org/files/memcached-1.4.24.tar.gz
NODE_LINK=http://nodejs.org/dist/v0.12.4/node-v0.12.4.tar.gz


DEST_DIR=/usr/local/soft

mkdir source_code
cd source_code


###################################################
# NGINX
wget $NGINX_LINK
wget $ZLIB_LINK

tar -zxf nginx-1.8.0.tar.gz
tar -zxf zlib-1.2.8.tar.gz

mv zlib-1.2.8 zlib

cd nginx-1.8.0
yum install -y openssl-devel pcre-devel
./configure --prefix=$DEST_DIR/nginx --with-http_ssl_module --with-pcre --with-zlib=../zlib
make
make install
cd -
#===================== config =====================
cd $DEST_DIR/nginx/conf
mkdir conf.d
cat > nginx.conf <<END

#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;

events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;
    client_max_body_size 10M;

    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';

    access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  60;

    gzip  on;


    include $DEST_DIR/nginx/conf/conf.d/*.conf;

}


END

cd -

echo "PATH=\$PATH:$DEST_DIR/nginx/sbin" >> ~/.bash_profile

###################################################
# PHP
wget $PHP_LINK
tar -zxf php-5.6.10.tar.gz

cd php-5.6.10

rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm

yum install -y libxml2-devel bzip2-devel libcurl-devel libpng-devel freetype-devel libc-client-devel libjpeg-devel libmcrypt-devel
ln -s /usr/lib64/libc-client.so /usr/lib/

./configure --prefix=$DEST_DIR/php --with-config-file-path=$DEST_DIR/php/etc --enable-fpm --with-mcrypt --with-zlib --enable-mbstring --with-openssl --with-mysql --with-mysqli --with-mysql-sock --with-gd --with-jpeg-dir --enable-gd-native-ttf --enable-pdo --with-pdo-mysql --with-gettext --with-curl --with-pdo-mysql --enable-sockets --enable-bcmath --enable-xml --with-bz2 --enable-zip --with-freetype-dir --with-imap --with-imap-ssl --with-kerberos
make
make install
cd -

cd $DEST_DIR/php/etc
cp php-fpm.conf.default php-fpm.conf
cd -

echo "PATH=\$PATH:$DEST_DIR/php/bin:$DEST_DIR/php/sbin" >> ~/.bash_profile

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

echo "PATH=\$PATH:$DEST_DIR/mysql/bin" >> ~/.bash_profile


###################################################
# REDIS

wget $REDIS_LINK
tar -zxf redis-stable.tar.gz
cd ./redis-stable
make
cd -
mv redis-stable $DEST_DIR/redis
echo "PATH=\$PATH:$DEST_DIR/redis/src" >> ~/.bash_profile


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
echo "PATH=\$PATH:$DEST_DIR/memcached/bin" >> ~/.bash_profile
# memcached -d -m 256 -u root -l 127.0.0.1 -p 12345 -c 1024 -P /tmp/memcached.pid

###################################################
# NODEJS

wget $NODE_LINK
tar -zxf node-v0.12.4.tar.gz
cd node-v0.12.4
./configure --prefix=$DEST_DIR/nodejs
make
make install
cd -
echo "PATH=\$PATH:$DEST_DIR/nodejs/bin" >> ~/.bash_profile


echo "export PATH" >> ~/.bash_profile
source ~/.bash_profile


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


echo "all done!"