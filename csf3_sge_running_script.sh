#!/bin/bash
#
# This is a shell script for running Toil on the login nodes on CSF3, using SGE.

# Before running this script, make sure that you have loaded the required modules
# and that the following environment variables are set and exported (or set in this script).
#
# TMPDIR - this needs to be one a shared disk accessible by all compute and login nodes
# TOIL_GRIDENGINE_ARGS - this will contain SGE settings for the compute jobs, e.g.:
# TOIL_GRIDENGINE_ARGS=
# TOIL_GRIDENGINE_PE - this will give the parallel environment for running jobs, e.g.:
# TOIL_GRIDENGINE_PE=smp.pe
# CWL_SINGULARITY_CACHE - this is the download location for singularity, which should be on a shared disk  
# SINGULARITY_CACHEDIR - this is the singularity working directory, which should be on a shared disk

# Flags for running SGE and Toil. Note that the defaultCores sets the usage for the jobs,
# which should fit within the nodes selected information in TOIL_SLURM_ARGS.
SGE_FLAGS="--batchSystem slurm --defaultCores 6"

# Flags for general Toil usage - on HPC we generally need to disable caching and use singularity.
# Create the workdir directory beforehand.
TOIL_FLAGS="--workDir ./workdir --disableCaching --singularity"

# Flags for gathering data for stats analysis (these are stored in the cache directory)
# Create the jobstore base directory beforehand, and adapt the naming convention for the
# individual jobstore directories as you need.  
STAT_FLAGS="--stats --jobStore ./jobstore/test_$(date "+%Y-%m-%d_%H-%M")"

toil-cwl-runner $TOIL_FLAGS $STAT_FLAGS $SGE_FLAGS md_list.cwl md_list_input_descriptions.yml

