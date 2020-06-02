#!/bin/bash

ctr=$(buildah from fedora:31) 

dev_packages=(lsof sudo sqlite-devel gcc zlib-devel git make wget)
dev_packages+=(rpm-build gcc-c++ libseccomp vim-enhanced openssl-devel)
dev_packages+=(curl curl-devel selinux-policy-devel strace passwd)
dev_packages+=(podman buildah which findutils procps-ng nodejs)
dev_pacakges+=(ShellCheck)

# setup the user first bc the group rvm get's created as 1000 if it doesn't exist
#buildah run $ctr -- groupadd $USER
#buildah run $ctr -- useradd -u $(id -u) --create-home --gid $USER $USER
#buildah run $ctr -- usermod -a -G wheel $USER

# install everything
buildah run $ctr -- bash -c "curl -sL https://rpm.nodesource.com/setup_10.x | bash -"
buildah run $ctr -- dnf install -y ${dev_packages[@]}
buildah run $ctr -- bash -c "curl -sSL https://get.rvm.io | bash -"
buildah run $ctr -- /usr/local/rvm/bin/rvm install 2.5

# update and clean
buildah run $ctr -- dnf update -y
buildah run $ctr -- dnf clean all
buildah run $ctr -- rm -rf /usr/local/rvm/src
buildah run $ctr -- rm -rf /var/cache/dnf

# setup the user
#buildah run $ctr -- passwd --delete $USER
#buildah run $ctr -- passwd --delete root

# fix a few items
buildah run $ctr -- ln -s '/usr/lib64/libdevmapper.so.1.02' '/usr/lib64/libdevmapper.so.1.02.1'
buildah run $ctr -- sed -i -e 's|^#mount_program|mount_program|g' /etc/containers/storage.conf

buildah commit $ctr ood-build:fedora
buildah rm $ctr
