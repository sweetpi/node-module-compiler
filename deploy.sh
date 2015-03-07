#!/bin/sh -e
chmod 600 ./deploy_key
eval "$(ssh-agent)"
ssh-add ./deploy_key
git clone git@github.com:pimatic-ci/${MODULE}.git repo
rm -r -f ./repo/*
cp -R ./node_modules/${MODULE}/* ./repo/
cd repo
git config user.email "oliverschneider89+pimatic-ci@gmail.com"
git config user.name "pimatic-ci"
#git rm --ignore-unmatch -- $(git ls-files --deleted)  
git add -A .
git diff
git commit -a -m "new build"
git push