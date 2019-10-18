#!/bin/bash

ctr=$(buildah from ohiosupercomputer/ood:latest) 


HTTPD_DB="/opt/rh/httpd24/root/etc/httpd/.htpasswd"

buildah run $ctr -- userdel ood
buildah run $ctr -- groupadd $USER
buildah run $ctr -- useradd -u $(id -u) --create-home --gid $USER $USER
buildah run $ctr -- usermod -a -G wheel $USER
buildah run $ctr -- passwd --delete $USER
buildah run $ctr -- passwd --delete root
buildah run $ctr -- scl enable httpd24 -- htpasswd -b -c $HTTPD_DB $USER $USER

buildah commit $ctr ood:dev
buildah rm $ctr

