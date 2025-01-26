# Build the image, then run it as privileged to allow Docker commands to be executed
# Construit l'image, puis l'éxecute en mode privilégiée pour permettre l'exécution de commandes Docker

cd ./jenkins || exit

docker build -t 'cdprojectrunner:latest' -f JenkinsDockerRunner.Dockerfile .

docker run -d --privileged -p 2222:22 --name cdprojectrunner cdprojectrunner:latest

# Pause at the end
read -n 1 -s -r -p "Press any key to continue"