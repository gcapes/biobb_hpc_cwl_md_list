#!/usr/bin/env cwl-runner

cwlVersion: v1.2.0-dev5
class: Workflow
label: Example of setting up a simulation system
doc: |
  CWL version of the md_list.cwl workflow for HPC.

requirements:
  SubworkflowFeatureRequirement: {}
  MultipleInputFeatureRequirement: {}


inputs:
  step1_pdb_file: File
  step14_mdrun_md_output_trr_file: File?
  step14_mdrun_md_output_gro_file: File?
  step14_mdrun_md_output_cpt_file: File?
  step13_grompp_md_output_tpr_file: File?
  step5_genion_output_top_zip_file: File?

outputs:
  dir:
    label: whole workflow output
    doc: |
      outputs from the whole workflow, containing these optional files:
      step14_mdrun_md/output_trr_file:   Raw trajectory from the free simulation step
      step14_mdrun_md/output_gro_file:   Raw structure from the free simulation step.
      step14_mdrun_md/output_cpt_file:   GROMACS portable checkpoint file, allowing to restore (continue) the
                                         simulation from the last step of the setup process.
      step13_grompp_md/output_tpr_file:  GROMACS portable binary run input file, containing the starting structure
                                         of the simulation, the molecular topology and all the simulation parameters.
      step5_genion/output_top_zip_file:  GROMACS topology file, containing the molecular topology in an ASCII
                                         readable format.
    type: Directory
    outputSource: step15_gather_outputs/project_work_dir

steps:

  step15_gather_outputs:
    label: Archiving outputs to be returned to user
    in:
      external_project_file: step1_pdb_file
      external_files: 
        source:
          - step14_mdrun_md_output_trr_file
          - step14_mdrun_md_output_gro_file
          - step14_mdrun_md_output_cpt_file  # we have to run with v1.2.0, or this null value breaks the workflow!
          - step13_grompp_md_output_tpr_file 
          - step5_genion_output_top_zip_file
        linkMerge: merge_flattened
        pickValue: all_non_null # this is needed to avoid null values causing problems, but is only available from v1.2.0 onwards
    run: md_gather.cwl
    out: [project_work_dir]
    








