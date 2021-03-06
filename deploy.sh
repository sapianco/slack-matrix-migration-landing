#!/bin/bash

Red="\033[0;31m"          # Red
Green="\033[0;32m"        # Green
Color_Off="\033[0m"       # Text Reset

echo -e "$Green Deploying updates to GitHub...$Color_Off"

if [ "$1" ]
  then msg="$1"
else
  msg="rebuilding site `date`"
fi

if [ "$2" ]
  then version="$2"
else
  read -p "$(echo -e $Red"Enter Tag Version: "$Color_Off)" version
fi

# Empty the public folder.
rm -rf ${HOME}/Workspace/slack-matrix-migration-landing/public/*
echo "slack2matrix.sapian.cloud" > ${HOME}/Workspace/slack-matrix-migration-landing/public/CNAME

# Change the version file
rm version
rm buildDate
echo "$version" > version
echo "`date +'%a, %Y-%m-%d %T'`" > buildDate

# Build the project.
hugo

# Add changes to git.
git add --all

# Commit changes.
git commit -am "$msg"

# Add a git tag, to show on the main repository that the site is live.
git tag v$version

# Push source and build repos.
git push origin main --tags
git push git@github.com:sapianco/slack-matrix-migration.git `git subtree split --prefix public main`:gh-pages --force
