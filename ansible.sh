#!/bin/sh
#
# Make an image that you can run ansible with
#

ctr=$(buildah from python:3)

buildah run $ctr -- bash -c "groupadd $USER || true"
buildah run $ctr -- bash -c "useradd -u $(id -u) --create-home --gid $USER $USER"
#buildah run $ctr -- bash -c "usermod -a -G $SUDO_GRP $USER"
buildah run $ctr -- bash -c "passwd --delete $USER"
buildah run $ctr -- bash -c "passwd --delete root"

buildah commit "$ctr" "ansible:user"
buildah rm "$ctr"
