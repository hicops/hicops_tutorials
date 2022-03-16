# <img src="https://user-images.githubusercontent.com/14217455/97767279-84a86100-1af1-11eb-92db-52edf709cb1f.png" width="100" valign="middle" alt="HiCOPS"/> hicops-tutorials
Walk-through tutorials for [HiCOPS](https://github.com/hicops/hicops) ([Docs](https://hicops.github.io)) installation, instrumentation, integration and execution.

# Setup

## Environment Setup (Supercomputer)
Most supercomputers come with default packages compiled for their specfic system setting. To ensure that we use only those, make sure to first edit the `packages.yaml` file and provide the available MPI and any other available. e.g. python, curl, ncurses etc. modules (from Lmod). You can see your system modules by running:

```bash
module avail
```

**For example**: If your system has the `openmpi/4.0.4` module available, add an entry for openmpi in `packages.yaml` right under the `mpi` entry like this:

```yaml
packages:
  mpi:
    buildable: False
  openmpi:
    buildable: False # this package will never be reinstalled and taken from the system module
    externals:
    - spec: "openmpi@4.0.4"
      modules:
      - openmpi/4.0.4
```

**Note:** Setting `buildable: False` is needed for `MPI`-related packages, `curl` and in some cases `CUDA`-related packages.


**Note:** Adding all available basic system packages will significantly reduce the installation times. The following packages (and more) are recommended to be added to `packages.yaml` if available: 

```bash
mpi, curl, mpi4py, mpip, cuda, ncurses, python, cuda, py-pandas, py-matplotlib, py-numpy, libssl, boost, bison, perl, xz, zlib
```



Run the following bash script to install and load the required packages on a supercomputer. 

```bash
source ./setup-env-hpc.sh [WORKING_DIR] [SPACK_ENV_NAME] [optional COMPILER: e.g. gcc@8.4.0, gcc@10.2.0, intel@10.2]]
```
Run without parameters to see the help.

***Note:*** Once the environment is setup, you can simply activate it (for example in a new shell) instead of reinstalling everything again by running:

```bash
source ./activate.sh [WORKING_DIR] [SPACK_ENV_NAME]
```

## Environment Setup (non-Supercomputer)
Run the following bash script to install and load the required packages.

```bash
source ./setup-env.sh [WORKING_DIR] [SPACK_ENV_NAME] [optional COMPILER: e.g. gcc@8.4.0, gcc@10.2.0, intel@10.2]]
```
Run without parameters to see the help.

***Note:*** Once the environment is setup, you can simply activate it (for example in a new shell) instead of reinstalling everything again by running:

```bash
source ./activate.sh [WORKING_DIR] [SPACK_ENV_NAME]
```

## Installation
Run the following bash script after setting up (or activation) to install the timemory and hicops.

```bash
source install.sh [WORKING_DIR] [SPACK_ENV_NAME]
```
Run without parameters to see the help. This script will install timemory and hicops (with and without instrumentation support).

# Examples
TBA
