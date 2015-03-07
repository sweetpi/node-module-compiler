#!/bin/sh -e
chmod 600 ./deploy_key
eval "$(ssh-agent)"
ssh-add ./deploy_key
git clone git@github.com:pimatic-ci/sqlite3.git repo
rm -r -f ./repo/*
cp -R ./node_modules/sqlite3 ./repo
cd repo
git rm $(git ls-files --deleted)  
git config user.email "oliverschneider89+pimatic-ci@gmail.com"
git config user.name "pimatic-ci"
git add -A
git commit -a -m "new build"
git push