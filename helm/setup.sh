#!/usr/bin/env bash

mkdir -p /opt/bin
mkdir -p /tmp/helm
pushd /tmp/helm
    wget -O helm.tar.gz https://kubernetes-helm.storage.googleapis.com/helm-v2.1.0-linux-amd64.tar.gz
    tar -xf helm.tar.gz --strip-components=1
    cp helm /opt/bin
popd
chmod +x /opt/bin/helm
ln -s /opt/bin/helm /usr/local/bin/helm

# init helm by installing Tiller into the kub cluster
helm init
