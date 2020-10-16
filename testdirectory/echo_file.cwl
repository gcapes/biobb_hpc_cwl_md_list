class: Workflow
cwlVersion: v1.0

requirements:
  SubworkflowFeatureRequirement: {}

inputs:
  step1_pdb_file: File

outputs: []


steps:
  echodir:
    in:
      infilename: step1_pdb_file #$(inputs.step1_pdb_file.basename)
    out: []
    run:
      class: CommandLineTool
      baseCommand: echo
      arguments: [ "this is the info: ", $(inputs.infilename.basename) ] 
      inputs:
        infilename: File
      outputs: []
        
