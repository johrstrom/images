#!/bin/sh
#
# Make an image that you can test ansible playbooks against
#

if [ -z "$1" ]; then
  echo "you must specify \$1"
  exit 1
fi

OS=$1

if [ "$OS" = "ubuntu" ]; then
  IMG="ubuntu:18.04"
  PKGS="sudo python"
  INSTALL_CMD="apt-get update && apt-get install -y ${PKGS}"
elif [ "$OS" = "fedora" ]; then
 IMG="fedora:30"
 PKGS="sudo python"
 INSTALL_CMD="dnf install -y ${PKGS}"
elif [ "$OS" = "debian" ]; then
  IMG="debian:buster"
  PKGS="sudo python"
  INSTALL_CMD="apt-get update && apt-get install -y ${PKGS}"
elif [ "$OS" = "centos" ]; then
  IMG="centos:7"
  PKGS="sudo"
  INSTALL_CMD="yum install -y ${PKGS}"
else
  echo "$OS not recognized as an os"
  exit 1
fi

ctr=$(buildah from "$IMG")

# shellcheck disable=SC2086
buildah run "$ctr" bash -c "${INSTALL_CMD}"

buildah commit "$ctr" "ansible-test:$OS"
buildah rm "$ctr"
