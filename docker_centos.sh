#!/bin/bash -e

yum remove docker docker-common docker-selinux docker-engine

yum update -y

## for docker-ce

yum install -y yum-utils device-mapper-persistent-data lvm2

yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

## tsinghua mirror
sed -i 's+download.docker.com+mirrors.tuna.tsinghua.edu.cn/docker-ce+' /etc/yum.repos.d/docker-ce.repo

yum makecache fast
yum install -y docker-ce

systemctl start docker

## install docker-compose

DC_VERSION=1.24.1

curl -L https://github.com/docker/compose/releases/download/$DC_VERSION/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

ln -s /usr/local/bin/docker-compose /usr/local/bin/dc
