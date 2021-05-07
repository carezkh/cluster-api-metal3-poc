export IRONIC_URL="http://192.168.122.1:6385/v1/"
export IRONIC_NO_CA_CERT=true
export IRONIC_USERNAME="admin"
export IRONIC_PASSWORD="eaHYzRzhuopJ-0PFhxsk"
export IRONIC_INSPECTOR_URL="http://192.168.122.1:5050/v1/"
export IRONIC_INSPECTOR_USERNAME="admin"
export IRONIC_INSPECTOR_PASSWORD="eaHYzRzhuopJ-0PFhxsk"
export DEPLOY_KERNEL_URL="http://192.168.122.1:8080/ipa.kernel" 
export DEPLOY_RAMDISK_URL="http://192.168.122.1:8080/ipa.initramfs"
export IMAGE_URL="http://192.168.122.1:8080/centos7.qcow2"
export IMAGE_CHECKSUM="http://192.168.122.1:8080/centos7.qcow2.CHECKSUMS"
export IMAGE_CHECKSUM_TYPE="md5"
export IMAGE_FORMAT="qcow2"

export POD_CIDR="192.168.0.0/24"
export SERVICE_CIDR="10.96.0.0/12"
export API_ENDPOINT_HOST="192.168.122.2"
export API_ENDPOINT_PORT="6443"
export KUBERNETES_VERSION="v1.21.0"
kubelet="kubelet-${KUBERNETES_VERSION#*v}-0.x86_64"
kubeadm="kubeadm-${KUBERNETES_VERSION#*v}-0.x86_64"
kubectl="kubectl-${KUBERNETES_VERSION#*v}-0.x86_64"
docker_ce="docker-ce-20.10.6"
docker_ce_cli="docker-ce-cli-20.10.6"
containerd="containerd.io-1.4.4"
export CTLPLANE_KUBEADM_EXTRA_CONFIG="
    users:
    - name: metal3
      lockPassword: false
      sudo: 'ALL=(ALL) NOPASSWD:ALL'
      sshAuthorizedKeys:
      - `cat ~/.ssh/id_rsa.pub`
    preKubeadmCommands:
      - sudo sh -xc \"while ! yum install -y yum-utils ; do sleep 1 ; done ; echo succeed\"
      - sudo sh -xc \" while ! yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo ; do sleep 1 ; done ; echo succeed\"
      - sudo sh -xc \"while ! yum install -y ${docker_ce} ${docker_ce_cli} ${containerd} ; do sleep 1 ; done ; echo succeed\"
      - sudo sh -c \"containerd config default > /etc/containerd/config.toml\"
      - sudo sed -i '/runc.options]/aSystemdCgroup = true' /etc/containerd/config.toml
      - sudo systemctl enable --now docker containerd
      - sudo setenforce 0
      - sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
      - sudo sh -xc \"while ! yum install -y ${kubelet} ${kubeadm} ${kubectl} --disableexcludes=kubernetes ; do sleep 1 ; done ; echo succeed\"
      - sudo systemctl enable --now kubelet
    files:
      - path: /etc/modules-load.d/k8s.conf
        content: |
          overlay
          br_netfilter
      - path: /etc/sysctl.d/k8s.conf
        content: |
          net.ipv4.ip_forward                 = 1
          net.bridge.bridge-nf-call-iptables  = 1
          net.bridge.bridge-nf-call-ip6tables = 1
      - path: /etc/yum.repos.d/kubernetes.repo
        content: |
          [kubernetes]
          name=Kubernetes
          baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
          enabled=1
          gpgcheck=1
          repo_gpgcheck=1
          gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
          exclude=kubelet kubeadm kubectl
"
export WORKERS_KUBEADM_EXTRA_CONFIG="
    users:
    - name: metal3
      lockPassword: false
      sudo: 'ALL=(ALL) NOPASSWD:ALL'
      sshAuthorizedKeys:
      - `cat ~/.ssh/id_rsa.pub`
    preKubeadmCommands:
      - sudo sh -xc \"while ! yum install -y yum-utils ; do sleep 1 ; done ; echo succeed\"
      - sudo sh -xc \" while ! yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo ; do sleep 1 ; done ; echo succeed\"
      - sudo sh -xc \"while ! yum install -y ${docker_ce} ${docker_ce_cli} ${containerd} ; do sleep 1 ; done ; echo succeed\"
      - sudo sh -c \"containerd config default > /etc/containerd/config.toml\"
      - sudo sed -i '/runc.options]/aSystemdCgroup = true' /etc/containerd/config.toml
      - sudo systemctl enable --now docker containerd
      - sudo setenforce 0
      - sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
      - sudo sh -xc \"while ! yum install -y ${kubelet} ${kubeadm} ${kubectl} --disableexcludes=kubernetes ; do sleep 1 ; done ; echo succeed\"
      - sudo systemctl enable --now kubelet
    files:
      - path: /etc/modules-load.d/k8s.conf
        content: |
          overlay
          br_netfilter
      - path: /etc/sysctl.d/k8s.conf
        content: |
          net.ipv4.ip_forward                 = 1
          net.bridge.bridge-nf-call-iptables  = 1
          net.bridge.bridge-nf-call-ip6tables = 1
      - path: /etc/yum.repos.d/kubernetes.repo
        content: |
          [kubernetes]
          name=Kubernetes
          baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
          enabled=1
          gpgcheck=1
          repo_gpgcheck=1
          gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
          exclude=kubelet kubeadm kubectl
"
