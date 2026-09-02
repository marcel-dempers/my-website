#!/bin/bash

# settings
CONTAINER_NAME="my-website"

#inputs
IMAGE_NAME=$1
IMAGE_TAG=$2

echo "starting our live script..."

if [ -z "$IMAGE_NAME" ] || [ -z "$IMAGE_TAG" ]; then
  echo "ERROR: IMAGE_NAME or IMAGE_TAG not passed in!"
  exit 1
fi

echo "stopping current container (if running)..."
docker stop "$CONTAINER_NAME" 2>/dev/null || true
docker rm "$CONTAINER_NAME" 2>/dev/null || true

echo "starting new container..."
docker run -d \
  --name "$CONTAINER_NAME" \
  --restart always \
  -p 80:80 \
  "${IMAGE_NAME}:${IMAGE_TAG}"

echo "deployment complete"