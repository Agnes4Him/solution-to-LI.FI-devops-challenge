#!/bin/bash

#update package
sudo apt update -y && sudo apt upgrade -y

#install docker
sudo apt install -y docker.io

#add current user to docker group
sudo usermod -aG docker ubuntu && newgrp docker

#install minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

sudo install conntrack

#install Helm
wget https://get.helm.sh/helm-v3.9.3-linux-amd64.tar.gz

tar xvf helm-v3.9.3-linux-amd64.tar.gz

sudo mv linux-amd64/helm /usr/local/bin

rm helm-v3.9.3-linux-amd64.tar.gz

rm -rf linux-amd64

#install kubectl
sudo snap install kubectl --classic

#install git
sudo apt install -y git

#become root user
sudo -i

#start minikube
minikube start --driver=docker

#clone k8s helm git repo
#sudo git clone https://github.com/Agnes4Him/kubernetes-helm.git

git clone https://github.com/Agnes4Him/kubernetes-helm.git

#run helm install to deploy bird-api and birdimage-api
cd kubernetes-helm

kubectl create ns apis

helm install -f apis/values/birdimage-api-values.yaml birdimage-api apis

helm install -f apis/values/bird-api-values.yaml bird-api apis

#sleep for 5 seconds
sleep 5

#port-forward bird api service
kubectl port-forward -n apis service/bird-api-service 4201:4201 --address 0.0.0.0 &
