#!/bin/bash

# ensure that cwl conda environment is loaded
#
# conda activate toilcwl

rm -rf lys2.pdb

toil-cwl-runner --enable-dev --noMoveExports md_step15_only_toil.cwl md_step15_input_descriptions.yml 