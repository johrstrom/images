#!/bin/bash

# Build a golang container with some extra header libraries

ctr=$(buildah from debian:buster)

buildah run $ctr apt-get -y update 
buildah run $ctr apt-get -y install hub

buildah run $ctr -- groupadd -g $(id -g) $USER
buildah run $ctr -- useradd -u $(id -u) --create-home --gid $USER $USER
buildah run $ctr -- usermod -a -G sudo $USER
buildah run $ctr -- passwd --delete $USER
buildah run $ctr -- passwd --delete root

buildah commit $ctr hub:latest
buildah rm $ctr
