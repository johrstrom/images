#!/bin/env bash

function extra_gems(){
  gems=""

  while read line 
  do
    gems="$gems $line"
  done < extra_gems

  echo $gems
}

ctr=$(buildah from debian:bullseye)

deps="ruby ruby-dev make g++ zlib1g-dev libsqlite3-dev libffi-dev git nodejs npm shellcheck"
#base_gems="rake:12.3.3 rake:13.0.0 bundler:1.13.7 bundler:1.16.1 bundler:1.17.3"

# I can just mount my own ~/.gem file 
# extra_gems=$(extra_gems)

install_cmd="apt-get install -y"
update_cmd="bash -c 'apt-get update && apt-get upgrade'"

buildah run "$ctr" bash -c "apt-get update -y && apt-get upgrade -y"

buildah run $ctr -- groupadd -g $(id -g) $USER
buildah run $ctr -- useradd -u $(id -u) --create-home --gid $USER $USER
buildah run $ctr -- usermod -a -G sudo $USER
buildah run $ctr -- passwd --delete $USER
buildah run $ctr -- passwd --delete root

# installations
buildah run "$ctr" ${install_cmd} ${deps}

#buildah run "$ctr" gem install ${base_gems} ${extra_gems}

buildah commit "$ctr" ood:test
buildah rm "$ctr"
