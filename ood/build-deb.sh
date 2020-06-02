#!/bin/bash

ctr=$(buildah from ruby:2.5)

init_packages=(curl)
packages=(nodejs buildah podman npm sudo fuse-overlayfs)

buildah_deb="http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_10/ /"
src_list="/etc/apt/sources.list.d"
ctr_src_list="$src_list/devel:kubic:libcontainers:stable.list"
rl_key="https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/Debian_10/Release.key"

# have to get curl first
buildah run $ctr -- apt-get update
buildah run $ctr -- apt-get install -y ${init_packages[@]}

# prep for buildah
buildah run $ctr -- mkdir -p $src_list
buildah run $ctr -- bash -c "echo 'deb $buildah_deb' > $ctr_src_list"
buildah run $ctr -- wget -nv $rl_key -O Release.key
buildah run $ctr -- bash -c "apt-key add - < Release.key"
buildah run $ctr -- rm Release.key
buildah run $ctr -- apt-get update -qq

buildah run $ctr -- apt-get -qq -y install ${packages[@]}

buildah run $ctr -- groupadd $USER
buildah run $ctr -- useradd -u $(id -u) --create-home --gid $USER $USER
buildah run $ctr -- usermod -a -G sudo $USER
buildah run $ctr -- passwd --delete $USER
buildah run $ctr -- passwd --delete root

buildah commit $ctr ood:build-deb
buildah rm $ctr
