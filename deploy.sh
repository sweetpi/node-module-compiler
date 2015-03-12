#!/bin/sh -e
chmod 600 ./deploy_key
eval "$(ssh-agent)"
ssh-add ./deploy_key
git config --global user.email "oliverschneider89+pimatic-ci@gmail.com"
git config --global user.name "pimatic-ci"
git clone git@github.com:pimatic-ci/${MODULE}.git repo || ./createRepo.sh
cd repo
PLATFORM='linux'
ARCH='armhf'
NODE_ABI='11'
BRANCH="node-${NODE_ABI}-${ARCH}-${PLATFORM}"
git checkout ${BRANCH} || git checkout -b ${BRANCH} 
rm -r -f ./*
cp -R ../node_modules/${MODULE}/* ./
cp -R ../node_modules/${MODULE}/.js ./
git add -A .
git diff
VERSION=`getversion`
TAG="${BRANCH}-${VERSION}"
git commit -a -m "Build for ${PLATFORM} node ${NODE_ABI} ${ARCH} ${VERSION}"
git tag -a ${TAG} -m "${TAG}"
git push origin ${BRANCH}
git push origin ${TAG}