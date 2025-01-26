<#
.SYNOPSIS
  Script de test pour la configuration Alertmanager (SMTP) avec deux alertes.
  - Une alerte si un pod est en arrêt depuis plus de 10 minutes (sans envoi d'e-mail).
  - Une alerte pour un haut taux d'utilisation CPU (envoie un e-mail).

.DESCRIPTION
  - Ajoute le dépôt Helm prometheus-community.
  - Crée le namespace "monitoring" si nécessaire.
  - Génère test-values.yaml contenant :
    * Deux règles d'alerte :
      - "PodDown" : se déclenche si un pod est en échec depuis plus de 10 minutes.
      - "HighCPUUsage" : détecte un haut taux d'utilisation CPU.
    * La configuration Alertmanager (paramètres SMTP) configurée pour n'envoyer des e-mails que pour les alertes critiques.
  - Installe/Met à jour le chart "prometheus-community/prometheus" avec cette configuration.
  - Affiche l'URL d'accès à Prometheus dans Minikube.
#>

# 0) Cd dans le répertoire monitoring
cd "$PSScriptRoot\monitoring"

# 1) Ajouter le dépôt Helm et mettre à jour
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# 2) Créer le namespace "monitoring" si ce n'est pas déjà fait
kubectl create namespace monitoring -o yaml --dry-run=client | kubectl apply -f -

# 3) Générer le fichier test-values.yaml
@"
serverFiles:
  # Règles d'alerte
  alerting_rules.yml:
    groups:
      - name: PodAndCPUAlerts
        rules:
          - alert: PodDown_Foucher_Craipeau_Fouloy_Bigare
            expr: kube_pod_status_phase{phase="Failed"} == 1
            for: 10m
            labels:
              severity: warning
            annotations:
              summary: "Pod en échec depuis plus de 10 minutes"
              description: "Le pod {{ `$labels.pod }} dans le namespace {{ `$labels.namespace }} est en échec depuis plus de 10 minutes."

          - alert: HighCPUUsage_Foucher_Craipeau_Fouloy_Bigare
            expr: rate(container_cpu_usage_seconds_total{pod!=""}[2m]) > 0.9
            for: 5m
            labels:
              severity: critical
            annotations:
              summary: "Haute utilisation du CPU détectée"
              description: "Le taux d'utilisation du CPU pour le pod {{ `$labels.pod }} dans le namespace {{ `$labels.namespace }} dépasse 90% depuis plus de 5 minutes."

  # Référence du fichier de règles dans Prometheus
  prometheus.yml:
    rule_files:
      - /etc/config/alerting_rules.yml

# Activation et configuration d'Alertmanager
alertmanager:
  enabled: true
  config:
    global:
      smtp_smarthost: 'smtp.gmail.com:587'
      smtp_from: 'rom1foucher@gmail.com'
      smtp_auth_username: 'rom1foucher@gmail.com'
      smtp_auth_password: ''  # À sécuriser
      smtp_require_tls: true

    route:
      # Route principale
      receiver: 'none'
      group_wait: 1m
      group_interval: 10m
      repeat_interval: 1h

      # Routes spécifiques basées sur la sévérité
      routes:
        - match:
            severity: critical
          receiver: 'email-default'

    receivers:
      - name: 'email-default'
        email_configs:
          - to: 'lazhar.hamel@efrei.fr'
            send_resolved: true

      - name: 'none'
        # Pas de configuration pour ne rien faire
"@ | Set-Content -Encoding UTF8 test-values.yaml

# 4) Installer ou mettre à niveau Prometheus (et Alertmanager) avec notre configuration de test
helm upgrade --install prometheus-test prometheus-community/prometheus `
  --namespace monitoring `
  -f test-values.yaml

# 5) Vérifier si le service prometheus-test-server existe dans Minikube
$serviceName = "prometheus-test-server"
$service = kubectl get svc $serviceName -n monitoring --no-headers -o custom-columns=":metadata.name" 2>$null
if (-not $service) {
    Write-Output "Le service '$serviceName' n'a pas été trouvé dans l'espace de noms 'monitoring'."
    Write-Output "Répertoriez tous les services : 'minikube service list'."
} else {
    # Obtenir l'URL du service Prometheus dans Minikube
    Write-Output "Prometheus Server URL (Minikube) :"
    minikube service $serviceName --url -n monitoring
}