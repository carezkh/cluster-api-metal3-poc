export IRONIC_URL="http://192.168.122.1:6385/v1/"
export IRONIC_NO_CA_CERT=true
export IRONIC_USERNAME="admin"
export IRONIC_PASSWORD="eaHYzRzhuopJ-0PFhxsk"
export IRONIC_INSPECTOR_URL="http://192.168.122.1:5050/v1/"
export IRONIC_INSPECTOR_USERNAME="admin"
export IRONIC_INSPECTOR_PASSWORD="eaHYzRzhuopJ-0PFhxsk"
export DEPLOY_KERNEL_URL="http://192.168.122.1:8080/ipa.kernel" 
export DEPLOY_RAMDISK_URL="http://192.168.122.1:8080/ipa.initramfs"
export IMAGE_URL="http://192.168.122.1:8080/centos7-offline.qcow2"
export IMAGE_CHECKSUM="http://192.168.122.1:8080/centos7-offline.qcow2.CHECKSUMS"
export IMAGE_CHECKSUM_TYPE="md5"
export IMAGE_FORMAT="qcow2"

export POD_CIDR="192.168.0.0/24"
export SERVICE_CIDR="10.96.0.0/12"
export API_ENDPOINT_HOST="192.168.122.2"
export API_ENDPOINT_PORT="6443"
export KUBERNETES_VERSION="v1.21.0"
export CTLPLANE_KUBEADM_EXTRA_CONFIG="
    users:
    - name: metal3
      lockPassword: false
      sudo: 'ALL=(ALL) NOPASSWD:ALL'
      sshAuthorizedKeys:
      - `cat ~/.ssh/id_rsa.pub`
"
export WORKERS_KUBEADM_EXTRA_CONFIG="
    users:
    - name: metal3
      lockPassword: false
      sudo: 'ALL=(ALL) NOPASSWD:ALL'
      sshAuthorizedKeys:
      - `cat ~/.ssh/id_rsa.pub`
"
