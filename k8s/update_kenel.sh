###
 # @Descripttion: 更新centos7内核至4.5以上，
 # @version: 1.0
 # @Author: cuiyonggan
 # @Date: 2022-10-25 14:39:43
 # @LastEditors: Please set LastEditors
 # @LastEditTime: 2022-10-26 13:33:56
### 
# 添加yum源仓库
# 保留旧版本centos yum源
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup 
# 下载并添加阿里云镜像源作为centos默认源
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo 
# 下载并添加EPEL第三方源
curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
# 导入公钥
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
# 安装elrepo(一个RPM)存储库
yum install -y https://www.elrepo.org/elrepo-release-7.0-4.el7.elrepo.noarch.rpm
# 更新yum源仓库
yum -y update
#查看可用的系统内核包
yum --disablerepo="*" --enablerepo="elrepo-kernel" list available

#安装ml版内核
yum --enablerepo=elrepo-kernel install kernel-ml -y 
#查看目前可用内核
awk -F\' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg
#使用序号为0的内核，序号0是前面查出来的可用内核编号
grub2-set-default 0

#生成 grub 配置文件并重启
grub2-mkconfig -o /boot/grub2/grub.cfg
reboot