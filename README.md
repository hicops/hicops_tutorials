# <img src="https://user-images.githubusercontent.com/14217455/97766105-66d7fd80-1aeb-11eb-9741-9938aec1b8d7.jpg" width="75" valign="middle" alt="HiCOPS"/> hicops-tutorials
Walk-through tutorials for [HiCOPS](https://github.com/hicops/hicops) ([Docs](https://hicops.github.io)) installation, instrumentation, integration and execution.

# Setup

## Environment Setup
Run the following bash script to install and load the required packages.

```bash
source ./setup-env.sh [WORKING_DIR] [SPACK_ENV_NAME]
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
