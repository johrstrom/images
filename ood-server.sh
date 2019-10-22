#!/bin/bash

ctr=$(buildah from ohiosupercomputer/ood:latest) 


HTTPD_DB="/opt/rh/httpd24/root/etc/httpd/.htpasswd"

IMG="ood:dev"

if command -v buildah >/dev/null 2>&1; then
  buildah run $ctr -- userdel ood
  buildah run $ctr -- groupadd $USER
  buildah run $ctr -- useradd -u $(id -u) --create-home --gid $USER $USER
  buildah run $ctr -- usermod -a -G wheel $USER
  buildah run $ctr -- passwd --delete $USER
  buildah run $ctr -- passwd --delete root
  buildah run $ctr -- scl enable httpd24 -- htpasswd -b -c $HTTPD_DB $USER $USER

  buildah commit $ctr "$IMG"
  buildah rm $ctr

elif command -v docker >/dev/null 2>&1; then
  cd ood-server
  export PRIMARY_GID=$(id -g)
  export UID
  envsubst < Dockerfile.template > Dockerfile
  
  docker build -t "$IMG" .

else
  echo "you need either buildah or docker install to build this image"
  exit 1
fi
