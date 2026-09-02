#!/bin/bash

#inputs
IMAGE_NAME=$1
IMAGE_TAG=$2

echo "starting our deployment script..."

if [ -z "$IMAGE_NAME" ] || [ -z "$IMAGE_TAG" ]; then
  echo "ERROR: IMAGE_NAME or IMAGE_TAG not passed in!"
  exit 1
fi

echo "pulling image ${IMAGE_NAME}:${IMAGE_TAG}"
docker pull "${IMAGE_NAME}:${IMAGE_TAG}"

echo "deployment complete"