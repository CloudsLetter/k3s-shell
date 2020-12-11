#！/bin/bash
yum install wget -y
wget http://rancher-mirror.cnrancher.com/k3s/v1.18.2-k3s1/k3s -0 /usr/local/bin/k3s
chmod +x /usr/local/bin/k3s

cat > /etc/systemd/system/k3s-agent.service <<EOF
[Unit]
Description=Lightweight Kubernetes
Documentation=https://k3s.io
Wants=network-online.target

[Install]
WantedBy=multi-user.target

[Service]
Type=exec
EnvironmentFile=/etc/systemd/system/k3s-agent.service.env
KillMode=process
Delegate=yes
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
TasksMax=infinity
TimeoutStartSec=0
Restart=always
RestartSec=5s
ExecStartPre=-/sbin/modprobe br_netfilter
ExecStartPre=-/sbin/modprobe overlay
ExecStart=/usr/local/bin/k3s agent \
    --node-external-ip $IP \
    --node-ip $IP \
    --kube-proxy-arg "proxy-mode=ipvs" "masquerade-all=true" \
    --kube-proxy-arg "metrics-bind-address=0.0.0.0"
EOF

cat > /etc/systemd/system/k3s-agent.service.env << EOF
K3S_URL=https://106.75.233.120:6443
K3S_TOKEN=K1003300dd8333b358f6bf5aa79d594ef8ea7870381b4405a80d2f57109e9ec8749::server:ee33c88b276bd394b3805c5ff2e47e31
EOF
systemctl enable k3s-agent
wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
yum install yum-utils epel-release -y
yum-config-manager --setopt=centosplus.includepkgs=kernel-plus --enablerepo=centosplus --save
sed -e 's/^DEFAULTKERNEL=kernel$/DEFAULTKERNEL=kernel-plus/' -i /etc/sysconfig/kernel
yum install kernel-plus wireguard-tools -y
reboot
