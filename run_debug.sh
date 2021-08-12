#!/bin/bash

# ensure that cwl conda environment is loaded
#
# conda activate cwl


toil-cwl-runner --jobStore jobstores/test_$(date "+%Y-%m-%d_%H-%M") \
                --logDebug --stats --debugWorker \
                md_list_reduced.cwl md_list_input_descriptions.yml 
