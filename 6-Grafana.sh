# Prerequisites: Helm, kubectl, minikube

cd ./monitoring || exit

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm install grafana-cdp grafana/grafana --namespace monitoring
kubectl get secret --namespace monitoring grafana-cdp -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
minikube service grafana-cdp --url -n monitoring

# To uninstall:
# helm uninstall grafana-cdp -n monitoring