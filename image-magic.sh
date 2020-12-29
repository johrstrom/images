#!/bin/bash

packages=('imagemagick')

ctr=$(buildah from alpine:3)

buildah run $ctr apk add ${packages}

buildah commit $ctr image-magic:latest
buildah rm $ctr

