# Requirements: Docker Desktop for Windows

docker run -d -p 8090:8080 -p 50000:50000 --name jenkins --restart unless-stopped jenkins/jenkins:lts-jdk17
# (Using port 8090 to avoid conflicts with other services)

# Open a browser and navigate to http://localhost:8080
# Follow the instructions to complete the Jenkins setup
# The initial admin password can be found in the Jenkins container logs

# Recommended Settings:
# - Install suggested plugins
# - Admin with credentials:
#   - Username: admin
#   - Password: admin
#   - Full Name: admin
#   - Email: admin@example.com

# Set credentials for Docker Hub and GitHub
# - Jenkins > Manage Jenkins > Credentials > System > Global credentials (unrestricted) > Add Credentials

# Install Docker and Git plugins
# - Jenkins > Manage Jenkins > Plugins > Available Plugins

# Créer un projet Pipeline
# - Jenkins > New Item > Pipeline