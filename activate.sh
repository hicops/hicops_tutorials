#!/bin/bash -le

#
# Activate an already setup development environment
# Copyrights(C) 2020 PCDS Laboratory
# Muhammad Haseeb and Fahad Saeed
# School of Computing and Information Sciences
# Florida International University (FIU), Miami, FL
# Email: {mhaseeb, fsaeed}@fiu.edu
#

# print usage
function usage() {
    echo "USAGE: activate.sh [WORKING_DIR] [SPACK_ENV_NAME]"
}

#
# Working directory
#
WDIR=$1
# if no working directory is provided
if [ -z "$1" ] ; then 
    echo "ERROR: Please provide the path to working directory"
    usage
    exit 0
fi

# convert relative path to abs path if needed
WDIR=$(cd "$WDIR" && pwd -P)

#
# Environment name
#
SPACK_ENV=$2
# if no environment name is provided
if [ -z "$2" ] ; then 
    echo "ERROR: Please provide a name for the spack environment"
    usage
    exit 0
fi

# add spack to PATH
export PATH=${WDIR}/spack/bin:$PATH
. ${WDIR}/spack/share/spack/setup-env.sh

# activate the spack env
spack env activate ${SPACK_ENV}

# export MPLCONFIGDIR env var
mkdir -p $HOME/mplconfigdir
export MPLCONFIGDIR=$HOME/mplconfigdir