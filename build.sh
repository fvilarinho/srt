#!/bin/bash

# Check the dependencies to run this script.
function checkDependencies() {
  DOCKER_COMPOSE_CMD=$(which docker-compose)

  if [ -z "$DOCKER_COMPOSE_CMD" ]; then
    echo "Docker compose is not installed! Please install it first to continue!"

    exit 1
  fi
}

# Build the container images.
function build() {
  $DOCKER_COMPOSE_CMD build
}

# Main function.
function main() {
  checkDependencies
  build
}

main