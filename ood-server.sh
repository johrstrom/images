#!/bin/bash

if [[ "$1" == "debian" ]] || [[ "$1" == "ubuntu" ]]; then

 BASE_IMG="ood:$1"
 HTTPD_DB="/etc/apache2/.htpasswd"
 IMG="ood:$1"
 SUDO_GRP="sudo"
 HTPASSWD="/usr/bin/htpasswd"
else
  BASE_IMG="ohiosupercomputer/ood:latest"
  HTTPD_DB="/opt/rh/httpd24/root/etc/httpd/.htpasswd"
  IMG="ood:dev"
  SUDO_GRP="wheel"
  HTPASSWD="scl enable httpd24 -- htpasswd"
fi

ctr=$(buildah from $BASE_IMG)

# create a user inside the container, replacing ood and doing so with my (whoever $USER is)
# uid and gid.  Then deleting the passwords for continence.
if command -v buildah >/dev/null 2>&1; then
  buildah run $ctr -- bash -c "userdel ood || true"
  buildah run $ctr -- bash -c "groupdel ood || true"
  buildah run $ctr -- bash -c "groupadd $USER || true"
  buildah run $ctr -- bash -c "useradd -u $(id -u) --create-home --gid $USER $USER || true"
  buildah run $ctr -- bash -c "usermod -a -G $SUDO_GRP $USER"
  buildah run $ctr -- bash -c "passwd --delete $USER"
  buildah run $ctr -- bash -c "passwd --delete root"
  buildah run $ctr -- bash -c "echo '$USER ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers.d/$USER"
  buildah run $ctr -- bash -c "$HTPASSWD -b -c $HTTPD_DB $USER $USER"

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
