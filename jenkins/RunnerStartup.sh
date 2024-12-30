#!/bin/bash

# Start SSH server
service ssh start

# Start Docker engine
dockerd &

# Start Minikube
minikube start --driver=docker --force

# Keep the container running
tail -f /dev/null