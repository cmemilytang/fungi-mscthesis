#!/bin/bash

path="/Users/cheesemania/PycharmProjects/mscthesis_wrkdir"

# List all unique project IDs
projects=$(awk -F"\t" 'NR>1 {print $2}' "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" | sort | uniq)
# echo "$projects" - Sanity check: OK!

# Loop over each project
for project in $projects
do
  echo "Processing project: $project"

  # 1. Final feature table of case-control samples rarefied at 3000
  # Bray-Curtis: ADONIS
  qiime diversity adonis \
    --i-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/bray_curtis_distance_matrix.qza" \
    --m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" \
    --p-formula "Case_Control" \
    --o-visualization "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/bray_curtis-adonis.qzv"

  # Jaccard Index: ADONIS
  qiime diversity adonis \
    --i-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/jaccard_distance_matrix.qza" \
    --m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" \
    --p-formula "Case_Control" \
    --o-visualization "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/jaccard-adonis.qzv"

  # 2. Filtered non-resident fungi from the rarefied3000 feature table
  # Bray-Curtis: ADONIS
  qiime diversity adonis \
    --i-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/bray_curtis_distance_matrix.qza" \
    --m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" \
    --p-formula "Case_Control" \
    --o-visualization "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/bray_curtis-adonis.qzv"

  # Jaccard Index: ADONIS
  qiime diversity adonis \
    --i-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/jaccard_distance_matrix.qza" \
    --m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" \
    --p-formula "Case_Control" \
    --o-visualization "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/jaccard-adonis.qzv"

  # 3. Subset the rarefied3000 feature table with only non-resident fungi
  # Bray-Curtis: ADONIS
  qiime diversity adonis \
    --i-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-nonresident/bray_curtis_distance_matrix.qza" \
    --m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" \
    --p-formula "Case_Control" \
    --o-visualization "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-nonresident/bray_curtis-adonis.qzv"

  # Jaccard Index: ADONIS
  qiime diversity adonis \
    --i-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-nonresident/jaccard_distance_matrix.qza" \
    --m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" \
    --p-formula "Case_Control" \
    --o-visualization "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-nonresident/jaccard-adonis.qzv"
done