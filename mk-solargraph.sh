#!/bin/sh

ctr=$(buildah from ood-dev:latest)

buildah copy $ctr solargraph /solargraph
#buildah config --entrypoint /solargraph $ctr

buildah commit $ctr solargraph:latest
buildah rm $ctr
