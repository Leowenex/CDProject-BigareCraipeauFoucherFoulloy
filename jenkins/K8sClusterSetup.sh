# Creating namespaces
kubectl create namespace dev
kubectl create namespace prod

# Get the port for Minikube (for Jenkins)
kubectl config view

# Creating a Service Account for Jenkins with cluster-admin role
kubectl create sa jenkins
kubectl create clusterrolebinding jenkins --clusterrole=cluster-admin --serviceaccount=default:jenkins
kubectl create token jenkins --duration=8760h

# Copy the token and add it as a Secret Text credential in Jenkins "minikube-jenkins-token"
# See https://phati-sawant.medium.com/connect-to-a-kubernetes-cluster-and-execute-kubectl-commands-in-jenkins-pipeline-a3f474c1302f

# Dans le folder webapi-k8s

helm upgrade --install api-bcff -n dev helm_dev
kubectl port-forward service/api-bcff 9988:8080 -n dev --address 0.0.0.0

# Cela permet d'ouvrir le service sur le port 9988 de la machine hôte pour qu'il soit accessible depuis Jenkins pour l'étape de test
