# Pre-requisites: Helm, kubectl, minikube

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm upgrade --install --values loki-config.yaml loki grafana/loki-stack -n monitoring
kubectl get secret --namespace monitoring grafana-cdp -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
minikube service loki-grafana --url -n monitoring

# to test :

# curl -H "Content-Type: application/json" -XPOST -s "http://127.0.0.1:3100/loki/api/v1/push"  --data-raw "{\"streams\": [{\"stream\": {\"job\": \"test\"}, \"values\": [[\"$(date +%s)000000000\", \"fizzbuzz\"]]}]}" -H X-Scope-OrgId:foo

# curl "http://127.0.0.1:3100/loki/api/v1/query_range" --data-urlencode 'query={job="test"}' -H X-Scope-OrgId:foo | jq .data.result

# To uninstall:
# helm uninstall loki-cdp -n monitoring