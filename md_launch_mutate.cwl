#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: Workflow

requirements:
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  MultipleInputFeatureRequirement: {}

inputs:
  step0_mutate_list:  
    type:
      type: array
      items: string
  step0_pdb_file: File
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
    label: Collected Simulation Data
    doc: |
      Assorted data files output by the workflow
    type:
      type: array
      items: Directory
    outputSource: subworkflow_mutate/outdir

  
steps:
  subworkflow_mutate:
    in:
      step0_mutate: step0_mutate_list
      step0_pdb_file: step0_pdb_file
      step2_editconf_config: step2_editconf_config
      step4_grompp_genion_config: step4_grompp_genion_config
      step5_genion_config: step5_genion_config
      step6_grompp_min_config: step6_grompp_min_config
      step8_make_ndx_config: step8_make_ndx_config
      step9_grompp_nvt_config: step9_grompp_nvt_config
      step11_grompp_npt_config: step11_grompp_npt_config
      step13_grompp_md_config: step13_grompp_md_config
      step14_mdrun_md_config: step14_mdrun_md_config
      
    out: [outdir]

    scatter: step0_mutate
    run:
      class: Workflow
      inputs:
        step0_mutate: string
        step0_pdb_file: File
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
        outdir:
          label: Simulation Data
          type: Directory
          outputSource: launch_workflow/dir


      steps:
        step0_mutate:
          label: mutate the protein
          when: $(inputs.config.indexOf("WT") == -1)
          run: biobb/biobb_adapters/cwl/biobb_model/model/mutate.cwl
          in:
            config: step0_mutate
            input_pdb_path: step0_pdb_file
          out: [output_pdb_file]


        launch_workflow:
          run: md_list.cwl
          in:
            step1_pdb_file:
              source:
                - step0_mutate/output_pdb_file
                - step0_pdb_file
              pickValue: first_non_null
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


