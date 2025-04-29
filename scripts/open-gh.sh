#!/usr/bin/env bash
# open current repo in browser

# get URL of the remote repo
url=$(git remote get-url origin)

# check if the repo is on github
if [[ $url == *"github.com"* ]]; then
  # convert ssh url to https if needed
  if [[ $url == git@github.com:* ]]; then
    # convert from git@github.com:username/repo.git to https://github.com/username/repo
    repo_path=$(echo $url | sed 's/git@github.com://' | sed 's/\.git$//')
    url="https://github.com/$repo_path"
  fi

  # open url in default browser
  open $url
else
  echo "This repository is not hosted on GitHub"
fi
