#!/bin/sh

IMG="buildpack-deps:bullseye"
extra_packages=('libdevmapper-dev' 'libcap-dev' 'libseccomp-dev' 'ccache' 'autopoint')
extra_packages+=('yelp-tools' 'python-gi-dev' 'libatspi2.0-dev' 'libatk-bridge2.0')

ctr=$(buildah from "$IMG")

buildah run $ctr apt-get update
buildah run $ctr apt-get install -y ${extra_packages[@]}

buildah commit "$ctr" "buildpack-deps:jeff"
buildah rm "$ctr"
