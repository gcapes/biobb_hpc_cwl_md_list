#!/usr/bin/env cwl-runner

cwlVersion: v1.0
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
#  trr_array:
#    label: Trajectories - Raw trajectory
#    type:
#      type: array
#      items: File
#    outputSource: launch_workflow/trr
#    
#  gro_array:
#    label: Structures - Raw structure
#    doc: |
#      Raw structure from the free simulation step.
#    type:
#      type: array
#      items: File
#    outputSource: launch_workflow/gro
#
#  cpt_array:
#    label: Checkpoint file
#    doc: |
#      GROMACS portable checkpoint file, allowing to restore (continue) the
#      simulation from the last step of the setup process.
#    type:
#      type: array
#      items: File
#    outputSource: launch_workflow/cpt

#  tpr_array:
#    label: Topologies GROMACS portable binary run
#    doc: |
#      GROMACS portable binary run input file, containing the starting structure
#      of the simulation, the molecular topology and all the simulation parameters.
#    type:
#      type: array
#      items: File
#    outputSource: launch_workflow/tpr

  top_array:
    label: GROMACS topology files
    doc: |
      GROMACS topology file, containing the molecular topology in an ASCII
      readable format.
    type:
      type: array
      items: File
    outputSource: launch_workflow/top

  
steps:
  launch_workflow:
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
    out: [top]


