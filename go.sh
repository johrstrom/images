#!/bin/bash

# Build a golang container with some extra header libraries

packages="libgpgme-dev libseccomp-dev libassuan-dev libgpg-error-dev"

# golang:bullseye doesn't exist yet, cp golang:buster Dockerfile and
# user a different 'from'
ctr=$(buildah from golang:bullseye)

buildah run $ctr apt-get update
buildah run $ctr apt-get -y install ${packages}
buildah run $ctr apt-get clean

buildah commit $ctr go:extra
buildah rm $ctr

