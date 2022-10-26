###
 # @Descripttion: 配置k8s的前置环境，需要 id_rsa.pub 文件、ifcfg-ens33 文件
 # @version: 
 # @Author: cuiyonggan
 # @Date: 2022-10-25 15:18:08
 # @LastEditors: Please set LastEditors
 # @LastEditTime: 2022-10-26 14:44:02
### 
# 设置免密登录
cat id_rsa.pub >> ~/.ssh/authorized_keys 
# 安装系统依赖包
yum install -y conntrack ntpdate ntp ipvsadm ipset jq iptables curl sysstat libseccomp wget vim net-tools git
# 修改hosts
cat >> /etc/hosts << EOF
192.168.150.101 k8s-master01
192.168.150.201 k8s-node01
192.168.150.202 k8s-node02
EOF
#保留进版本网络设置
mv /etc/sysconfig/network-scripts/ifcfg-ens33 /etc/sysconfig/network-scripts/ifcfg-ens33.bak
#写入新的网络配置
mv ~/ifcfg-ens33 /etc/sysconfig/network-scripts/ifcfg-ens33
#修改uid
uuidgen >> /etc/sysconfig/network-scripts/ifcfg-ens33
#重启网络
systemctl restart network
# 关闭防火墙
systemctl stop firewalld
systemctl disable firewalld
systemctl status firewalld
# 关闭selinux
sed -i 's/enforcing/disabled/' /etc/selinux/config # 永久
setenforce 0
# 关闭swap
swapoff -a  
sed -ri 's/.*swap.*/#&/' /etc/fstab
# 优化系统参数
cat > /etc/sysctl.d/k8s.conf << EOF
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-ip6tables=1
net.ipv4.ip_forward=1
# 禁用ipv6
net.ipv6.conf.all.disable_ipv6=1
net.netfilter.nf_conntrack_max=2310720
vm.swappiness=0
vm.overcommit_memory=1
vm.panic_on_oom=0
fs.inotify.max_user_instances=8192
fs.inotify.max_user_watches=1048576
fs.file-max=52706963
fs.nr_open=52706963
EOF
# 使系统参数配置生效
sysctl -p /etc/sysctl.d/k8s.conf
# 同步时间
ntpdate ntp1.aliyun.com
# 开启ipvs支持
cat > /etc/sysconfig/modules/ipvs.modules <<EOF
modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
modprobe -- nf_conntrack 
EOF
chmod 755 /etc/sysconfig/modules/ipvs.modules 
bash /etc/sysconfig/modules/ipvs.modules 
# 显示
lsmod | grep -e ip_vs -e nf_conntrack
systemctl restart network