#!/bin/bash

path="/Users/cheesemania/PycharmProjects/mscthesis_wrkdir"

# List all unique project IDs
projects=$(awk -F"\t" 'NR>1 {print $2}' "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" | sort | uniq)
# echo "$projects" - Sanity check: OK!

# Loop over each project
for project in $projects
do
  echo "Processing project: $project"

  # Create a directory for each project
  mkdir -p "${path}/src-analysis/diversity-analysis/beta-diversity/${project}"

  # 1. Final feature table of case-control samples rarefied at 3000
  mkdir -p "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered"

  # 1.1 Filter feature table for the current project
  qiime feature-table filter-samples \
    --i-table "${path}/src-analysis/feature-table/health-disease-case-control/case_control_rarefied3000_feature_table_remove_h1n1_filtered1.qza" \
    --m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" \
    --p-where "[Project_ID]='$project'" \
    --o-filtered-table "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/case_control_rarefied3000_non_filtered_feature_table.qza"

  # 1.2 Perform beta diversity analysis
  # 1.2.1 Bray-Curtis: compositional similarity, weighted by abundance
  qiime diversity beta \
    --i-table "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/case_control_rarefied3000_non_filtered_feature_table.qza" \
    --p-metric 'braycurtis' \
    --o-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/bray_curtis_distance_matrix.qza"

  # Bray-Curtis: group significance
  qiime diversity beta-group-significance \
    --i-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/bray_curtis_distance_matrix.qza" \
    --m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" \
    --m-metadata-column "Case_Control" \
    --p-pairwise \
    --o-visualization "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/bray_curtis-group-significance.qzv"

  # Bray-Curtis: generate PCoA
  qiime diversity pcoa \
    --i-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/bray_curtis_distance_matrix.qza" \
    --o-pcoa "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/bray_curtis_pcoa.qza"

  # Bray-Curtis: generate ordination plot
  qiime emperor plot \
    --i-pcoa "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/bray_curtis_pcoa.qza" \
    --m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" \
    --o-visualization "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/bray_curtis_plot.qza"

  # 1.2.2 Jaccard Index: proportion of features not shared by two samples
  qiime diversity beta \
    --i-table "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/case_control_rarefied3000_non_filtered_feature_table.qza" \
    --p-metric 'jaccard' \
    --o-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/jaccard_distance_matrix.qza"

  # Jaccard Index: group significance
  qiime diversity beta-group-significance \
    --i-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/jaccard_distance_matrix.qza" \
    --m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" \
    --m-metadata-column "Case_Control" \
    --p-pairwise \
    --o-visualization "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/jaccard-group-significance.qzv"

  # Jaccard Index: generate PCoA
  qiime diversity pcoa \
    --i-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/jaccard_distance_matrix.qza" \
    --o-pcoa "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/jaccard_pcoa.qza"

 # Jaccard Index: generate ordination plot
  qiime emperor plot \
    --i-pcoa "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/jaccard_pcoa.qza" \
    --m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" \
    --o-visualization "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/jaccard_plot.qza"

  # 2. Filtered non-resident fungi from the rarefied3000 feature table
  mkdir -p "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident"

  # 2.1 Filter feature table for the current project
  qiime feature-table filter-samples \
    --i-table "${path}/src-analysis/diversity-analysis/alpha-diversity-results-filt-nonresident/case_control_rarefied3000_filt_nonresident_feature_table.qza" \
    --m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" \
    --p-where "[Project_ID]='$project'" \
    --o-filtered-table "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/case_control_rarefied3000_filt_nonresident_feature_table.qza"

  # 2.2 Perform beta diversity analysis
  # 2.2.1 Bray-Curtis: compositional similarity, weighted by abundance
  qiime diversity beta \
    --i-table "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/case_control_rarefied3000_filt_nonresident_feature_table.qza" \
    --p-metric 'braycurtis' \
    --o-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/bray_curtis_distance_matrix.qza"

  # Bray-Curtis: group significance
  qiime diversity beta-group-significance \
    --i-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/bray_curtis_distance_matrix.qza" \
    --m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" \
    --m-metadata-column "Case_Control" \
    --p-pairwise \
    --o-visualization "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/bray_curtis-group-significance.qzv"

  # Bray-Curtis: generate PCoA
  qiime diversity pcoa \
    --i-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/bray_curtis_distance_matrix.qza" \
    --o-pcoa "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/bray_curtis_pcoa.qza"

 # Bray-Curtis: generate ordination plot
  qiime emperor plot \
    --i-pcoa "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/bray_curtis_pcoa.qza" \
    --m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" \
    --o-visualization "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/bray_curtis_plot.qza"

  # 2.2.2 Jaccard Index: proportion of features not shared by two samples
  qiime diversity beta \
    --i-table "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/case_control_rarefied3000_filt_nonresident_feature_table.qza" \
    --p-metric 'jaccard' \
    --o-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/jaccard_distance_matrix.qza"

  # Jaccard Index: group significance
  qiime diversity beta-group-significance \
    --i-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/jaccard_distance_matrix.qza" \
    --m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" \
    --m-metadata-column "Case_Control" \
    --p-pairwise \
    --o-visualization "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/jaccard-group-significance.qzv"

  # Jaccard Index: generate PCoA
  qiime diversity pcoa \
    --i-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/jaccard_distance_matrix.qza" \
    --o-pcoa "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/jaccard_pcoa.qza"

 # Jaccard Index: generate ordination plot
  qiime emperor plot \
    --i-pcoa "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/jaccard_pcoa.qza" \
    --m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" \
    --o-visualization "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/jaccard_plot.qza"

  # 3. Subset the rarefied3000 feature table with only non-resident fungi
  mkdir -p "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-nonresident"

  # 3.1 Filter feature table for the current project
  qiime feature-table filter-samples \
    --i-table "${path}/src-analysis/diversity-analysis/alpha-diversity-results-nonresident/case_control_rarefied3000_nonresident_feature_table.qza" \
    --m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" \
    --p-where "[Project_ID]='$project'" \
    --o-filtered-table "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-nonresident/case_control_rarefied3000_nonresident_feature_table.qza"

  # 3.2 Perform beta diversity analysis
  # 3.2.1 Bray-Curtis: compositional similarity, weighted by abundance
  qiime diversity beta \
    --i-table "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-nonresident/case_control_rarefied3000_nonresident_feature_table.qza" \
    --p-metric 'braycurtis' \
    --o-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-nonresident/bray_curtis_distance_matrix.qza"

  # Bray-Curtis: group significance
  qiime diversity beta-group-significance \
    --i-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-nonresident/bray_curtis_distance_matrix.qza" \
    --m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" \
    --m-metadata-column "Case_Control" \
    --p-pairwise \
    --o-visualization "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-nonresident/bray_curtis-group-significance.qzv"

  # Bray-Curtis: generate PCoA
  qiime diversity pcoa \
    --i-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-nonresident/bray_curtis_distance_matrix.qza" \
    --o-pcoa "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-nonresident/bray_curtis_pcoa.qza"

 # Bray-Curtis: generate ordination plot
  qiime emperor plot \
    --i-pcoa "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-nonresident/bray_curtis_pcoa.qza" \
    --m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" \
    --o-visualization "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-nonresident/bray_curtis_plot.qza"

  # 3.2.2 Jaccard Index: proportion of features not shared by two samples
  qiime diversity beta \
    --i-table "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-nonresident/case_control_rarefied3000_nonresident_feature_table.qza" \
    --p-metric 'jaccard' \
    --o-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-nonresident/jaccard_distance_matrix.qza"

  # Jaccard Index: group significance
  qiime diversity beta-group-significance \
    --i-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-nonresident/jaccard_distance_matrix.qza" \
    --m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" \
    --m-metadata-column "Case_Control" \
    --p-pairwise \
    --o-visualization "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-nonresident/jaccard-group-significance.qzv"

  # Jaccard Index: generate PCoA
  qiime diversity pcoa \
    --i-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-nonresident/jaccard_distance_matrix.qza" \
    --o-pcoa "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-nonresident/jaccard_pcoa.qza"

 # Jaccard Index: generate ordination plot
  qiime emperor plot \
    --i-pcoa "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-nonresident/jaccard_pcoa.qza" \
    --m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered1.tsv" \
    --o-visualization "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-nonresident/jaccard_plot.qza"
done
