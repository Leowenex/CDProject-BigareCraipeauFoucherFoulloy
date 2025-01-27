# Projet de DevOps - I3APP LS1

## Auteurs :
- Charlotte BIGARE
- Antoine CRAIPEAU
- Romain FOUCHER
- Léo FOULLOY

## Livrables :

- Scripts Bash et Powershell (x_script.sh | x_script.ps1) : Scripts incluant les commandes permettant de mettre en place l'infrastructure conçue par l'équipe sur une machine équipée de Docker et Minikube.
- Dossier ./jenkins : Contient le fichier Jenkins.build contenant notre pipeline CD, la Dockerfile de notre image de runner Jenkins, et le script de démarrage utilisé par notre image de runner Jenkins.
- Dossier ./monitoring : Contient le fichier de configuration Loki, et les manifests Kubernetes permettant de tester nos alertes Prometheus (Définies dans le script 5-InstallPrometheus.ps1 ).
- Dossier ./webapi-k8s : Contient les charts Helm permettant de déployer l'image de l'application Go dans le cluster Minikube avec un déploiement, un service, et un Ingress, pour le namespace dev ou prod.
- Dossier ./webapi : Contient le code source de l'application Go ainsi que sa Dockerfile.

