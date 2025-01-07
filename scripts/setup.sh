#!/bin/bash

# settings
GITHUB_REPO_URL="https://github.com/marcel-dempers/my-website.git"
DEPLOYMENT_SOURCE_DIR="$HOME/gitrepos/my-website"
DEPLOYMENT_DEST_DIR="/webites/my-website"

echo "starting our deployment script..."

echo "checking website source directory: $DEPLOYMENT_SOURCE_DIR and destination directory: $DEPLOYMENT_DEST_DIR..."

# Validate source and destination directories
if [ -z "$DEPLOYMENT_SOURCE_DIR" ]; then
  echo "ERROR: source directory is not set!"
  exit 1
fi

if [ -z "$DEPLOYMENT_DEST_DIR" ]; then
  echo "ERROR: destination directory is not set!"
  exit 1
fi

if [ -z "$GITHUB_REPO_URL" ]; then
  echo "ERROR: github repository url is not set!"
  exit 1
fi

# setup our source for our website

if [ ! -d "$DEPLOYMENT_SOURCE_DIR" ]; then
  echo "source directory does not exist, creating... "
  mkdir -p $DEPLOYMENT_SOURCE_DIR
  git clone --depth 1 $GITHUB_REPO_URL $DEPLOYMENT_SOURCE_DIR

  if [ $? -ne 0 ]
  then
    echo "Error: there was an error running the git command"
    exit 1
  fi

  echo "source directory created." 
else 
  echo "source directory exists, pulling latest changes..."
  git pull origin main

  if [ $? -ne 0 ]
  then
    echo "Error: there was an error running the git command"
    exit 1
  fi

  echo "source directory updated."
fi

echo "deploying latest changes..."

TIMESTAMP=$(date +"%Y%m%d%H%M%S")
NEW_DEPLOYMENT_DIR="$DEPLOYMENT_DEST_DIR/$TIMESTAMP"
mkdir -p "$NEW_DEPLOYMENT_DIR"
cp -r "$DEPLOYMENT_SOURCE_DIR"/* "$NEW_DEPLOYMENT_DIR"
echo "deployed website to $NEW_DEPLOYMENT_DIR"