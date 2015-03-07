#!/bin/sh -e
chmod 600 ./deploy_key
ssh-add ./deploy_key
git clone git@github.com:pimatic-ci/sqlite3.git repo
cp -R ./node_modules/sqlite3/ repo/
cd repo
git commit -a -m "new build"
git push