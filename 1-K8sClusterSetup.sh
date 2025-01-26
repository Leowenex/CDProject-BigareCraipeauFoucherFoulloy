# Requires Minikube and Helm to be installed, and the cluster to be started with `minikube start` beforehand.

# Création des namespaces pour les environnements dev, prod et monitoring
kubectl create namespace dev
kubectl create namespace prod
kubectl create namespace monitoring

# Récupération du port de Minikube pour la configuration du pipeline Jenkins
kubectl config view

# Création d'un compte de service pour Jenkins avec le rôle cluster-admin
kubectl create sa jenkins
kubectl create clusterrolebinding jenkins --clusterrole=cluster-admin --serviceaccount=default:jenkins
kubectl create token jenkins --duration=8760h

# Copier le token et l'ajouter en tant que Secret Text dans Jenkins "minikube-jenkins-token"

# Dans le dosser webapi-k8s, on installe le chart Helm pour le namespace dev
cd ./webapi-k8s || exit

helm upgrade --install api-bcff -n dev helm_dev
kubectl port-forward service/api-bcff 9988:8080 -n dev --address 0.0.0.0

# Cela permet d'ouvrir le service sur le port 9988 de la machine hôte pour qu'il soit accessible depuis Jenkins pour l'étape de test
