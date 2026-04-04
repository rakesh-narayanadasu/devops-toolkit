# Install KIND

curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64

chmod +x kind
sudo mv kind /usr/local/bin/

kind --version

kind create cluster

kubectl get nodes

kind create cluster --config kind-config.yaml

kind delete cluster
