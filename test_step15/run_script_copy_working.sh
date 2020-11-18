#!/bin/bash

# ensure that cwl conda environment is loaded
#
# conda activate cwl

rm -rf lys2.pdb

cwl-runner --copy-outputs md_step15_only.cwl md_step15_input_descriptions.yml