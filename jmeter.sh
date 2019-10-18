#!/bin/sh

BASE_IMG="openjdk:8"
JMETER_TAR="apache-jmeter-5.1.1.tgz"
JMETER_DIR="/jmeter"
BIN_DIR="/jmeter/bin"

ctr=$(buildah from "$BASE_IMG")

buildah run $ctr groupadd -g $(id -g) $USER
buildah run $ctr useradd -u $(id -u) -g $USER $USER

buildah run $ctr mkdir "$JMETER_DIR"
buildah copy $ctr "src/$JMETER_TAR" /tmp
buildah run $ctr tar -xzf "/tmp/$JMETER_TAR" -C "$JMETER_DIR" --strip-components=1
buildah run $ctr rm "/tmp/$JMETER_TAR"
buildah run $ctr "$BIN_DIR/create-rmi-keystore.sh"
buildah run $ctr apt-get update
buildah run $ctr apt-get install -y libxext6 libxrender1 libxtst6
buildah run $ctr apt-get clean

buildah commit $ctr jmeter:latest
buildah rm $ctr
