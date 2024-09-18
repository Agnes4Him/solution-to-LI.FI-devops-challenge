#!/bin/bash

#update package
sudo yum update -y && sudo yum upgrade -y

#install docker
sudo yum install -y docker
#sudo amazon-linux-extras install docker

#add current user to docker group
sudo usermod -aG docker ec2-user && newgrp docker

#start docker service
sudo systemctl start docker && sudo systemctl enable docker

#install minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm

sudo rpm -Uvh minikube-latest.x86_64.rpm

#install Helm
wget https://get.helm.sh/helm-v3.9.3-linux-amd64.tar.gz

tar xvf helm-v3.9.3-linux-amd64.tar.gz

sudo mv linux-amd64/helm /usr/local/bin

rm helm-v3.9.3-linux-amd64.tar.gz

rm -rf linux-amd64

#install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.30.0/bin/linux/amd64/kubectl

sudo chmod +x ./kubectl

sudo mv ./kubectl /usr/local/bin/kubectl

#install git
sudo yum install -y git

#start minikube
minikube start

#clone k8s helm git repo
#sudo git clone https://github.com/Agnes4Him/kubernetes-helm.git

git clone https://github.com/Agnes4Him/kubernetes-helm.git $HOME/kubernetes-helm

#run helm install to deploy bird-api and birdimage-api
cd /kubernetes-helm

kubectl create ns apis

helm install -f apis/values/birdimage-api-values.yaml birdimage-api apis

helm install -f apis/values/bird-api-values.yaml bird-api apis

#sleep for 5 seconds
sleep 5

#port-forward bird api service
kubectl port-forward -n apis service/bird-api-service 4201:4201 --address 0.0.0.0 &
