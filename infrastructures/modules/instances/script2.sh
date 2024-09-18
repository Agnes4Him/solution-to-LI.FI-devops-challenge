#!/bin/bash

apt update -y && apt upgrade -y

apt install -y docker.io

usermod -aG docker ubuntu && newgrp docker

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

install conntrack

wget https://get.helm.sh/helm-v3.9.3-linux-amd64.tar.gz

tar xvf helm-v3.9.3-linux-amd64.tar.gz

mv linux-amd64/helm /usr/local/bin

rm helm-v3.9.3-linux-amd64.tar.gz

rm -rf linux-amd64

snap install kubectl --classic

apt install -y git

minikube start

git clone https://github.com/Agnes4Him/kubernetes-helm.git

cd kubernetes-helm

kubectl create ns apis

helm install -f apis/values/birdimage-api-values.yaml birdimage-api apis

helm install -f apis/values/bird-api-values.yaml bird-api apis

sleep 5

kubectl port-forward -n apis service/bird-api-service 4201:4201 --address 0.0.0.0 &
