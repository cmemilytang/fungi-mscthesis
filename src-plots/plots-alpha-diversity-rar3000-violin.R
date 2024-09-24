setwd("/Users/cheesemania/PycharmProjects/mscthesis_wrkdir")

# Install and load necessary packages
install.packages("ggpubr")
install.packages("dplyr")
install.packages("tidyr")
install.packages("ggplot2")
install.packages("ggbeeswarm")
install.packages("viridis")

library(ggpubr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggbeeswarm)
library(viridis)

# Import data
df.combined_alpha_diversity_rar3000 <- read.delim("metadata/combined_alpha_diversity_rar3000.tsv", 
                                            header = TRUE, stringsAsFactors = TRUE, sep = "\t")

# Observed Features
## Non-filtered feature table
## Create violin plot with boxplot overlay

## Define the color palette
#color_palette <- c("Control" = "#1f77b4", "Case" = "#ff7f0e")
#color_palette <- c("Case" = adjustcolor("#FF6F6F", alpha.f = 0.6), "Control" = adjustcolor("#6F9FFF", alpha.f = 0.6)) 
color_palette <- c("Case" = "#F5A3A0", "Control" = "#A2C2E0")
#color_palette <- c("Case" = "#E64A19", "Control" = "#1E88E5")
#color_palette <- c("Case" = "#D84315", "Control" = "#1976D2")

p.nonfiltered.obf.rar3000.violin <- ggviolin(df.combined_alpha_diversity_rar3000, 
                                             x = "Case_Control", 
                                             y = "observed_features_non_filtered", 
                                             fill = "Case_Control",
                                             #palette = "npg",        # Use the "jco" palette
                                             add = "boxplot",        # Add boxplot inside violins
                                             add.params = list(fill = "white", width = 0.1),  # Boxplots with white fill
                                             ylab = "Observed Features") +
  stat_compare_means(comparisons = list(c("Control", "Case")), 
                     method = "wilcox.test", 
                     label = "p.signif", 
                     size = 3, 
                     vjust = 2, 
                     method.args = list(exact = FALSE, correct = TRUE)) +  # Use approximate p-values
  scale_fill_manual(values = color_palette) +
  facet_wrap(Project_ID ~ Disease_Level_2, scales = "free_y", nrow = 7, ncol = 3) +  # Faceting
  theme(
    plot.title = element_blank(),
    axis.title.x = element_blank(),
    legend.position = "right",
    legend.text = element_text(size = 9),
    legend.title = element_text(size = 10),
    legend.key.size = unit(0.5, "cm")
  ) +
  guides(fill = guide_legend(override.aes = list(colour = NA))) # Remove outline from legend keys
  #coord_cartesian(ylim = c(0, NA))  # Set minimum y-axis limit to 0

print(p.nonfiltered.obf.rar3000.violin)

### Save the plot as a PNG file
ggsave("src-plots/alpha-violin-plots/violinplot-observed-features-group-significance-nonfiltered-rar3000.png", 
       plot = p.nonfiltered.obf.rar3000.violin, width = 12, height = 18, dpi = 600)


## Filtering non-resident from table
## Create violin plot
p.filt_nonresident.obf.rar3000.violin <- ggviolin(df.combined_alpha_diversity_rar3000, 
                                x = "Case_Control", 
                                y = "observed_features_filt_nonresident",
                                fill = "Case_Control",
                                add = "boxplot",        # Add boxplot inside violins
                                add.params = list(fill = "white", width = 0.1),  # Boxplots with white fill
                                ylab = "Observed Features") + 
  stat_compare_means(comparisons = list(c("Control", "Case")), 
                     method = "wilcox.test", 
                     label = "p.signif", 
                     size = 3, 
                     vjust = 2, 
                     method.args = list(exact = FALSE, correct = TRUE)) +  # Use approximate p-values
  scale_fill_manual(values = color_palette) +
  facet_wrap(Project_ID ~ Disease_Level_2, scales = "free_y", nrow = 7, ncol = 3) +  # Faceting
  theme(
    plot.title = element_blank(),
    axis.title.x = element_blank(),
    legend.position = "right",
    legend.text = element_text(size = 9),
    legend.title = element_text(size = 10),
    legend.key.size = unit(0.5, "cm")
  ) +
  guides(fill = guide_legend(override.aes = list(colour = NA))) # Remove outline from legend keys

print(p.filt_nonresident.obf.rar3000.violin)

### Save the plot as a PNG file
ggsave("src-plots/alpha-violin-plots/violinplot-observed-features-group-significance-filt-nonresident-rar3000.png", 
       plot = p.filt_nonresident.obf.rar3000.violin, width = 12, height = 18, dpi = 600)


## Subsetting the feature table with only non-resident
## Create violin plot
p.nonresident.obf.rar3000.vionlin <- ggviolin(df.combined_alpha_diversity_rar3000, 
                           x = "Case_Control", 
                           y = "observed_features_nonresident",
                           fill = "Case_Control", 
                           add = "boxplot",        # Add boxplot inside violins
                           add.params = list(fill = "white", width = 0.1),  # Boxplots with white fill
                           ylab = "Observed Features") +
  stat_compare_means(comparisons = list(c("Control", "Case")), 
                     method = "wilcox.test", 
                     label = "p.signif", 
                     size = 3, 
                     vjust = 2, 
                     method.args = list(exact = FALSE, correct = TRUE)) +  # Use approximate p-values
  scale_fill_manual(values = color_palette) +
  facet_wrap(Project_ID ~ Disease_Level_2, scales = "free_y", nrow = 7, ncol = 3) +  # Faceting
  theme(
    plot.title = element_blank(),
    axis.title.x = element_blank(),
    legend.position = "right",
    legend.text = element_text(size = 9),
    legend.title = element_text(size = 10),
    legend.key.size = unit(0.5, "cm")
  ) +
  guides(fill = guide_legend(override.aes = list(colour = NA))) # Remove outline from legend keys

