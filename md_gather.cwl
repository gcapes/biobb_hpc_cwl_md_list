#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: Gather the outputs and return them
doc: |
  This is for organising and returning the workflow files


inputs:
  external_project_file: File
  external_files: File[]

outputs:
  project_work_dir: 
    label: Output archive directory
    doc: |
      workflow output directory, containing required output files
    type: Directory
    outputSource: stepb_move_files/output_dir



steps:

  stepa_create_dir:
    label: creating the project directory
    in:
      stepa_project_file: external_project_file
    out: [output_dir]
    run: 
      class: CommandLineTool
      baseCommand: mkdir
      arguments: [ $(inputs.stepa_project_file.basename) ]
      inputs:
        stepa_project_file: File
      outputs:
        output_dir:
          type: Directory
          outputBinding:
            glob: "$(inputs.stepa_project_file.basename)"

  stepb_move_files:
    label: moving the required files into the directory
    in:
      stepb_project_dir: stepa_create_dir/output_dir
      stepb_files: external_files
    out: [output_dir]
    run:
      class: CommandLineTool 
      baseCommand: mv
      requirements:
        InitialWorkDirRequirement:
          listing:
            - $(inputs.stepb_project_dir)
      arguments: [ $(inputs.stepb_files), $(inputs.stepb_project_dir.basename) ]
      inputs:
        stepb_project_dir: Directory 
        stepb_files: File[]
      outputs:
        output_dir:
          type: Directory
          outputBinding:
            glob: "$(inputs.stepb_project_dir.basename)"

