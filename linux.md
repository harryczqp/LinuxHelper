# Linux笔记
**好记性 也要做笔记**
## SSH密钥创建

* *1创建用户组以及用户*
* *2用户密钥创建*
* *Tips sudo权限开启*
---

 ``` 
 groupadd user
 mkdir -p /home/user
 useradd admin -g user -d /home/user/admin
 ```

---

 ``` 
 su admin
 cd ~
 ssh-keygen -t rsa
 cd ~/.ssh
 mv id_rsa.pub authorized_keys
 chmod 700 ../.ssh/
 chmod 644 authorized_keys
 ```
---
 ``` 
 chmod u+w /etc/sudoers
 vi /etc/sudoers
 
 vi /etc/ssh/sshd_conf
 # PasswordAuthentication no
 # ssh-keygen -R "你的远程服务器ip地址" 
 service sshd restart

 ```
** 注：这里说下你可以sudoers添加下面四行中任意一条

|--|--|--|备注|
|--|--|--|--|
youuser|ALL=(ALL)|ALL|允许用户youuser执行sudo命令(需要输入密码)
%youuser|ALL=(ALL)|ALL | 允许用户组youuser的用户执行sudo命令(需要输入密码)；
youuser|ALL=(ALL)|OPASSWD: ALL|允许用户youuser执行sudo命令，在执行的时候不输入密码；
%youuser|ALL=(ALL)|NOPASSWD: ALL|允许用户组youuser里面的用户执行sudo命令，在执行的时候不输入密码。

---






## centos7 内核升级，开启 bbr+fastopen

内核升级
```
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
yum install -y https://www.elrepo.org/elrepo-release-7.0-4.el7.elrepo.noarch.rpm
yum --enablerepo=elrepo-kernel install kernel-ml -y
```

内核手动下载
```
https://elrepo.org/linux/kernel/el7/x86_64/RPMS/
```

内核选择
```
cat /boot/grub2/grub.cfg |grep menuentry # 查看所有内核

# 默认使用新内核
sed -i 's/GRUB_DEFAULT=.*/GRUB_DEFAULT=0/g' /etc/default/grub

# 查看可使用的内核列表
awk -F\' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg
# 查看当前默认内核启动项
grub2-editenv list
# 更改默认启动内核项
grub2-set-default 0
# 内核重配置
grub2-mkconfig -o /boot/grub2/grub.cfg
# 重启
reboot
```

系统维护
```
uname -r #查看当前内核
grub2-editenv list #查看内核修改结果
yum remove kernel -y #使用yum remove 或rpm -e 删除无用内核
rpm -qa |grep kernel #查看系统安装了哪些内核包
```

内核header维护
```
yum remove -y kernel-tools-libs
yum --disablerepo="*" --enablerepo="elrepo-kernel" list available #列出可用
yum --enablerepo=elrepo-kernel install -y kernel-ml-headers kernel-ml-tools kernel-ml-devel #安装对应headers
yum --enablerepo=elrepo-kernel install -y perf python-perf
```


开启 bbr
```
vi /etc/sysctl.conf
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
```

编译并开启 bbr plus TODO
```
yum install -y make gcc
mkdir -p /opt/bbrplus && cd /opt/bbrplus

wget -N --no-check-certificate http://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/bbr/tcp_tsunami.c
echo "obj-m:=tcp_tsunami.o" > Makefile

make -C /lib/modules/$(uname -r)/build M=`pwd` modules CC=/usr/bin/gcc

chmod +x ./tcp_tsunami.ko
cp -rf ./tcp_tsunami.ko /lib/modules/$(uname -r)/kernel/net/ipv4
insmod tcp_tsunami.ko
depmod -a
```

开启 tcp fastopen
```
vi /etc/sysctl.conf
net.ipv4.tcp_fastopen = 3
```

其他参数
```
net.ipv4.ip_forward = 1
net.ipv4.ip_no_pmtu_disc = 1

vm.swappiness = 0
net.ipv4.neigh.default.gc_stale_time = 120

net.ipv4.conf.all.rp_filter = 0
net.ipv4.conf.default.rp_filter = 0
net.ipv4.conf.default.arp_announce = 2
net.ipv4.conf.lo.arp_announce = 2
net.ipv4.conf.all.arp_announce = 2

net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 1024
net.ipv4.tcp_synack_retries = 2

kernel.sysrq = 1
```

```
sysctl -p
```

mysql

```sql
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '123456';



use mysql;
select host from user where user='root';
update user set host = '%' where user ='root';
flush privileges;
```

docker加速

```shell
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://u1japnns.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

docker

```shell
docker run -d -p 9000:9000 \
--restart=always \
-v /var/run/docker.sock:/var/run/docker.sock \
--name portainer \
docker.io/portainer/portainer

firewall-cmd --permanent --zone=public --add-port=9000/tcp  
firewall-cmd --reload
```

不会断连

```shell
vi /etc/ssh/sshd_config
ClientAliveInterval 60
LoginGraceTime 0
TCPKeepAlive yes

```

centos8 docker 安装

```shell
sudo yum install -y yum-utils

## 配置阿里yum源
sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

yum install https://download.docker.com/linux/fedora/30/x86_64/stable/Packages/containerd.io-1.2.6-3.3.fc30.x86_64.rpm
```

