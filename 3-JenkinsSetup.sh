# Prérequis: Docker installé

docker run -d -p 8090:8080 -p 50000:50000 --name jenkins --restart unless-stopped jenkins/jenkins:lts-jdk17

# Ouvrir un navigateur et naviguer vers http://localhost:8090
# Suivre les instructions pour compléter la configuration de Jenkins
# Le mot de passe admin initial peut être trouvé dans les logs du container Jenkins

# Recommended Settings:
# - Install suggested plugins
# - Admin with credentials:
#   - Username: admin
#   - Password: admin
#   - Full Name: admin
#   - Email: admin@example.com

# Créer un credential login/password pour DockerHub, GitHub et pour le Runner (root:admin)
# - Administrer Jenkins > Credentials > System > Identifiants globaux (illimité)  > Add Credentials

# Créer un credential secretText pour Kubernetes, voir le fichier K8sClusterSetup.sh

# Installer les plugins Docker Pipeline, Kubernetes, Kubernetes Credentials, and Kubernetes CLI
# - Administrer Jenkins > Plugins > Available Plugins

# Ajouter le runner
# - Administrer Jenkins > Nodes > New Node
# - Nom : Runner
# - Permanent Agent
# - Remote root directory : /root/jenkins
# - Labels : jenkins-slave
# - Launch method : Launch agent via SSH
# - Host : ipv4 locale (faire ipconfig pour trouver l'adresse)
# - Credentials : root:admin (crédential créé précédemment)
# - Host Key Verification Strategy : Non verifying Verification Strategy
# - Avancé > Port : 2222


# Créer un projet Pipeline
# - Jenkins > New Item
# - Nom : CDProject
# - Type : Pipeline
# puis copier le contenu du pipeline depuis le fichier Jenkins.build

# Dans le text copié, remplacer le port du serverUrl par celui trouvé en faisant <kubectl config view>