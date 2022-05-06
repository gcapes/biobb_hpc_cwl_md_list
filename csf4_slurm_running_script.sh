#!/bin/bash
#SBATCH --job-name="toil_wf"
#SBATCH --workdir=.
#SBATCH --output=toil_wf_%j.out
#SBATCH --error=toil_wf_%j.err
#SBATCH --ntasks=1
#SBATCH --time=02:00:00

# This is a batch script for running Toil as a serial job, which will then submit
# further batch jobs for the compute work.

# Before submitting this script, make sure that you have loaded the required modules
# and that the following environment variables set and exported.

export TMPDIR=~/scratch/tmp # This needs to be on a shared disk accessible by all compute nodes
mkdir -p $TMPDIR
# TOIL_SLURM_ARGS - these will be slurm settings used for compute jobs, for example:
export TOIL_SLURM_ARGS=
export CWL_SINGULARITY_CACHE=~/scratch/docker_store
mkdir -p $CWL_SINGULARITY_CACHE
export SINGULARITY_CACHEDIR=~/scratch/.singularity

# Toil should be loaded from a python virtual environment. It is expected that the BioBB tools, and 
# GROMACS executables, will be provided via docker containers (loaded via singularity).
# If this isn't the case then these should be loaded either from the modules, or via
# the python environment.

# Flags for running slurm and Toil. Note that the defaultCores sets the usage for the jobs,
# which should fit within the nodes selected information in TOIL_SLURM_ARGS.
SLURM_FLAGS="--dont_allocate_mem --batchSystem slurm --defaultCores 6"

# Flags for general Toil usage - on HPC we generally need to disable caching and use singularity.
# Create the workdir directory beforehand.
TOIL_FLAGS="--workDir ./workdir --disableCaching --singularity --disableProgress"

# Flags for gathering data for stats analysis (these are stored in the cache directory)
# Create the jobstore base directory beforehand, and adapt the naming convention for the
# individual jobstore directories as you need.  
STAT_FLAGS="--stats --jobStore ./jobstore/test_$(date "+%Y-%m-%d_%H-%M")"

toil-cwl-runner $TOIL_FLAGS $STAT_FLAGS $SLURM_FLAGS md_list.cwl md_list_input_descriptions.yml
