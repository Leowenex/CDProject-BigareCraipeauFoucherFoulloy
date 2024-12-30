# Build the image, then run it as privileged to allow Docker commands to be executed

docker build -t 'cdprojectrunner:latest' -f JenkinsDockerRunner.Dockerfile .

docker run -d --privileged -p 2222:22 --name cdprojectrunner cdprojectrunner:latest