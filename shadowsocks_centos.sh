#!/bin/sh

# centos

yum install python-setuptools && easy_install pip
pip install shadowsocks


IP=`wget -q -O - http://api.ipify.org`

PASS=`openssl rand 6 -base64`
if [ "$1" != "" ]
then PASS=$1
fi


cat >/etc/shadowsocks.json <<END
{
    "server":"$IP",
    "server_port":9388,
    "local_address": "127.0.0.1",
    "local_port":1080,
    "password":"$PASS",
    "timeout":300,
    "method":"aes-256-cfb",
    "fast_open": false
}
END

nohup ssserver -c /etc/shadowsocks.json &