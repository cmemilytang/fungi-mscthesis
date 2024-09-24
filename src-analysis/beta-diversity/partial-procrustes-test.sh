#!/bin/bash

path="/Users/cheesemania/PycharmProjects/mscthesis_wrkdir"
#project="PRJEB35665"
  # "['ERR3711761'] not in index"

project="PRJNA756382"
  # "['SRR15531564'] not in index"

#project="PRJEB38930"
  # Plugin error from emperor:
     # There should be as many coordinates per site as eigvals: 113 != 5

  #qiime metadata tabulate \
    #--m-input-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1_for-beta.tsv" \
    #--o-visualization "${path}/metadata/case_control_metadata_remove_h1n1_filtered1_for-beta.qzv"

  # Bray-Curtis
  # Perform Partial Procrustes analysis between conditions within the project
  qiime diversity partial-procrustes \
    --i-reference "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/bray_curtis_pcoa.qza" \
    --i-other "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/bray_curtis_pcoa.qza" \
    --m-pairing-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1_for-beta.tsv" \
    --m-pairing-column "Sample_for_beta" \
    --output-dir "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/bray_curtis-partial-procrustes-results"

  #qiime emperor plot \
  #--i-pcoa "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/bray_curtis-partial-procrustes-results/transformed.qza" \
  #--m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1_for-beta.tsv" \
  #--o-visualization "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/bray_curtis-partial-procrustes-results/transformed.qzv"