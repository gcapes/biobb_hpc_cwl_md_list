#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

requirements:
  SubworkflowFeatureRequirement: {}


inputs:
  step1_pdb_file: File?
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
  trr:
    label: Trajectories - Raw trajectory
    doc: |
      Raw trajectory from the free simulation step
    type: File
    outputSource: launch_workflow/trr
    
  gro:
    label: Structures - Raw structure
    doc: |
      Raw structure from the free simulation step.
    type: File
    outputSource: launch_workflow/gro

  cpt:
    label: Checkpoint file
    doc: |
      GROMACS portable checkpoint file, allowing to restore (continue) the
      simulation from the last step of the setup process.
    type: File
    outputSource: launch_workflow/cpt

  tpr:
    label: Topologies GROMACS portable binary run
    doc: |
      GROMACS portable binary run input file, containing the starting structure
      of the simulation, the molecular topology and all the simulation parameters.
    type: File
    outputSource: launch_workflow/tpr

  top:
    label: GROMACS topology file
    doc: |
      GROMACS topology file, containing the molecular topology in an ASCII
      readable format.
    type: File
    outputSource: launch_workflow/top


  
steps:
  launch_workflow:
    run: md_list.cwl
    in:
      step1_pdb_file: step1_pdb_file
      step2_editconf_config: step2_editconf_config
      step4_grompp_genion_config: step4_grompp_genion_config
      step5_genion_config: step5_genion_config
      step6_grompp_min_config: step6_grompp_min_config
      step8_make_ndx_config: step8_make_ndx_config
      step9_grompp_nvt_config: step9_grompp_nvt_config
      step11_grompp_npt_config: step11_grompp_npt_config
      step13_grompp_md_config: step13_grompp_md_config
      step14_mdrun_md_config: step14_mdrun_md_config
    out: [trr, gro, cpt, tpr, top]


