#!/usr/bin/env bash
#
################################################################################
# Docker Image Building Script
#
# This script builds a Docker image with optional custom IMAGE_NAME and TAG_NAME.
# If TAG_NAME is not provided, the latest git tag will be used.
#
# Usage:
#   ./script.sh [-i IMAGE_NAME] [-t TAG_NAME] [-h]
#
# Options:
#   -i IMAGE_NAME  Specify the custom image name (default: app)
#   -t TAG_NAME    Specify the custom tag name (default: latest)
#   -h             Display this help message
#
################################################################################

# Default values
DEFAULT_IMAGE_NAME='app'
DEFAULT_TAG_NAME='latest'

# Help message function
print_help() {
    echo "Usage: $0 [-i IMAGE_NAME] [-t TAG_NAME] [-h]"
    echo "Builds a Docker image with optional custom IMAGE_NAME and TAG_NAME."
    echo "If TAG_NAME is not provided, the latest git tag will be used."
    echo ""
    echo "Options:"
    echo "  -i IMAGE_NAME  Specify the custom image name (default: $DEFAULT_IMAGE_NAME)"
    echo "  -t TAG_NAME    Specify the custom tag name (default: $DEFAULT_TAG_NAME)"
    echo "  -h             Display this help message"
    exit 0
}

# Parse command-line arguments
while getopts "i:t:h" opt; do
    case "$opt" in
        i) IMAGE_NAME=$OPTARG ;;
        t) TAG_NAME=$OPTARG ;;
        h) print_help ;;
    esac
done

# Set default values if not provided
IMAGE_NAME=${IMAGE_NAME:-$DEFAULT_IMAGE_NAME}

# Get current git tag as TAG_NAME if not provided
if [ -z "$TAG_NAME" ]; then
    TAG_NAME=$(git describe --tags --abbrev=0)
    if [ -z "$TAG_NAME" ]; then
        echo "No git tag found. Please provide a tag name using the -t option."
        exit 1
    fi
fi

# Build the Docker image
echo "Building Docker image: $IMAGE_NAME:$TAG_NAME"
docker build -t "$IMAGE_NAME:$TAG_NAME" .
echo "Docker build successful: $IMAGE_NAME:$TAG_NAME"

# Create a 'latest' tag if not already created
if [ "$TAG_NAME" != "latest" ]; then
    echo "Creating 'latest' tag: $IMAGE_NAME:latest"
    docker tag "$IMAGE_NAME:$TAG_NAME" "$IMAGE_NAME:latest"
    echo "Tag created: $IMAGE_NAME:latest"
fi

echo "Image build and tagging complete."
