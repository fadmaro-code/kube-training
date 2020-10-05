# LXD setup (Skip this if using another virtualization solution or the host itself)

## 1. Install and enable LXD

### Archlinux

```bash
sudo pacman -Sy lxd --needed --noconfirm
```

### Ubuntu

```bash
sudo apt install lxd
```

## 2. Add user to lxd group

```bash
usermod -aG lxd $USER
```

## 3. Enable and start lxd service

```bash
sudo systemctl enable lxd
sudo systemctl start lxd
```

## 4. Init lxd service

```bash
lxd init
```

## 5. Configure lxd storage pool

### 5.1 Create a location for the pool to use

### 5.2 Create the storage pool

```bash
lxc storage create <pool-name> <driver> source=</path>
```
## 6. Create a profile for kubernetes cluster images

### 6.1 Copy default profile

```bash
lxc profile copy default k8s
```

### 6.2 Edit k8s profile to resemble the one in **lxc-profile/k8s.yaml** in this repo

```bash
lxc profile edit k8s
```

## 7. Launch lxc image

### Archlinux image

```bash
lxc launch images:archlinux <name> --profile k8s
```

### Ubuntu image

```bash
lxc launch ubuntu:20.04 <name> --profile k8s
```

## 8. Connecting with the image

### Archlinux image

```bash
lxc exec <name> bash
```

### Ubuntu image

```bash
lxc exec <name> bash
```

or

```bash
lxc exec <name> su - ubuntu
```

## Extra commands

### Start a container

```bash
lxc start <name>
```

### Stop a container

```bash
lxc stop <name>
```

### Container info

```bash
lxc info <name>
```

* * *

# Kubernetes installation and setup

## 1. Install docker

### Archlinux

```bash
sudo pacman -Sy docker --needed --noconfirm
```

### Ubuntu

Execute the script found in the *script/docker-ubuntu.sh* folder in this repo

## 2. Add your user to docker group

```bash
sudo usermod -aG docker $USER
```

## 3. Setup the docker daemon

```bash
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
```

## 4. Enable and start/restart docker

```bash
sudo systemctl enable docker
sudo systemctl restart docker
```

## 5. Install kubernetes dependencies

### Archlinux

```bash
sudo pacman -Sy cni-plugins ebtables ethtool socat conntrack-tools kubectl --needed --noconfirm
```
and

```bash
yay -Sy kubelet-bin kubeadm-bin kubectl cri-o-git --needed --noconfirm
```

### Ubuntu

Run the script found in *script/k8s-ubuntu.sh*

## 6. Create the device node file (If using LXD)

**IMPORTANT:** This node file must be created every time the machine is shutdown and up again
```bash
sudo mknod /dev/kmsg c 1 11
```

## 7. Disable swap (If using VB,VMWare or the host machine itself)

```bash
sudo swapoff -a
```

## 8. Enable kubelet service

```bash
sudo systemctl enable kubelet
```

## 9. Copy LXC image to create a minion mode (If using LXD)

```bash
lxc copy <master-image> <minion-node-name>
```

## 10. Initialize master node

```bash
sudo kubeadm init --apiserver-advertise-address=<host-ip> --pod-network-cidr=192.168.0.0/16
```

## 11. Copy kubectl configurations

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

## 12. Install network plugin

We are going to use calico, but there is a whole list in *https://kubernetes.io/docs/concepts/cluster-administration/networking/*

```bash
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
```

```bash
kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml
```

## Extra commands

### Get nodes

```bash
kubectl get nodes
```

### Watching resources status

```bash
watch kubectl get all --all-namespaces
```

### Describe a resource

#### Describe a node

```bash
kubectl describe nodes/<node-name>
```

#### Describe a pod in default namespace

```bash
kubectl describe pods/<pod-name>
```

#### Describe a pod in another namespace

```bash
kubectl describe pods/<pod-name> --namespace <namespace>
```

### View pod logs

```bash
kubectl logs pods/<pod-name>
```

### Logging into pod

#### Logging as root

```bash
kubectl exec pods/<pod-name> bash
```

#### Logging as user

```bash
kubectl exec pods/<pod-name> su - <user>
```

### Create resources

```bash
kubectl create -f <file>.yaml
```

### Apply changes

```bash
kubectl apply -f <file-changed>.yaml
```

### Delete resources

```bash
kubectl delete -f <file>.yaml
```

### Enable pods scheduling on master

```bash
kubectl taint nodes <master-name> node-role.kubernetes.io/master-
```
