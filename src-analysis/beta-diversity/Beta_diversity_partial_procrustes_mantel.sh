#!/bin/bash

path="/Users/cheesemania/PycharmProjects/mscthesis_wrkdir"

# Under qiime2-amplicon-2024.5 environment
# Compare between the non-filtered and filt-nonresident

# List all unique project IDs
projects=$(awk -F"\t" 'NR>1 {print $2}' "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" | sort | uniq)

# Automate Partial Procrustes Analysis and Mantel test for Each Project
for project in $projects
do
  echo "Performing Partial Procrustes analysis and Mantel test for project: $project"

  # 1. Partial Procrustes Analysis
  # 1.1 Bray-Curtis
  qiime diversity partial-procrustes \
    --i-reference "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/bray_curtis_pcoa.qza" \
    --i-other "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/bray_curtis_pcoa.qza" \
    --m-pairing-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" \
    --m-pairing-column sampleid \
    --output-dir "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/bray_curtis-partial-procrustes-results"

  # Visualize the Partial Procrustes results
  qiime emperor procrustes-plot \
    --i-reference-pcoa "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/bray_curtis_pcoa.qza" \
    --i-other-pcoa "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/bray_curtis_pcoa.qza" \
    --i-m2-stats "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/bray_curtis-partial-procrustes-results/disparity_results.qza" \
    --m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" \
    --o-visualization "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/bray_curtis-partial-procrustes-results/partial_procrustes_plot.qzv"

  # 1.2 Jaccard Index
  qiime diversity partial-procrustes \
    --i-reference "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/jaccard_pcoa.qza" \
    --i-other "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/jaccard_pcoa.qza" \
    --m-pairing-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" \
    --m-pairing-column sampleid \
    --output-dir "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/jaccard-partial-procrustes-results"

  # Visualize the Partial Procrustes results
  qiime emperor procrustes-plot \
    --i-reference-pcoa "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/jaccard_pcoa.qza" \
    --i-other-pcoa "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/jaccard_pcoa.qza" \
    --i-m2-stats "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/jaccard-partial-procrustes-results/disparity_results.qza" \
    --m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" \
    --o-visualization "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/jaccard-partial-procrustes-results/partial_procrustes_plot.qzv"

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