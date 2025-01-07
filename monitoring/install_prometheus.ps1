# Ajouter le dépôt Helm et mettre à jour
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Créer le namespace "monitoring" si ce n'est pas déjà fait
kubectl create namespace monitoring -o yaml --dry-run=client | kubectl apply -f -

# Générer le fichier values.yaml pour inclure les règles d'alerte
@"
serverFiles:
  alerting_rules.yml:
    groups:
      - name: PodTimeoutAlerts
        rules:
          - alert: PodTimeout
            expr: kube_pod_status_ready{condition="true"} == 0
            for: 2m
            labels:
              severity: critical
            annotations:
              summary: 'Pod Timeout Detected'
              description: 'Pod {{ $labels.pod }} in namespace {{ $labels.namespace }} has been inactive for over 2 minutes.'

  prometheus.yml:
    rule_files:
      - /etc/config/alerting_rules.yml
"@ | Set-Content -Encoding UTF8 values.yaml

# Installer ou mettre à niveau Prometheus
helm upgrade --install prometheus-cdp prometheus-community/prometheus `
  --namespace monitoring `
  -f values.yaml

# Vérifier si le service prometheus-cdp-server existe dans Minikube
$service = kubectl get svc prometheus-cdp-server -n monitoring --no-headers -o custom-columns=":metadata.name" 2>$null
if (-not $service) {
    Write-Output "Le service 'prometheus-cdp-server' n'a pas été trouvé dans l'espace de noms 'monitoring'."
    Write-Output "Répertoriez tous les services avec : 'minikube service list'."
} else {
    # Obtenir l'URL du service Prometheus dans Minikube
    Write-Output "Prometheus Server URL:"
    minikube service prometheus-cdp-server --url -n monitoring
}

# Instructions pour désinstaller si nécessaire
Write-Output @"
To uninstall:
helm uninstall prometheus-cdp -n monitoring

To access Prometheus from another service, use the following URL:
http://prometheus-cdp-server.monitoring.svc.cluster.local/
"@
