#!/bin/bash
#
# This is a shell script for running Toil on the login nodes on CSF3, using SGE.

# Before running this script, make sure that you have loaded the required modules
# and that the following environment variables are set and exported (or set in this script).

# Speed up qacct:
alias qacct='qacct -f <(tail -n 1000 $SGE_ROOT/$SGE_CELL/common/accounting)'

# TMPDIR - this needs to be one a shared disk accessible by all compute and login nodes
# Set SGE arguments for the compute jobs
export TOIL_GRIDENGINE_ARGS="-l short"
# Set the parallel environment for running jobs:
export TOIL_GRIDENGINE_PE=smp.pe
# Set the download location for singularity, which should be on a shared disk.
export CWL_SINGULARITY_CACHE=~/scratch/bioexcel/docker_store
# Set the singularity working directory, which should be on a shared disk.
export SINGULARITY_CACHEDIR=~/scratch/bioexcel/.singularity
mkdir -p $CWL_SINGULARITY_CACHE

# Flags for running SGE and Toil. Note that the defaultCores sets the usage for the jobs,
# which should fit within the nodes selected information in TOIL_SLURM_ARGS.
SGE_FLAGS="--batchSystem grid_engine --defaultCores 6"

# Flags for general Toil usage - on HPC we generally need to disable caching and use singularity.
TOIL_FLAGS="--disableCaching --singularity"

# Flags for gathering data for stats analysis (these are stored in the cache directory)
# Create the jobstore base directory beforehand, and adapt the naming convention for the
# individual jobstore directories as you need.  
JOBSTORE=jobstore_normalq
STAT_FLAGS="--stats --jobStore $JOBSTORE"

toil-cwl-runner $TOIL_FLAGS $STAT_FLAGS $SGE_FLAGS md_list.cwl md_list_input_descriptions.yml

