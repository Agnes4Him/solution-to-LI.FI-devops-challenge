#!/bin/bash

#update package
sudo apt update

#install docker
sudo apt install docker.io -y

#add current user to docker group
sudo usermod -aG docker $USER

newgrp docker

#install minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

#install Helm
wget https://get.helm.sh/helm-v3.9.3-linux-amd64.tar.gz

tar xvf helm-v3.9.3-linux-amd64.tar.gz

sudo mv linux-amd64/helm /usr/local/bin

rm helm-v3.9.3-linux-amd64.tar.gz

rm -rf linux-amd64

#install git
sudo apt install git-all

#clone k8s helm git repo
git clone ...

#start minikube
minikube start

#run helm install to deploy bird-api and birdimage-api
cd kubernetes

helm install -f apis/values/birdimage-api-values.yaml birdimage-api apis

helm install -f apis/values/bird-api-values.yaml bird-api apis

#sleep for 10seconds
sleep 10

#port-forward bird api service
kubectl port-forward svc/bird-api-service 4201:4201 &
