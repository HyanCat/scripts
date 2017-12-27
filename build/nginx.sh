#!/bin/sh

DEST_DIR=$1
if [ ! $DEST_DIR ]; then
	DEST_DIR=/usr/local/soft
fi

NGINX_VERSION=1.13.8
ZLIB_VERSION=1.2.11
NGINX_LINK=http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz
ZLIB_LINK=http://zlib.net/zlib-$ZLIB_VERSION.tar.gz

###################################################
# NGINX

wget $NGINX_LINK
wget $ZLIB_LINK

tar -zxf nginx-$NGINX_VERSION.tar.gz
tar -zxf zlib-$ZLIB_VERSION.tar.gz

mv zlib-$ZLIB_VERSION zlib

cd nginx-$NGINX_VERSION
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

echo "PATH=\$PATH:$DEST_DIR/nginx/sbin" >> ~/.bashrc
