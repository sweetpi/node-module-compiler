#!/bin/sh -e
chmod 600 ./deploy_key
eval "$(ssh-agent)"
ssh-add ./deploy_key
git clone git@github.com:pimatic-ci/sqlite3.git repo
cp -R ./node_modules/sqlite3/ repo/
cd repo
git config user.email "oliverschneider89+sweetpi@gmail.com"
git config user.name "pimatic-ci"
git add -A
git commit -a -m "new build"
git push