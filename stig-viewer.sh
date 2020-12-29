#!/bin/bash

CTR=$(buildah from openjdk:11)

STIG_ZIP="U_STIGViewer_2-11_Linux.zip"
STIG_ZIP_URL="https://dl.dod.cyber.mil/wp-content/uploads/stigs/zip/$STIG_ZIP"
PKGS=(libx11-6 libgtk-3-0)

buildah run $CTR mkdir /stig

# just copy it for now 
#buildah run $CTR wget -P /stig "$STIG_ZIP_URL"
buildah add $CTR "$HOME/temp/stig/$STIG_ZIP" "/stig/$STIG_ZIP"

buildah run $CTR sh -c "cd stig && unzip /stig/$STIG_ZIP"
buildah run $CTR rm "/stig/$STIG_ZIP"

buildah run $CTR apt-get update
buildah run $CTR apt-get install -y ${PKGS[@]}
buildah run $CTR apt-get clean

buildah config --entrypoint /stig/bin/STIGViewer $CTR

buildah commit $CTR stig-viewer:latest
buildah rm $CTR
