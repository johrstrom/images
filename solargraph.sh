#!/bin/sh

ctr=$(buildah from ood-dev:latest)

buildah copy $ctr src/solargraph /solargraph

buildah commit $ctr solargraph:latest
buildah rm $ctr
