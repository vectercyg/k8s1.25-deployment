###
 # @Descripttion: 准备k8s集群相关软件，需要kubelet
 # @version: 
 # @Author: cuiyonggan
 # @Date: 2022-10-26 10:47:01
 # @LastEditors: Please set LastEditors
 # @LastEditTime: 2022-10-26 14:25:48
### 
#添加阿里云yum软件源
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
yum makecache
#安装 kubectl kubelet kubeadm
yum install -y kubectl kubelet kubeadm
systemctl enable --now kubelet
#为了实现docker使用的cgroupdriver与kubelet使用的cgroup的一致性
#修改了KUBELET_EXTRA_ARGS="--cgroup-driver=systemd"
mv kubelet /etc/sysconfig/kubelet -f
