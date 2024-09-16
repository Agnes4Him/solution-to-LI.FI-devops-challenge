helm install -f myvalues.yaml myredis ./redis

helm install --values values.yaml stable/traefik

helm install -f apis/values/birdimage-api-values.yaml birdimage-api apis

helm install -f apis/values/bird-api-values.yaml bird-api apis

helm repo add traefik https://helm.traefik.io/traefik

helm repo update

helm install -f apis/values/traefik-values.yaml traefik traefik/traefik

