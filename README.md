# hicops-tutorials
Walk-through tutorials for [HiCOPS](https://github.com/hicops/hicops) ([Docs](https://hicops.github.io)) installation, instrumentation, integration and execution.

# Setup

## Environment Setup
Run the following bash script to install and load the required packages.

```bash
source ./setup-env.sh [WORKING_DIR] [SPACK_ENV_NAME]
```
Run without parameters to see the help.

***Note:*** If the environment is already setup (for example in a new shell), simply load the spack environment using the following commands:

```
# set these variables to the ones used in environment setup
export WORKING_DIR=<WORKING_DIR>
export SPACK_ENV_NAME=<SPACK_ENV_NAME>

# add spack to PATH
export PATH=${WORKING_DIR}/spack/bin:$PATH
. ${WORKING_DIR}/spack/share/spack/setup-env.sh

# activate the spack env
spack env activate ${SPACK_ENV_NAME}

# export MPLCONFIGDIR env var
mkdir -p $HOME/mplconfigdir
export MPLCONFIGDIR=$HOME/mplconfigdir
```

## Build
Run the following bash script after running the `setup-env.sh` to install the timemory and hicops.

```bash
source install.sh [WORKING_DIR]
```
Run without paramters to see the help.
This script will install timemory and hicops (with and without instrumentation support).

# Examples
TBA 
