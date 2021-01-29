# BioExcel Building Blocks (BioBB) High Performance Computing (HPC) Common Workflow Language (CWL) repository: md\_list workflow

This repository is part of a series of repositories mirroring the workflow and launchers in [https://github.com/bioexcel/biobb_hpc_workflows](https://github.com/bioexcel/biobb_hpc_workflows).

Below the workflow is briefly described, followed by installation instructions, and guidance on running the workflow with the two workflow engines it has been tested on (CWLtool and TOIL).

## md\_list / md\_launch

The `md_list` workflow performs a molecular dynamics simulation on a given structure listed in the YAML properties file.

The `md_launch` workflow will run the `md_list` workflow multiple times (using scatter), passing it structures from a list defined in the YAML properties file.

## Getting Started

### Requirements

* [CWLtool](https://github.com/common-workflow-language/cwltool) or [Toil](https://toil.ucsc-cgl.org/)
* [Docker](https://www.docker.com/) or [Singularity](https://sylabs.io/)
* [Git](https://git-scm.com/)
* [Git Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)

If you are working on your own machine then instructions for installing **Git** and **Docker** are given on their websites. You will be able to use either CWLtool (which is the reference implementation of CWL) or toil.

If you are working on HPC then you will need **Singularity** and **Toil** rather than Docker and CWLtool. Git and Singularity should already be installed, while the installation of Toil (if this is not installed already) will be covered below.

Version requirements:
* The workflow engine should support CWL standard 1.2 or more recent (versions tested: 1.2.0-dev5 in toil; 1.2 in CWLtool)

### Setup

These workflows make use of the BioBB libraries, which are installed using `git submodules`. This requires that you clone this repository, rather than downloading a zip archive (as the git hooks are needed for this to work):
```
git clone --recurse-submodules https://github.com/douglowe/biobb_hpc_cwl_md_list.git
```

#### CWLtool

This can be installed via `conda`, with the command:
```
conda env create -f install/env_cwlrunner.yml
```
To install a javascript interpreter (if you do not already have one on your system) use:
```
conda env create -f install/env_cwlrunner_nodejs.cwl
```


#### TOIL

This can be installed using `conda`, with the command:
```
conda env create -f install/env_toil.yml
```
To install a javascript interpreter (if you do not already have one on your system) use:
```
conda env create -f install/env_toil_nodejs.cwl
```


### Running the Workflows





## Copyright & Licensing

This software has been developed in the [MMB group](http://mmb.irbbarcelona.org/www/) at the [BSC](https://www.bsc.es/) & [IRB](https://www.irbbarcelona.org/en); and in the [eScience Lab](https://esciencelab.org.uk/) and [Research IT](https://research-it.manchester.ac.uk/) groups at the [University of Manchester](https://www.manchester.ac.uk/) for the European BioExcel, funded by the European Commission (EU H2020 823830, EU H2020 675728).

* (c) 2015-2020 [Barcelona Supercomputing Center](https://www.bsc.es/)
* (c) 2015-2020 [Institute for Research in Biomedicine](https://www.irbbarcelona.org/)
* (c) 2020 [University of Manchester](https://www.manchester.ac.uk/)


Licensed under the
[Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0), see the file LICENSE for details.
