#!/bin/bash

# 在 master 节点和 worker 节点都要执行

# 安装 docker
# 参考文档如下
# https://docs.docker.com/install/linux/docker-ce/centos/ 
# https://docs.docker.com/install/linux/linux-postinstall/

# 卸载旧版本
yum remove -y docker \
docker-client \
docker-client-latest \
docker-common \
docker-latest \
docker-latest-logrotate \
docker-logrotate \
docker-selinux \
docker-engine-selinux \
docker-engine

# 设置 yum repository
yum install -y yum-utils \
device-mapper-persistent-data \
lvm2
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

# 安装并启动 docker
yum install -y docker-ce-18.09.7 docker-ce-cli-18.09.7 containerd.io
systemctl enable docker
systemctl start docker
# 设置镜像
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://u1japnns.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker

# 关闭 防火墙
# systemctl stop firewalld
# systemctl disable firewalld

# 安装 nfs-utils
# 必须先安装 nfs-utils 才能挂载 nfs 网络存储
yum install -y nfs-utils
yum install -y wget
# 安装 portainer
docker run -d -p 9000:9000 --restart=always -v /var/run/docker.sock:/var/run/docker.sock --name portainer docker.io/portainer/portainer

# 安装nginx
# mkdir -vp /root/nginx/conf.d
# mkdir -vp /root/nginx/html
# docker run -d --name nginx --net=host --restart=always -v /root/nginx/conf.d:/etc/nginx/conf.d -v /root/nginx/html:/etc/nginx/html -d nginx
# 安装nps
# mkdir -vp /root/nps/conf/

# docker run -d --name nps --net=host --restart=always -v /root/nps/conf:/conf ffdfgdfg/nps
# firewall-cmd --permanent --zone=public --add-port=9000-10000/tcp
# firewall-cmd --permanent --zone=public --add-port=9000-10000/udp
# firewall-cmd reload