print(p.nonresident.obf.rar3000.vionlin)

### Save the plot as a PNG file
ggsave("src-plots/alpha-violin-plots/violinplot-observed-features-group-significance-nonresident-rar3000.png", 
       plot = p.nonresident.obf.rar3000.vionlin, width = 12, height = 18, dpi = 600)


# Shannon Index
## Non-filtered feature table
## Create violin plot
p.nonfiltered.shannon.rar3000.violin <- ggviolin(df.combined_alpha_diversity_rar3000, 
                               x = "Case_Control", 
                               y = "shannon_entropy_non_filtered",
                               fill = "Case_Control", 
                               add = "boxplot",        # Add boxplot inside violins
                               add.params = list(fill = "white", width = 0.1),  # Boxplots with white fill
                               ylab = "Shannon Diversity") + 
  stat_compare_means(comparisons = list(c("Control", "Case")), 
                     method = "wilcox.test", 
                     label = "p.signif", 
                     size = 3, 
                     vjust = 2, 
                     method.args = list(exact = FALSE, correct = TRUE)) +  # Use approximate p-values
  scale_fill_manual(values = color_palette) +
  facet_wrap(Project_ID ~ Disease_Level_2, scales = "free_y", nrow = 7, ncol = 3) +  # Faceting
  theme(
    plot.title = element_blank(),
    axis.title.x = element_blank(),
    legend.position = "right",
    legend.text = element_text(size = 9),
    legend.title = element_text(size = 10),
    legend.key.size = unit(0.5, "cm")
  ) +
  guides(fill = guide_legend(override.aes = list(colour = NA))) # Remove outline from legend keys

print(p.nonfiltered.shannon.rar3000.violin)

### Save the plot as a PNG file
ggsave("src-plots/alpha-violin-plots/violinplot-shannon-group-significance-nonfiltered-rar3000.png", 
       plot = p.nonfiltered.shannon.rar3000.violin, width = 12, height = 18, dpi = 600)


## Filtering non-resident from table
## Create violin plot
p.filt_nonresident.shannon.rar3000.violin <- ggviolin(df.combined_alpha_diversity_rar3000, 
                                    x = "Case_Control", 
                                    y = "shannon_entropy_filt_nonresident",
                                    fill = "Case_Control",
                                    add = "boxplot",        # Add boxplot inside violins
                                    add.params = list(fill = "white", width = 0.1),  # Boxplots with white fill
                                    ylab = "Shannon Diversity") + 
  stat_compare_means(comparisons = list(c("Control", "Case")), 
                     method = "wilcox.test", 
                     label = "p.signif", 
                     size = 3, 
                     vjust = 2, 
                     method.args = list(exact = FALSE, correct = TRUE)) +  # Use approximate p-values
  scale_fill_manual(values = color_palette) +
  facet_wrap(Project_ID ~ Disease_Level_2, scales = "free_y", nrow = 7, ncol = 3) +  # Faceting
  theme(
    plot.title = element_blank(),
    axis.title.x = element_blank(),
    legend.position = "right",
    legend.text = element_text(size = 9),
    legend.title = element_text(size = 10),
    legend.key.size = unit(0.5, "cm")
  ) +
  guides(fill = guide_legend(override.aes = list(colour = NA))) # Remove outline from legend keys

print(p.filt_nonresident.shannon.rar3000.violin)

### Save the plot as a PNG file
ggsave("src-plots/alpha-violin-plots/violinplot-shannon-group-significance-filt-nonresident-rar3000.png", 
       plot = p.filt_nonresident.shannon.rar3000.violin, width = 12, height = 18, dpi = 600)


## Subsetting the feature table with only non-resident
## Create violin plot
p.nonresident.shannon.rar3000.violin <- ggviolin(df.combined_alpha_diversity_rar3000, 
                               x = "Case_Control", 
                               y = "shannon_entropy_nonresident",
                               fill = "Case_Control", 
                               add = "boxplot",        # Add boxplot inside violins
                               add.params = list(fill = "white", width = 0.1),  # Boxplots with white fill
                               ylab = "Shannon Diversity") +
  stat_compare_means(comparisons = list(c("Control", "Case")), 
                     method = "wilcox.test", 
                     label = "p.signif", 
                     size = 3, 
                     vjust = 2, 
                     method.args = list(exact = FALSE, correct = TRUE)) +  # Use approximate p-values
  scale_fill_manual(values = color_palette) +
  facet_wrap(Project_ID ~ Disease_Level_2, scales = "free_y", nrow = 7, ncol = 3) +  # Faceting
  theme(
    plot.title = element_blank(),
    axis.title.x = element_blank(),
    legend.position = "right",
    legend.text = element_text(size = 9),
    legend.title = element_text(size = 10),
    legend.key.size = unit(0.5, "cm")
  ) +
  guides(fill = guide_legend(override.aes = list(colour = NA))) # Remove outline from legend keys

print(p.nonresident.shannon.rar3000.violin)

### Save the plot as a PNG file
ggsave("src-plots/alpha-violin-plots/violinplot-shannon-group-significance-nonresident-rar3000.png", 
       plot = p.nonresident.shannon.rar3000.violin, width = 12, height = 18, dpi = 600)
