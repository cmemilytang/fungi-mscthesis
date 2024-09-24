#!/bin/bash

path="/Users/cheesemania/PycharmProjects/mscthesis_wrkdir"

# Filter one sample each from PRJEB35665 and PRJNA756382
# Info from the error messages of "patrial-procrustes-test.sh"

  # PRJEB35665
  # Filter distance matrix: Bray-Curtis
  qiime diversity filter-distance-matrix \
    --i-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/PRJEB35665/diversity-results-non-filtered/bray_curtis_distance_matrix.qza" \
    --m-metadata-file "${path}/metadata/PRJEB35665-dismatrix-excludeid.tsv" \
    --p-exclude-ids "True" \
    --o-filtered-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/PRJEB35665/diversity-results-non-filtered/bray_curtis_filtered_distance_matrix.qza"

  # Generate PcoA: Bray-Curtis
  qiime diversity pcoa \
    --i-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/PRJEB35665/diversity-results-non-filtered/bray_curtis_filtered_distance_matrix.qza" \
    --o-pcoa "${path}/src-analysis/diversity-analysis/beta-diversity/PRJEB35665/diversity-results-non-filtered/bray_curtis_filtered_pcoa.qza"

  # Filter distance matrix: Jaccard
  qiime diversity filter-distance-matrix \
    --i-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/PRJEB35665/diversity-results-non-filtered/jaccard_distance_matrix.qza" \
    --m-metadata-file "${path}/metadata/PRJEB35665-dismatrix-excludeid.tsv" \
    --p-exclude-ids "True" \
    --o-filtered-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/PRJEB35665/diversity-results-non-filtered/jaccard_filtered_distance_matrix.qza"

  # Generate PcoA: Jaccard
  qiime diversity pcoa \
    --i-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/PRJEB35665/diversity-results-non-filtered/jaccard_filtered_distance_matrix.qza" \
    --o-pcoa "${path}/src-analysis/diversity-analysis/beta-diversity/PRJEB35665/diversity-results-non-filtered/jaccard_filtered_pcoa.qza"

  # PRJNA756382
  qiime diversity filter-distance-matrix \
    --i-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/PRJNA756382/diversity-results-non-filtered/bray_curtis_distance_matrix.qza" \
    --m-metadata-file "${path}/metadata/PRJNA756382-dismatrix-excludeid.tsv" \
    --p-exclude-ids "True" \
    --o-filtered-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/PRJNA756382/diversity-results-non-filtered/bray_curtis_filtered_distance_matrix.qza"

  # Generate PcoA: Bray-Curtis
  qiime diversity pcoa \
    --i-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/PRJNA756382/diversity-results-non-filtered/bray_curtis_filtered_distance_matrix.qza" \
    --o-pcoa "${path}/src-analysis/diversity-analysis/beta-diversity/PRJNA756382/diversity-results-non-filtered/bray_curtis_filtered_pcoa.qza"

  # Filter distance matrix: Jaccard
  qiime diversity filter-distance-matrix \
    --i-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/PRJNA756382/diversity-results-non-filtered/jaccard_distance_matrix.qza" \
    --m-metadata-file "${path}/metadata/PRJNA756382-dismatrix-excludeid.tsv" \
    --p-exclude-ids "True" \
    --o-filtered-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/PRJNA756382/diversity-results-non-filtered/jaccard_filtered_distance_matrix.qza"

  # Generate PcoA: Jaccard
  qiime diversity pcoa \
    --i-distance-matrix "${path}/src-analysis/diversity-analysis/beta-diversity/PRJNA756382/diversity-results-non-filtered/jaccard_filtered_distance_matrix.qza" \
    --o-pcoa "${path}/src-analysis/diversity-analysis/beta-diversity/PRJNA756382/diversity-results-non-filtered/jaccard_filtered_pcoa.qza"
