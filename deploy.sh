#!/bin/sh -e
openssl aes-256-cbc -K $encrypted_161a5cc809f6_key -iv $encrypted_161a5cc809f6_iv -in deploy_key.enc -out deploy_key -d
chmod 600 ./deploy_key
ssh-add ./deploy_key
git clone git@github.com:pimatic-ci/sqlite3.git repo
cp -R ./node_modules/sqlite3/ repo/
cd repo
git commit -a -m "new build"
git push