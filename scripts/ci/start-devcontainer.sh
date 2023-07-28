#!/bin/bash

WORKSPACE_PATH=$1
CYPRESS_VERSION=$2

REQUIRED_VARS='WORKSPACE_PATH CYPRESS_VERSION'

for var in $REQUIRED_VARS; do
  if [ -z "${!var}" ]; then 
    echo "Error: variable $var needs to be set"
    exit 1
  fi
done

echo "Using following values:"
for var in $REQUIRED_VARS; do
  echo "  ${var}: ${!var}"
done

CYPRESS_VERSION=$CYPRESS_VERSION \
WORKSPACE_PATH=$WORKSPACE_PATH \
  docker compose \
    -f .docker/docker-compose.common.yml \
    -f .docker/docker-compose.e2e.ci.yml \
    up \
    -d
