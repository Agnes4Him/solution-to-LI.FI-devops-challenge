#!/bin/bash

#update package repositories
apt update -y && apt upgrade -y

#install docker to be used by kind to create kubernetes cluster
apt install -y docker.io

#add ubuntu user to docker group
usermod -aG docker ubuntu && newgrp docker

#download kind if os architecture is X86_64
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.24.0/kind-linux-amd64

#make `kind` executable
chmod +x ./kind

#move `kind` folder to /usr/local/bin directory to enable the use of the cli from anywhere 
mv ./kind /usr/local/bin/kind

#download helm
wget https://get.helm.sh/helm-v3.9.3-linux-amd64.tar.gz

#untar helm tar file
tar xvf helm-v3.9.3-linux-amd64.tar.gz

#move helm to /usr/local/bin directory to enable easy use of the `helm` cli
mv linux-amd64/helm /usr/local/bin

#delete the helm tar file
rm helm-v3.9.3-linux-amd64.tar.gz

#delete the entire directory containing the helm tar file
rm -rf linux-amd64

#install kubectl
snap install kubectl --classic

#install git
apt install -y git

#run the rest of the commands as ubuntu user
sudo -u ubuntu -i <<'EOF'

git clone https://github.com/Agnes4Him/kubernetes-helm.git

cd kubernetes-helm

kind create cluster --config kind/kind-config.yaml --wait 30s

kind get kubeconfig >> $HOME/.kube/config

kubectl create ns apis

helm install -f apis/values/birdimage-api-values.yaml birdimage-api apis

helm install -f apis/values/bird-api-values.yaml bird-api apis

EOF