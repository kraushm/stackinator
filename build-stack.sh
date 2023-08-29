#!/bin/bash

# source /dev/shm/kraushm/miniconda3/bin/activate

export TAG=w_and_c
# set the mount point - development/testing versions are installed directly on
# $SCRATCH. The deployment version at /mch-environment/vX the build has to be
# rerun with MOUNT set appropriately
export MOUNT=/user-environment

export CACHE_PATH=$SCRATCH/uenv-cache/

mkdir work
cd work
work=$(pwd)

echo
echo === getting stackinator
echo
git clone --quiet https://github.com/eth-cscs/stackinator.git
(cd stackinator; ./bootstrap.sh)
export PATH=$work/stackinator/bin:$PATH

echo
echo === getting recipe
echo
git clone --quiet https://github.com/kraushm/alps-spack-stacks.git
(cd alps-spack-stacks && git checkout $TAG)
recipes=$work/alps-spack-stacks/recipes

echo
echo === getting cluster configuration
echo
git clone --quiet https://github.com/kraushm/alps-cluster-config.git
(cd alps-cluster-config && git checkout $TAG)
systems=$work/alps-cluster-config

# Note, you will need to have created a key:
# https://eth-cscs.github.io/stackinator/build-caches/
echo "root: $CACHE_PATH" > cache.yaml
echo "key: $CACHE_PATH/../.keys/push-key.gpg" >> cache.yaml

echo
echo === configuring the build stack
echo
stack-config -b /dev/shm/kraushm/build -r $recipes/w_and_c/a100 -s $systems/w_and_c -c ./cache.yaml -m $MOUNT
