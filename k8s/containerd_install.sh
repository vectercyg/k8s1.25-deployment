###
 # @Descripttion: 安装containerd 运行时，为k8s集群提供网路环境，需要 containerd-1.6.8-linux-amd64.tar.gz、containerd.service、runc.amd64、config.toml
 # @version: 
 # @Author: cuiyonggan
 # @Date: 2022-10-25 16:39:33
 # @LastEditors: Please set LastEditors
 # @LastEditTime: 2022-10-26 13:37:25
### 
#创建 /etc/modules-load.d/containerd.conf 配置文件:
cat << EOF > /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF
modprobe overlay
modprobe br_netfilter
# 安装containerd
tar Cxzvf /usr/local containerd-1.6.8-linux-amd64.tar.gz

mkdir -p /usr/local/lib/systemd
mkdir -p /usr/local/lib/systemd/system/
cp ./containerd.service /usr/local/lib/systemd/system/
sudo sysctl --system
systemctl daemon-reload
systemctl enable containerd --now
systemctl restart containerd
#安装runc
install -m 755 runc.amd64 /usr/local/sbin/runc

# 编辑containerd配置文件
#SystemdCgroup = false 改为 SystemdCgroup = true
# sandbox_image = "k8s.gcr.io/pause:3.6"改为：sandbox_image = "registry.aliyuncs.com/google_containers/pause:3.6"
mkdir -p /etc/containerd
cp ./config.toml /etc/containerd/config.toml

systemctl enable containerd
systemctl start containerd
