# Bitnami Sealed Secrets

kubectl apply -f https://github.com/bitnami-labs/sealed-secrets/releases/latest/download/controller.yaml

kubectl get pods -n kube-system | grep sealed-secrets

# Install kubeseal CLI

export KUBESEAL_VERSION="0.23.0"
wget -O kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz \
  "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION}/kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz"
tar -xvzf kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz kubeseal
sudo install -m 755 kubeseal /usr/local/bin/kubeseal

kubeseal --version
