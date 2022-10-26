###
 # @Descripttion: 安装k8s master，需要calico.yaml
 # @version: 
 # @Author: cuiyonggan
 # @Date: 2022-10-26 13:41:43
 # @LastEditors: Please set LastEditors
 # @LastEditTime: 2022-10-26 14:42:20
### 
# 安装k8s
kubeadm config images list --kubernetes-version=v1.25.0
kubeadm init --apiserver-advertise-address=192.168.150.101 --image-repository registry.aliyuncs.com/google_containers --kubernetes-version v1.25.0 --service-cidr=10.96.0.0/12 --pod-network-cidr=10.244.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 部署网络插件 calico
# 修改了CALICO_IPV4POOL_CIDR
kubectl apply -f calico.yaml

# 部署dashboard
