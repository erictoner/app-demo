#!/bin/bash

################################################################################
# Test Docker Image Script
#
# This script manages the execution of a Docker container for a specified image
# and tag. It checks for the existence of the image, stops and removes any
# pre-existing containers with the same name, and starts a new container if it
# is not already running. It then runs a Python script against the running
# container.
#
# Usage:
#   ./run_docker_container.sh [options]
#
# Options:
#   -i, --image    Specify the Docker image name (default: app)
#   -t, --tag      Specify the Docker image tag (default: latest)
#
# Example:
#   ./test_docker_image.sh --image app --tag 0.0.1
#
# Dependencies: Docker
#
################################################################################

# Default values
DEFAULT_IMAGE_NAME="app"
DEFAULT_TAG_NAME="latest"
IMAGE_NAME="$DEFAULT_IMAGE_NAME"
TAG_NAME="$DEFAULT_TAG_NAME"

# Override defaults with user input
while getopts ":i:t:" opt; do
  case $opt in
    i)
      IMAGE_NAME="$OPTARG"
      ;;
    t)
      TAG_NAME="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

# Check if the image and tag exist
if ! docker image inspect "$IMAGE_NAME:$TAG_NAME" &> /dev/null; then
  echo "The image '$IMAGE_NAME:$TAG_NAME' does not exist."
  echo "To build the Docker image, run: ci/build_docker_image.sh"
  exit 1
fi

# Prune pre-existing $IMAGE_NAME containers, stopped or running
EXISTING_CONTAINER=$(docker ps -aq -f name="$IMAGE_NAME")
if [ -n "$EXISTING_CONTAINER" ]; then
  echo "Stopping and removing pre-existing container '$IMAGE_NAME'..."
  docker stop "$EXISTING_CONTAINER" &> /dev/null
  docker rm "$EXISTING_CONTAINER" &> /dev/null
fi

# Check if the container with the specified name is already running
if [ ! "$(docker ps | grep $IMAGE_NAME)" ]; then
    echo "Starting $IMAGE_NAME:$TAG_NAME image now."
    docker run -d -p 8001:8001 --name "$IMAGE_NAME" "$IMAGE_NAME:$TAG_NAME"
fi

CONTAINER_ID=$(docker ps -q -f name="$IMAGE_NAME")
echo "Container ID: $CONTAINER_ID"

# Run your Python script against the running container
docker exec "$CONTAINER_ID" python test.py
