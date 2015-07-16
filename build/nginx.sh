#!/bin/sh

DEST_DIR=$1
if [ ! $DEST_DIR ]; then
	DEST_DIR=/usr/local/soft
fi


NGINX_LINK=http://nginx.org/download/nginx-1.8.0.tar.gz
ZLIB_LINK=http://zlib.net/zlib-1.2.8.tar.gz

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

echo "PATH=\$PATH:$DEST_DIR/nginx/sbin" >> ~/.bashrc