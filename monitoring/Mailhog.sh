# Pre-requisites: Kubectl, minikube

kubectl create namespace monitoring
kubectl apply -f mailhog.yaml -n monitoring
minikube service mailhog-service -n monitoring --url

# To access mailhog from the browser, use the second forwarded port, first port is for SMTP

# To uninstall:
# kubectl delete -f mailhog.yaml -n monitoring