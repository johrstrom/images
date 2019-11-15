#!/bin/bash

ctr=$(buildah from centos:7) 

ruby="rh-ruby25"
dev_packages="sqlite-devel gcc $ruby-ruby-devel zlib-devel git make"
dev_packages="${dev_packages} rh-nodejs10 $ruby rpm-build gcc-c++" 
#dev_packages="${dev_packages} $ruby-rubygem-rake $ruby-rubygem-bundler"

rake_version="12.3.3"
bundler_version="1.13.7"
gem_dir="/opt/rh/$ruby/root/usr/share/gems"
gem_cmd="/opt/rh/$ruby/root/usr/bin/gem"
ld_cmd="LD_LIBRARY_PATH=/opt/rh/rh-nodejs10/root/usr/lib64:/opt/rh/rh-ruby25/root/usr/local/lib64:/opt/rh/rh-ruby25/root/usr/lib64"
gem_install="$ld_cmd $gem_cmd install --no-user-install --install-dir $gem_dir"

buildah run $ctr -- yum install -y centos-release-scl
buildah run $ctr -- yum-config-manager --enable rhel-server-rhscl-7-rpms

buildah run $ctr -- yum install -y ${dev_packages}
buildah run $ctr -- yum clean all

buildah run $ctr -- groupadd $USER
buildah run $ctr -- useradd -u $(id -u) --create-home --gid $USER $USER
buildah run $ctr -- usermod -a -G wheel $USER
buildah run $ctr -- passwd --delete $USER
buildah run $ctr -- passwd --delete root

buildah run $ctr -- bash -c "${gem_install} rake -v $rake_version"
buildah run $ctr -- bash -c "${gem_install} bundler -v $bundler_version"

# scl hack
buildah run $ctr -- mkdir -p /opt/ood/ondemand/
buildah run $ctr -- touch /opt/ood/ondemand/enable
buildah run $ctr -- mkdir -p /etc/scl/conf/
buildah run $ctr bash -c 'echo "/opt/ood" > /etc/scl/conf/ondemand'

buildah commit $ctr ood-build:latest
buildah rm $ctr
