#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: testing MD muts system
doc: |
  CWL impementation of the MD Mutations workflow
  Based on the files: 
          workflows/MD/md_muts_sets.py
          workflows/MD/md_muts_sets.yaml

inputs:
  step0_pdb_name: string
  step0_pdb_config: string
#  step1_pdb_name: File
  step1_mutate_config: string
  step2_pdb2gmx_config: string
  step3_editconf_config: string
  step5_grompp_genion_config: string
  step6_genion_config: string
  step7_grompp_min_config: string
  step9_grompp_nvt_config: string
  step11_grompp_npt_config: string
  step13_grompp_md_config: string
  step14_mdrun_md_config: string

outputs:
  pdb:
    type: File
    outputSource: step1_mutate/output_pdb_file
    



steps:

  step0_download:
    label: Fetch PDB Structure
    run: biobb/biobb_adapters/cwl/biobb_io/mmb_api/pdb.cwl
    in:
      output_pdb_path: step0_pdb_name
      config: step0_pdb_config
    out: [output_pdb_file]

  step1_mutate:
    label: setup input structure
    doc: |
      this will need to: (a) build mutation list; (b) correct Histidine residues to HIE
      (might require splitting this step?)
    run: biobb/biobb_adapters/cwl/biobb_model/model/mutate.cwl
    in:
      config: step1_mutate_config
      input_pdb_path: step0_download/output_pdb_file
    out: [output_pdb_file]

  step2_pdb2gmx:
    label: generate the topology
    run: biobb/biobb_adapters/cwl/biobb_md/gromacs/pdb2gmx.cwl
    in:
      config: step2_pdb2gmx_config
      input_pdb_path: step1_mutate/output_pdb_file
    out: [output_gro_file, output_top_zip_file]
    
  step3_editconf:
    label: create the solvent box
    run: biobb/biobb_adapters/cwl/biobb_md/gromacs/editconf.cwl
    in:
      config: step3_editconf_config
      input_gro_path: step2_pdb2gmx/output_gro_file
    out: [output_gro_file]

  step4_solvate:
    label: fill the solvent box with water molecules
    run: biobb/biobb_adapters/cwl/biobb_md/gromacs/solvate.cwl
    in:
      input_solute_gro_path: step3_editconf/output_gro_file
      input_top_zip_path: step2_pdb2gmx/output_top_zip_file
    out: [output_gro_file, output_top_zip_file]
      
  step5_grompp_genion:
    label: preprocess ion generation
    run: biobb/biobb_adapters/cwl/biobb_md/gromacs/grompp.cwl
    in:
      config: step5_grompp_genion_config
      input_gro_path: step4_solvate/output_gro_file
      input_top_zip_path: step4_solvate/output_top_zip_file
    out: [output_tpr_file]
    
  step6_genion:
    label: ion generation
    run: biobb/biobb_adapters/cwl/biobb_md/gromacs/genion.cwl
    in:
      config: step6_genion_config
      input_tpr_path: step5_grompp_genion/output_tpr_file
      input_top_zip_path: step4_solvate/output_top_zip_file
    out: [output_gro_file, output_top_zip_file]
    
  step7_grompp_min:
    label: preprocess energy minimization
    run: biobb/biobb_adapters/cwl/biobb_md/gromacs/grompp.cwl
    in:
      config: step7_grompp_min_config
      input_gro_path: step6_genion/output_gro_file
      input_top_zip_path: step6_genion/output_top_zip_file
    out: [output_tpr_file]
    
  step8_mdrun_min:
    label: execute energy minimization
    run: biobb/biobb_adapters/cwl/biobb_md/gromacs/mdrun.cwl
    in:
      input_tpr_path: step7_grompp_min/output_tpr_file
    out: [output_trr_file, output_xtc_file, output_gro_file, output_edr_file, output_log_file]
    
  step9_grompp_nvt:
    label: preprocess system temperature equilibration
    run: biobb/biobb_adapters/cwl/biobb_md/gromacs/grompp.cwl
    in:
      config: step9_grompp_nvt_config
      input_gro_path: step8_mdrun_min/output_gro_file
      input_top_zip_path: step6_genion/output_top_zip_file
    out: [output_tpr_file]
    
  step10_mdrun_nvt:
    label: execute system temperature equilibration
    run: biobb/biobb_adapters/cwl/biobb_md/gromacs/mdrun.cwl
    in:
      input_tpr_path: step9_grompp_nvt/output_tpr_file
    out: [output_trr_file, output_xtc_file, output_gro_file, output_edr_file, output_log_file, output_cpt_file]

  step11_grompp_npt:
    label: preprocess system pressure equilibration
    run: biobb/biobb_adapters/cwl/biobb_md/gromacs/grompp.cwl
    in:      
      config: step11_grompp_npt_config
      input_gro_path: step10_mdrun_nvt/output_gro_file
      input_top_zip_path: step6_genion/output_top_zip_file
      input_cpt_path: step10_mdrun_nvt/output_cpt_file
    out: [output_tpr_file]

  step12_mdrun_npt:
    label: execute system pressure equilibration
    run: biobb/biobb_adapters/cwl/biobb_md/gromacs/mdrun.cwl
    in:
      input_tpr_path: step11_grompp_npt/output_tpr_file
    out: [output_trr_file, output_xtc_file, output_gro_file, output_edr_file, output_log_file, output_cpt_file]
    
  step13_grompp_md:
    label: preprocess free dynamics
    run: biobb/biobb_adapters/cwl/biobb_md/gromacs/grompp.cwl
    in:
      config: step13_grompp_md_config
      input_gro_path: step12_mdrun_npt/output_gro_file
      input_top_zip_path: step6_genion/output_top_zip_file
      input_cpt_path: step12_mdrun_npt/output_cpt_file
    out: [output_tpr_file]
    
  step14_mdrun_md:
    label: execute free molecular dynamics simulation
    run: biobb/biobb_adapters/cwl/biobb_md/gromacs/mdrun.cwl
    in:
      config: step14_mdrun_md_config
      input_tpr_path: step13_grompp_md/output_tpr_file
    out: [output_trr_file, output_xtc_file, output_gro_file, output_edr_file, output_log_file, output_cpt_file]

$namespaces:
  edam: http://edamontology.org/
$schemas:
  - http://edamontology.org/EDAM_1.22.owl

