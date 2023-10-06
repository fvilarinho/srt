#!/bin/bash

# Check the dependencies to run this script.
function checkDependencies() {
  DOCKER_CMD=$(which docker)

  if [ -z "$DOCKER_CMD" ]; then
    echo "Docker is not installed! Please install it first to continue!"

    exit 1
  fi

  DOCKER_COMPOSE_CMD=$(which docker-compose)

  if [ -z "$DOCKER_COMPOSE_CMD" ]; then
    echo "Docker compose is not installed! Please install it first to continue!"

    exit 1
  fi
}

# Prepare the environment to run this script.
function prepareToExecute() {
  source .env
}

# Authenticate in the docker registry.
function auth() {
  echo "$DOCKER_REGISTRY_PASSWORD" | docker login -u "$DOCKER_REGISTRY_ID" "$DOCKER_REGISTRY_URL" --password-stdin
}

# Publish the container images.
function publish() {
  $DOCKER_COMPOSE_CMD push
}

# Main function.
function main() {
  checkDependencies
  prepareToExecute
  auth
  publish
}

main