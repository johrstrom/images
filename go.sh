#!/bin/bash

# Build a golang container with some extra header libraries

packages="libgpgme-dev libseccomp-dev libassuan-dev libgpg-error-dev"
packages="$packages libstdc++-8-dev libbtrfs-dev libdevmapper-dev"

ctr=$(buildah from golang:1.13-buster)

buildah run $ctr apt-get update
buildah run $ctr apt-get -y install ${packages}
buildah run $ctr apt-get clean

buildah commit $ctr go:extra
buildah rm $ctr

