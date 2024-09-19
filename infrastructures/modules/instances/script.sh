#!/bin/bash

apt update -y && apt upgrade -y

apt install -y docker.io

usermod -aG docker ubuntu && newgrp docker

[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.24.0/kind-linux-amd64

chmod +x ./kind

mv ./kind /usr/local/bin/kind

wget https://get.helm.sh/helm-v3.9.3-linux-amd64.tar.gz

tar xvf helm-v3.9.3-linux-amd64.tar.gz

mv linux-amd64/helm /usr/local/bin

rm helm-v3.9.3-linux-amd64.tar.gz

rm -rf linux-amd64

snap install kubectl --classic

apt install -y git

sudo -u ubuntu -i <<'EOF'

git clone https://github.com/Agnes4Him/kubernetes-helm.git

kind create cluster --wait 30s

kind get kubeconfig >> $HOME/.kube/config

cd kubernetes-helm

kubectl create ns apis

helm install -f apis/values/birdimage-api-values.yaml birdimage-api apis

helm install -f apis/values/bird-api-values.yaml bird-api apis

sleep 55

kubectl port-forward -n apis service/bird-api-service 4201:4201 --address 0.0.0.0 &

EOF