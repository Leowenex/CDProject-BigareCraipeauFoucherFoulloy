#!/bin/bash

# Start SSH server
service ssh start

# Start Docker engine
dockerd &

# Keep the container running
tail -f /dev/null