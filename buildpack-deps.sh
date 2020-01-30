#!/bin/sh

IMG="buildpack-deps:bullseye"
extra_packages=('libdevmapper-dev')

ctr=$(buildah from "$IMG")

buildah run $ctr apt-get update
buildah run $ctr apt-get install -y ${extra_packages[@]}

buildah commit "$ctr" "buildpack-deps:jeff"
buildah rm "$ctr"
