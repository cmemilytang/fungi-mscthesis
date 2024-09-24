#!/bin/bash

path="/Users/cheesemania/PycharmProjects/mscthesis_wrkdir"

# List all unique project IDs
projects=$(awk -F"\t" 'NR>1 {print $2}' "${path}/metadata/case_control_metadata_remove_h1n1_filtered3.tsv" | sort | uniq)
# echo "$projects" - Sanity check: OK!

# Loop over each project
for project in $projects
do
  echo "Processing project: $project"

  # Use the rarefied feature tables for supervised machine learning

  # Create a directory for each project
  mkdir -p "${path}/src-analysis/ML/Rarefied/${project}"

  # 1. Non-filtered feature table
  mkdir -p "${path}/src-analysis/ML/Rarefied/${project}/ML-results-non-filtered"

  # Random Forest classifiers with 500 trees, trained using 10-fold nested cross-validation
  qiime sample-classifier classify-samples-ncv \
    --i-table "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/case_control_rarefied3000_non_filtered_feature_table.qza" \
    --m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered3.tsv" \
    --m-metadata-column Case_Control \
    --p-estimator RandomForestClassifier \
    --p-cv 10 \
    --p-n-estimators 500 \
    --p-parameter-tuning \
    --p-random-state 42 \
    --output-dir "${path}/src-analysis/ML/Rarefied/${project}/ML-results-non-filtered/RF-ncv-classifier-ten-fold"

  qiime sample-classifier confusion-matrix \
  --i-predictions "${path}/src-analysis/ML/Rarefied/${project}/ML-results-non-filtered/RF-ncv-classifier-ten-fold/predictions.qza" \
  --i-probabilities "${path}/src-analysis/ML/Rarefied/${project}/ML-results-non-filtered/RF-ncv-classifier-ten-fold/probabilities.qza" \
  --m-truth-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered3.tsv" \
  --m-truth-column Case_Control \
  --o-visualization "${path}/src-analysis/ML/Rarefied/${project}/ML-results-non-filtered/RF-ncv-classifier-ten-fold/ncv_confusion_matrix.qzv"

  qiime metadata tabulate \
    --m-input-file "${path}/src-analysis/ML/Rarefied/${project}/ML-results-non-filtered/RF-ncv-classifier-ten-fold/feature_importance.qza" \
    --o-visualization "${path}/src-analysis/ML/Rarefied/${project}/ML-results-non-filtered/RF-ncv-classifier-ten-fold/feature_importance.qzv"

  qiime sample-classifier heatmap \
    --i-table "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-non-filtered/case_control_rarefied3000_non_filtered_feature_table.qza" \
    --i-importance "${path}/src-analysis/ML/Rarefied/${project}/ML-results-non-filtered/RF-ncv-classifier-ten-fold/feature_importance.qza" \
    --m-sample-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered3.tsv"  \
    --m-sample-metadata-column Case_Control \
    --p-group-samples \
    --p-feature-count 20 \
    --o-filtered-table "${path}/src-analysis/ML/Rarefied/${project}/ML-results-non-filtered/RF-ncv-classifier-ten-fold/important-feature-table-top-20.qza" \
    --o-heatmap "${path}/src-analysis/ML/Rarefied/${project}/ML-results-non-filtered/RF-ncv-classifier-ten-fold/important-feature-top-20-heatmap.qzv"

  # 2. Filt-nonresident feature table
  mkdir -p "${path}/src-analysis/ML/Rarefied/${project}/ML-results-filt-nonresident"

  # Random Forest classifiers with 500 trees, trained using 10-fold nested cross-validation
  qiime sample-classifier classify-samples-ncv \
    --i-table "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/case_control_rarefied3000_filt_nonresident_feature_table.qza" \
    --m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered3.tsv" \
    --m-metadata-column Case_Control \
    --p-estimator RandomForestClassifier \
    --p-cv 10 \
    --p-n-estimators 500 \
    --p-parameter-tuning \
    --p-random-state 42 \
    --output-dir "${path}/src-analysis/ML/Rarefied/${project}/ML-results-filt-nonresident/RF-ncv-classifier-ten-fold"

  qiime sample-classifier confusion-matrix \
  --i-predictions "${path}/src-analysis/ML/Rarefied/${project}/ML-results-filt-nonresident/RF-ncv-classifier-ten-fold/predictions.qza" \
  --i-probabilities "${path}/src-analysis/ML/Rarefied/${project}/ML-results-filt-nonresident/RF-ncv-classifier-ten-fold/probabilities.qza" \
  --m-truth-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered3.tsv" \
  --m-truth-column Case_Control \
  --o-visualization "${path}/src-analysis/ML/Rarefied/${project}/ML-results-filt-nonresident/RF-ncv-classifier-ten-fold/ncv_confusion_matrix.qzv"

  qiime metadata tabulate \
    --m-input-file "${path}/src-analysis/ML/Rarefied/${project}/ML-results-filt-nonresident/RF-ncv-classifier-ten-fold/feature_importance.qza" \
    --o-visualization "${path}/src-analysis/ML/Rarefied/${project}/ML-results-filt-nonresident/RF-ncv-classifier-ten-fold/feature_importance.qzv"

  qiime sample-classifier heatmap \
    --i-table "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-filt-nonresident/case_control_rarefied3000_filt_nonresident_feature_table.qza" \
    --i-importance "${path}/src-analysis/ML/Rarefied/${project}/ML-results-filt-nonresident/RF-ncv-classifier-ten-fold/feature_importance.qza" \
    --m-sample-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered3.tsv"  \
    --m-sample-metadata-column Case_Control \
    --p-group-samples \
    --p-feature-count 20 \
    --o-filtered-table "${path}/src-analysis/ML/Rarefied/${project}/ML-results-filt-nonresident/RF-ncv-classifier-ten-fold/important-feature-table-top-20.qza" \
    --o-heatmap "${path}/src-analysis/ML/Rarefied/${project}/ML-results-filt-nonresident/RF-ncv-classifier-ten-fold/important-feature-top-20-heatmap.qzv"

  # 3. Only non-resident feature table
  mkdir -p "${path}/src-analysis/ML/Rarefied/${project}/ML-results-nonresident"

  # Random Forest classifiers with 500 trees, trained using 10-fold nested cross-validation
  qiime sample-classifier classify-samples-ncv \
    --i-table "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-nonresident/case_control_rarefied3000_nonresident_feature_table.qza" \
    --m-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered3.tsv" \
    --m-metadata-column Case_Control \
    --p-estimator RandomForestClassifier \
    --p-cv 10 \
    --p-n-estimators 500 \
    --p-parameter-tuning \
    --p-random-state 42 \
    --output-dir "${path}/src-analysis/ML/Rarefied/${project}/ML-results-nonresident/RF-ncv-classifier-ten-fold"

  qiime sample-classifier confusion-matrix \
  --i-predictions "${path}/src-analysis/ML/Rarefied/${project}/ML-results-nonresident/RF-ncv-classifier-ten-fold/predictions.qza" \
  --i-probabilities "${path}/src-analysis/ML/Rarefied/${project}/ML-results-nonresident/RF-ncv-classifier-ten-fold/probabilities.qza" \
  --m-truth-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered3.tsv" \
  --m-truth-column Case_Control \
  --o-visualization "${path}/src-analysis/ML/Rarefied/${project}/ML-results-nonresident/RF-ncv-classifier-ten-fold/ncv_confusion_matrix.qzv"

  qiime metadata tabulate \
    --m-input-file "${path}/src-analysis/ML/Rarefied/${project}/ML-results-nonresident/RF-ncv-classifier-ten-fold/feature_importance.qza" \
    --o-visualization "${path}/src-analysis/ML/Rarefied/${project}/ML-results-nonresident/RF-ncv-classifier-ten-fold/feature_importance.qzv"

  qiime sample-classifier heatmap \
    --i-table "${path}/src-analysis/diversity-analysis/beta-diversity/${project}/diversity-results-nonresident/case_control_rarefied3000_nonresident_feature_table.qza" \
    --i-importance "${path}/src-analysis/ML/Rarefied/${project}/ML-results-nonresident/RF-ncv-classifier-ten-fold/feature_importance.qza" \
    --m-sample-metadata-file "${path}/metadata/case_control_metadata_remove_h1n1_filtered3.tsv"  \
    --m-sample-metadata-column Case_Control \
    --p-group-samples \
    --p-feature-count 20 \
    --o-filtered-table "${path}/src-analysis/ML/Rarefied/${project}/ML-results-nonresident/RF-ncv-classifier-ten-fold/important-feature-table-top-20.qza" \
    --o-heatmap "${path}/src-analysis/ML/Rarefied/${project}/ML-results-nonresident/RF-ncv-classifier-ten-fold/important-feature-top-20-heatmap.qzv"
done