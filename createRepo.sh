#!/bin/sh -e
curl -u "${GITHUB_TOKEN}:x-oauth-basic" https://api.github.com/user/repos -d "{\"name\":\"${MODULE}\"}"
mkdir repo
cd repo
echo "# Releases of ${MODULE}" >> README.md
git init
git add README.md
git commit -m "init"
git remote add origin git@github.com:pimatic-ci/${MODULE}.git
git push -u origin master
cd ..