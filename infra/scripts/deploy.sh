#!/bin/bash

# settings
DEPLOYMENT_SOURCE_DIR="$PWD/src"
DEPLOYMENT_DEST_DIR="/websites/my-website"

#inputs
PACKAGE_NUMBER=$1

echo "starting our deployment script..."

# Validate Inputs
if [ -z "$DEPLOYMENT_SOURCE_DIR" ]; then
  echo "ERROR: source directory is not set!"
  exit 1
fi

if [ -z "$PACKAGE_NUMBER" ]; then
  echo "ERROR: PACKAGE_NUMBER is not passed in!"
  exit 1
fi

if [ -z "$DEPLOYMENT_DEST_DIR" ]; then
  echo "ERROR: destination directory is not set!"
  exit 1
fi

echo "extracting package /home/github/packages/package-${PACKAGE_NUMBER}.tar.gz"

tar -C ${PWD} -xzf /home/github/packages/package-${PACKAGE_NUMBER}.tar.gz
ls -la $PWD