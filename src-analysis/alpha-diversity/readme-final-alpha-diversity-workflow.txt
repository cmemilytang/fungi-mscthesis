The final workflow of alpha diversity analysis is as follows:

1. Take the original case-control feature table (excluding four projects with too few samples after rarefaction-at-3000 test) and perform `qiime feature-table rarefy` with `--p-sampling-depth 3000`. Get a rarefied case-control feature table.

2. On the rarefied case-control feature table, perform positive and negative filtering of non-resident fungal features, and get two rarefied subsetted tables.

3. Use these three rarefied tables as separate inputs for `qiime diversity alpha` with `--p-metric` being 'observed features'.

4. Perform `qiime diversity alpha-group-significance` on the "observed_features_vector" respectively. Then combine the results of three "observed-features-group-significance" tables.