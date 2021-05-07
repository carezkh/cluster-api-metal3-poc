docker_ce="docker-ce-20.10.6"
docker_ce_cli="docker-ce-cli-20.10.6"
containerd="containerd.io-1.4.4"
kubelet="kubelet-1.21.0"
kubeadm="kubeadm-1.21.0"
kubectl="kubectl-1.21.0"

echo "#install cloud-init"
sudo sh -xc "while ! yum install -y cloud-init ; do sleep 1 ; done ; echo succeed"

echo "#importing modules overlay, br_netfilter"
sudo mv /tmp/containerd.conf /etc/modules-load.d/containerd.conf
sudo modprobe overlay
sudo modprobe br_netfilter

echo "#setting sysctl params"
sudo mv /tmp/99-kubernetes-cri.conf /etc/sysctl.d/99-kubernetes-cri.conf
sudo sysctl --system

echo "#install containerd, docker-ce, docker-ce-cli"
sudo sh -xc "while ! yum install -y yum-utils ; do sleep 1 ; done ; echo succeed"
sudo sh -xc " while ! yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo ; do sleep 1 ; done ; echo succeed"
sudo sh -xc "while ! yum install -y ${docker_ce} ${docker_ce_cli} ${containerd} ; do sleep 1 ; done ; echo succeed"

echo "#set conatinerd cgroups driver"
sudo sh -c "containerd config default > /etc/containerd/config.toml"
sudo sed -i '/runc.options]/aSystemdCgroup = true' /etc/containerd/config.toml

echo "#enable containerd, docker"
sudo systemctl enable --now docker containerd

echo "#add kubernetes yum repo"
sudo mv /tmp/kubernetes.repo /etc/yum.repos.d/kubernetes.repo

echo "#set selinux permissive"
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

echo "#install kubelet, kubeadm, kubectl"
sudo sh -xc "while ! yum install -y ${kubelet} ${kubeadm} ${kubectl} --disableexcludes=kubernetes ; do sleep 1 ; done ; echo succeed"

echo "#enable kubelet"
sudo systemctl enable --now kubelet

#echo "#disable swap"
#sudo sed -i '/swap/{s/^/#/}' /etc/fstab
#sudo swapoff -a
#sudo lvremove -f /dev/centos/swap

echo "#pull kubernetes images"
sudo kubeadm config images pull

echo "#clean yum cache"
sudo yum -y clean all
