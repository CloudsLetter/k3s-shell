#！/bin/bash
yum install wget -y
wget http://rancher-mirror.cnrancher.com/k3s/v1.18.2-k3s1/k3s -0 /usr/local/bin/k3s
chmod +x /usr/local/bin/k3s

systemctl enable k3s-agent
wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
yum install yum-utils epel-release -y
yum-config-manager --setopt=centosplus.includepkgs=kernel-plus --enablerepo=centosplus --save
sed -e 's/^DEFAULTKERNEL=kernel$/DEFAULTKERNEL=kernel-plus/' -i /etc/sysconfig/kernel
yum install kernel-plus wireguard-tools -y
reboot
