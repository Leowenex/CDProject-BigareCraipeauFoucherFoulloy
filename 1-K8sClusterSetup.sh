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

# Pour le namespace prod, on peut installer le chart Helm et le port-forwarder avec les commandes suivantes
helm upgrade --install api-bcff -n prod helm_prod
kubectl port-forward service/api-bcff 9977:8080 -n prod --address 0.0.0.0

# Ces dernières commandes sont optionnel, car le déploiement en prod peut être fait par Jenkins sans port-forwarding du service de ce namespace


# Enfin, on peut exposer les les services sur le port 80 de la machine hôte via les Ingress avec les commandes suivantes

minikube addons enable ingress
minikube tunnel

# Minikube tunnel ne permettant pas d'exposer les services au-délà de la machine hôte, le port forward de la ligne 22 est quand même nécessaire pour les tests de Jenkins