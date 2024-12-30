# Pre-requisites: Helm, kubectl, minikube

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm install prometheus-cdp prometheus-community/prometheus --namespace monitoring
minikube service prometheus-cdp-server --url -n monitoring

# To uninstall:
# helm uninstall prometheus-cdp -n monitoring

# To access prometheus from another service, use the following URL:
# http://prometheus-cdp-server.monitoring.svc.cluster.local/