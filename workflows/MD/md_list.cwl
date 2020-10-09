#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: Example of setting up a simulation system
doc: |
  CWL version of the md_list.cwl workflow for HPC.

inputs:
  step1_pdb_file: string
  step2_editconf_config: string
  step4_gppion_config: string
  step5_genion_config: string
  step6_gppmin_config: string
  step8_make_ndx_config: string
  
  step11_gppnvt_config: string
  step14_gppnpt_config: string
  step17_gppmd_config: string

outputs:
  trr:
    label: Trajectories - Raw trajectory
    doc: |
      Raw trajectory from the free simulation step
    type: File
    outputSource: step14_mdrun_md/output_trr_file
    
  gro:
    label: Structures - Raw structure
    doc: |
      Raw structure from the free simulation step.
    type: File
    outputSource: step14_mdrun_md/output_gro_file

  cpt:
    label: Checkpoint file
    doc: |
      GROMACS portable checkpoint file, allowing to restore (continue) the
      simulation from the last step of the setup process.
    type: File
    outputSource: step14_mdrun_md/output_cpt_file

  tpr:
    label: Topologies GROMACS portable binary run
    doc: |
      GROMACS portable binary run input file, containing the starting structure
      of the simulation, the molecular topology and all the simulation parameters.
    type: File
    outputSource: step13_grompp_md/output_tpr_file

  top:
    label: GROMACS topology file
    doc: |
      GROMACS topology file, containing the molecular topology in an ASCII
      readable format.
    type: File
    outputSource: step5_genion/output_top_zip_file
        

steps:
  step1_pdb2gmx:
    label: Create Protein System Topology
    run: biobb/biobb_adapters/cwl/biobb_md/gromacs/pdb2gmx.cwl
    in:
      input_pdb_path: step1_pdb_file
    out: [output_gro_file, output_top_zip_file]

  step2_editconf:
    label: Create Solvent Box
    run: biobb/biobb_adapters/cwl/biobb_md/gromacs/editconf.cwl
    in:
      input_gro_path: step1_pdb2gmx/output_gro_file
    out: [output_gro_file]

  step3_solvate:
    label: Fill the Box with Water Molecules
    run: biobb/biobb_adapters/cwl/biobb_md/gromacs/solvate.cwl
    in:
      input_solute_gro_path: step2_editconf/output_gro_file
      input_top_zip_path: step1_pdb2gmx/output_top_zip_file
    out: [output_gro_file, output_top_zip_file]

  step4_grompp_genion:
    label: Add Ions - part 1
    run: biobb/biobb_adapters/cwl/biobb_md/gromacs/grompp.cwl
    in:
      config: step4_gppion_config
      input_gro_path: step3_solvate/output_gro_file
      input_top_zip_path: step3_solvate/output_top_zip_file
    out: [output_tpr_file]

  step5_genion:
    label: Add Ions - part 2
    run: biobb/biobb_adapters/cwl/biobb_md/gromacs/genion.cwl
    in:
      config: step5_genion_config
      input_tpr_path: step4_grompp_genion/output_tpr_file
      input_top_zip_path: step3_solvate/output_top_zip_file
    out: [output_gro_file, output_top_zip_file]

  step6_grompp_min:
    label: Energetically Minimize the System - part 1
    run: biobb/biobb_adapters/cwl/biobb_md/gromacs/grompp.cwl
    in:
      config: step6_gppmin_config
      input_gro_path: step5_genion/output_gro_file
      input_top_zip_path: step5_genion/output_top_zip_file
    out: [output_tpr_file]

  step7_mdrun_min:
    label: Energetically Minimize the System - part 2
    run: biobb/biobb_adapters/cwl/biobb_md/gromacs/mdrun.cwl
    in:
      input_tpr_path: step6_grompp_min/output_tpr_file
    out: [output_trr_file, output_gro_file, output_edr_file, output_log_file]

  step8_make_ndx:
    label: Generate GROMACS index file
    run:
    in:
      config: step8_make_ndx_config
      input_structure_path: step7_mdrun_min/output_gro_file
    out: [output_ndx_path] 


  step9_grompp_nvt:
    label: Equilibrate the System (NVT) - part 1
    run: biobb/biobb_adapters/cwl/biobb_md/gromacs/grompp.cwl
    in:
      config: step9_grompp_nvt_config
      input_gro_path: step7_mdrun_min/output_gro_file
      input_top_zip_path: step5_genion/output_top_zip_file
      input_ndx_path: step8_make_ndx/output_ndx_path
    out: [output_tpr_file]

  step10_mdrun_nvt:
    label: Equilibrate the System (NVT) - part 2
    run: biobb/biobb_adapters/cwl/biobb_md/gromacs/mdrun.cwl
    in:
      input_tpr_path: step9_grompp_nvt/output_tpr_file
    out: [output_trr_file, output_gro_file, output_edr_file, output_log_file, output_cpt_file]


  step11_grompp_npt:
    label: Equilibrate the System (NPT) - part 1
    run: biobb/biobb_adapters/cwl/biobb_md/gromacs/grompp.cwl
    in:
      config: step11_grompp_npt_config
      input_gro_path: step10_mdrun_nvt/output_gro_file
      input_top_zip_path: step5_genion/output_top_zip_file
      input_ndx_path: step8_make_ndx/output_ndx_path
      input_cpt_path:  step10_mdrun_nvt/output_cpt_file
    out: [output_tpr_file]

  step12_mdrun_npt:
    label: Equilibrate the System (NPT) - part 2
    run: biobb/biobb_adapters/cwl/biobb_md/gromacs/mdrun.cwl
    in:
      input_tpr_path: step11_grompp_npt/output_tpr_file
    out: [output_trr_file, output_gro_file, output_edr_file, output_log_file, output_cpt_file]


  step13_grompp_md:
    label: Free Molecular Dynamics Simulation - part 1
    run: biobb/biobb_adapters/cwl/biobb_md/gromacs/grompp.cwl
    in:
      config: step13_gropp_md_config
      input_gro_path: step12_mdrun_npt/output_gro_file
      input_top_zip_path: step5_genion/output_top_zip_file
      input_ndx_path: step8_make_ndx/output_ndx_path
      input_cpt_path:  step12_mdrun_npt/output_cpt_file
    out: [output_tpr_file]

  step14_mdrun_md:
    label: Free Molecular Dynamics Simulation - part 2
    run: biobb/biobb_adapters/cwl/biobb_md/gromacs/mdrun.cwl
    in:
      input_tpr_path: step13_grompp_md/output_tpr_file
    out: [output_trr_file, output_gro_file, output_edr_file, output_log_file, output_cpt_file]

