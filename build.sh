#!/bin/bash

module purge 2> /dev/null
module load LUMI/22.08 partition/C
module load lumi-container-wrapper

# Use the NetLogo container as the parent container
CONFIG_YAML=config.yaml
cp $(dirname `which conda-containerize`)/../default_config/config.yaml $CONFIG_YAML
sed -i "s|container_src: .*|container_src: 'docker-archive://$PWD/netlogo_6.3.0.tar'|g" $CONFIG_YAML

export CW_GLOBAL_YAML=$CONFIG_YAML

PREFIX=beehave_env

rm -rf $PREFIX
mkdir $PREFIX
conda-containerize new --mamba --prefix $PREFIX --post-install post-install.sh conda_env.yaml
