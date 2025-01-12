#!/bin/bash

# settings
GITHUB_REPO_URL="https://github.com/marcel-dempers/my-website.git"
DEPLOYMENT_SOURCE_DIR="$HOME/gitrepos/my-website"
DEPLOYMENT_DEST_DIR="$HOME/webites/my-website"
CONFIG_FILE="$DEPLOYMENT_DEST_DIR/nginx.conf"

echo "starting our deployment script..."

validateInput() {
  
  local deployment_source_dir=$1
  local deployment_dest_dir=$2
  local github_repo_url=$3
  echo "checking website source directory: $deployment_source_dir and destination directory: $deployment_dest_dir..."
  # Validate source and destination directories
  if [ -z "$deployment_source_dir" ]; then
    echo "ERROR: source directory is not set!"
    exit 1
  fi

  if [ -z "$deployment_source_dir" ]; then
    echo "ERROR: destination directory is not set!"
    exit 1
  fi

  if [ -z "$github_repo_url" ]; then
    echo "ERROR: github repository url is not set!"
    exit 1
  fi
}

syncGithubSource() {

  local deployment_source_dir=$1
  local github_repo_url=$2

  # setup our source for our website
  if [ ! -d "$deployment_source_dir" ]; then
    echo "source directory does not exist, creating... "
    mkdir -p $deployment_source_dir
    git clone --depth 1 $github_repo_url $deployment_source_dir

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
}

deployWebsite() {

  local deployment_source_dir=$1
  local deployment_dest_dir=$2
  local config_file=$3

  echo "deploying latest changes..."
  TIMESTAMP=$(date +"%Y%m%d%H%M%S")
  NEW_DEPLOYMENT_DIR="$deployment_dest_dir/$TIMESTAMP"
  mkdir -p "$NEW_DEPLOYMENT_DIR"

  # Copy source files to the new directory
  cp -r "$deployment_source_dir"/* "$NEW_DEPLOYMENT_DIR"
  echo "deployed website to $NEW_DEPLOYMENT_DIR"

  echo "updating website configuration..."
  if [ -f "$config_file" ]; then
    echo "updating website configuration..."
    sed -i "s|root $deployment_dest_dir/.*;|root $NEW_DEPLOYMENT_DIR;|" "$config_file"
    echo "website configuration updated."
  else
    echo "creating website configuration..."
    echo "server {
      listen 80;
      server_name my-website.com;
      root $NEW_DEPLOYMENT_DIR;
    }" > $config_file
  fi
}

validateInput $DEPLOYMENT_SOURCE_DIR $DEPLOYMENT_DEST_DIR $GITHUB_REPO_URL
syncGithubSource $DEPLOYMENT_SOURCE_DIR $GITHUB_REPO_URL
deployWebsite $DEPLOYMENT_SOURCE_DIR $DEPLOYMENT_DEST_DIR $CONFIG_FILE

echo "deployment complete"