class: ExpressionTool
cwlVersion: v1.1
doc: |
  This javascript takes two inputs, a list of 
  files, a project file, and an optional string. 
  It will create a directory named after the 
  project file and optional string, populate
  that directory with the files in the list, and
  return the directory.
requirements:
  InlineJavascriptRequirement: {}
inputs:
  external_files: File[]
  external_project_file: File
  external_string:
    type: string
    default: ""
outputs:
  project_work_dir:     
    label: Output archive directory
    doc: |
      workflow output directory, containing required output files
    type: Directory
expression: |
  ${
  return {"project_work_dir": 
      {"class": "Directory", 
       "basename": inputs.external_project_file.basename + inputs.external_string, 
       "listing": inputs.external_files}
  };
  }
