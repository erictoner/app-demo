#!/bin/bash

################################################################################
# Deployment Script for Kubernetes App using Helm and Minikube
#
# This script checks if Minikube, Helm, and Docker are installed and available.
# It starts Minikube, configures the Minikube Docker environment, builds a Docker
# image, and deploys the Kubernetes app using a Helm chart. The Helm chart is
# deployed or upgraded based on the specified release name and Helm chart version.
#
# Usage:
#   ./deploy_app.sh [options]
#
# Options:
#   -i, --image    Specify the Docker image name (default: app)
#   -t, --tag      Specify the Docker image tag (default: latest)
#
# Example:
#   ./deploy_app.sh -i app -t 0.0.1
#
# Dependencies: Minikube, Helm, Docker
#
################################################################################


# Check if Helm is installed
if ! command -v helm &>/dev/null; then
    echo "Error: Helm not detected. macOS users may install Helm via 'brew install helm'."
    exit 1
fi

# Check if Minikube is installed
if ! command -v minikube &>/dev/null; then
    echo "Error: Minikube not detected. Please install Minikube."
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &>/dev/null; then
    echo "Error: Docker not detected. Please install Docker."
    exit 1
fi

# Default values
IMAGE_NAME="app"
TAG_NAME="latest"
NAMESPACE="app"
HELM_CHART_DIR="./helm"
BUILD_SCRIPT="./ci/build_docker_image.sh"

# Function to start Minikube if not already started
start_minikube() {
    if ! minikube status &>/dev/null; then
        echo "Minikube is not started. Starting Minikube..."
        minikube start
    fi
}

# Function to build Docker image using the build script
build_docker_image() {
    echo "Building Docker image using $BUILD_SCRIPT..."
    eval $(minikube docker-env)
    chmod +x "$BUILD_SCRIPT"
    "$BUILD_SCRIPT"
}

# Function to deploy the Helm chart
deploy_helm_chart() {
  helm upgrade --install app --namespace "$NAMESPACE" --create-namespace "$HELM_CHART_DIR"
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -i|--image)
            IMAGE_NAME="$2"
            shift
            shift
            ;;
        -t|--tag)
            TAG_NAME="$2"
            shift
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Print verbose output
echo "Checking if Minikube is started..."
start_minikube

echo "Building Docker image..."
build_docker_image

echo "Deploying Kubernetes app using Helm chart..."
echo "Image Name: $IMAGE_NAME"
echo "Tag Name: $TAG_NAME"
echo "Namespace: $NAMESPACE"
echo "Helm Chart Directory: $HELM_CHART_DIR"
deploy_helm_chart

echo "Deployment completed successfully!"
