#!/bin/bash

# Build a lua container

LUAROCKS_VERSION=3.3.1
LUAROCKS_GH="https://luarocks.github.io/luarocks/releases/luarocks-${LUAROCKS_VERSION}.tar.gz"
LUAROCKS_GET="wget $LUAROCKS_GH -O - | tar -xzf -"

packages="lua5.3 liblua5.3-dev wget unzip make"

ctr=$(buildah from debian:bullseye)

buildah run $ctr apt-get update
buildah run $ctr apt-get -y install ${packages}
buildah run $ctr apt-get clean

buildah run $ctr -- bash -c "cd / && $LUAROCKS_GET"
buildah run $ctr -- bash -c "cd /luarocks-${LUAROCKS_VERSION} && ./configure && make && make install"

buildah commit $ctr lua:latest
buildah rm $ctr
