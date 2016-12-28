#!/usr/bin/env bash

pushd /opt/madcore/
    echo "CORE: $(git describe --tags)"
popd

pushd /opt/plugins/
    echo "PLUGINS: $(git describe --tags)"
popd

git clone https://github.com/madcore-ai/cloudformation.git
pushd ./cloudformation
    echo "CLOUDFORMAION: $(git describe --tags)"
popd

git clone https://github.com/madcore-ai/containers.git
pushd ./containers
    echo "CONTAINERS: $(git describe --tags)"
popd
