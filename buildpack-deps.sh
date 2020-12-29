#!/bin/sh

IMG="buildpack-deps:bullseye"
LUAROCKS_VERSION=3.3.1
LUAROCKS_GH="https://luarocks.github.io/luarocks/releases/luarocks-${LUAROCKS_VERSION}.tar.gz"
LUAROCKS_GET="wget $LUAROCKS_GH -O - | tar -xzf -"
LUAROCKS_DIR="/luarocks-${LUAROCKS_VERSION}"

extra_packages=('libdevmapper-dev' 'libcap-dev' 'libseccomp-dev' 'ccache' 'autopoint')
extra_packages+=('yelp-tools' 'python-gi-dev' 'libatspi2.0-dev' 'libatk-bridge2.0')
extra_packages+=('lua5.3' 'liblua5.3-dev')

ctr=$(buildah from "$IMG")

buildah run $ctr apt-get update
buildah run $ctr apt-get install -y ${extra_packages[@]}
buildah run $ctr apt-get clean

# build and install luarocks
buildah run $ctr -- bash -c "cd / && $LUAROCKS_GET"
buildah run $ctr -- bash -c "cd $LUAROCKS_DIR && ./configure && make && make install"
buildah run $ctr -- rm -rf $LUAROCKS_DIR

buildah commit "$ctr" "buildpack-deps:jeff"
buildah rm "$ctr"
