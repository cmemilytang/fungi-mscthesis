#!/bin/bash

path="/Users/cheesemania/PycharmProjects/mscthesis_wrkdir"

# List all unique project IDs
projects=$(awk -F"\t" 'NR>1 {print $2}' "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" | sort | uniq)
# echo "$projects" - Sanity check: OK!

# Loop over each project
for project in $projects
do
    if [[ "$project" == "PRJEB35665" || "$project" == "PRJNA756382" ]]; then
    echo "Skipping project: $project"
    continue
  fi

  echo "Processing project: $project"

  # 1. Procrustes Analysis
  # 1.1 Bray-Curtis
  # Perform Procrustes analysis between conditions within the project
  qiime diversity procrustes-analysis \
    --i-reference "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/bray_curtis_pcoa.qza" \
    --i-other "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/bray_curtis_pcoa.qza" \
    --output-dir "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/bray_curtis-procrustes-results"

  # Visualize the Procrustes results
  qiime emperor procrustes-plot \
    --i-reference-pcoa "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/bray_curtis_pcoa.qza" \
    --i-other-pcoa "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/bray_curtis_pcoa.qza" \
    --i-m2-stats "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/bray_curtis-procrustes-results/disparity_results.qza" \
    --m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" \
    --o-visualization "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/bray_curtis-procrustes-results/procrustes_plot.qzv"

  # 1.2 Jaccard Index
  # Perform Procrustes analysis between conditions within the project
  qiime diversity procrustes-analysis \
    --i-reference "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/jaccard_pcoa.qza" \
    --i-other "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/jaccard_pcoa.qza" \
    --output-dir "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/jaccard-procrustes-results"

  # Visualize the Procrustes results
  qiime emperor procrustes-plot \
    --i-reference-pcoa "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/jaccard_pcoa.qza" \
    --i-other-pcoa "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/jaccard_pcoa.qza" \
    --i-m2-stats "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/jaccard-procrustes-results/disparity_results.qza" \
    --m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" \
    --o-visualization "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/jaccard-procrustes-results/procrustes_plot.qzv"

  # 2. Two-sided Mantel Tests
  mkdir -p "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/mantel-test-results"

  # 2.1 Bray-Curtis
  qiime diversity mantel \
    --i-dm1 "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/bray_curtis_distance_matrix.qza" \
    --i-dm2 "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/bray_curtis_distance_matrix.qza" \
    --p-method 'spearman' \
    --o-visualization "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/mantel-test-results/bray_curtis_mantel_plot"

  # 2.2 Jaccard Index
  qiime diversity mantel \
    --i-dm1 "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/jaccard_distance_matrix.qza" \
    --i-dm2 "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/jaccard_distance_matrix.qza" \
    --p-method 'spearman' \
    --o-visualization "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/mantel-test-results/jaccard_mantel_plot"
done