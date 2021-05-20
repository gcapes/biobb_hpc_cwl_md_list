#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: Workflow

requirements:
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}

inputs:
  step1_pdb_files:
    type:
      type: array
      items: File
  step2_editconf_config: string
  step4_grompp_genion_config: string
  step5_genion_config: string
  step6_grompp_min_config: string
  step8_make_ndx_config: string
  
  step9_grompp_nvt_config: string
  step11_grompp_npt_config: string
  step13_grompp_md_config: string
  step14_mdrun_md_config: string

outputs:
  top_dir:
    label: collected simulation output data
    doc: |
      Collection of output directories returned by the md_list.cwl workflows.
    type:
      type: array
      items: Directory
    outputSource: launch_workflow/dir

  
steps:
  launch_workflow:
    doc: |
      Calls the local md_list.cwl workflow, scattering over the list of molecular input
      files (step1_pdb_files). One input file will be passed to each instance of the 
      workflow. All other input configuration strings are passed unchanged to each instance.
      
      Each md_list.cwl workflow will return a directory containing the output files defined
      within the workflow. Each directory returned will be named after the molecular input 
      file passed to that workflow.
    run: md_list.cwl
    scatter: step1_pdb_file
    in:
      step1_pdb_file: step1_pdb_files
      step2_editconf_config: step2_editconf_config
      step4_grompp_genion_config: step4_grompp_genion_config
      step5_genion_config: step5_genion_config
      step6_grompp_min_config: step6_grompp_min_config
      step8_make_ndx_config: step8_make_ndx_config
      step9_grompp_nvt_config: step9_grompp_nvt_config
      step11_grompp_npt_config: step11_grompp_npt_config
      step13_grompp_md_config: step13_grompp_md_config
      step14_mdrun_md_config: step14_mdrun_md_config
    out: [dir]


