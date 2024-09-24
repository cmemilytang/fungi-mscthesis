setwd("/Users/cheesemania/PycharmProjects/mscthesis_wrkdir/src-plots")

# Load required libraries
library(ggplot2)
library(dplyr)

# Load the data
data <- read.delim("Jaccard-mantel-procrustes.tsv", header = TRUE, stringsAsFactors = TRUE, sep = "\t")

# Define levels for Disease_Level_1
levels_disease <- c("Infectious", "Cancer", "Other", "Gastrointestinal", "Liver", "Metabolic", "Autoimmune")

# Ensure all levels are consistent with the defined levels
data$Disease_Level_1 <- factor(trimws(data$Disease_Level_1), levels = levels_disease)

# Create a mapping data frame for the new disease names
disease_name_mapping <- data.frame(
  original = c("Infectious", "Cancer", "Other", "Gastrointestinal", "Liver", "Metabolic", "Autoimmune"),
  new = c("Infectious disease", "Cancer", "Other", "Gastrointestinal disease", "Liver disease", "Metabolic disease", "Autoimmune disease")
)

# Create a named vector for the new disease names to map with colors
disease_colors_new <- c(
  "Infectious disease" = "#1F78B4",  
  "Cancer" = "#FF7F00",  
  "Other" = "#B2DF8A",  
  "Gastrointestinal disease" = "#CAB2D6",  
  "Liver disease" = "#E31A1C",  
  "Metabolic disease" = "#A6CEE3",  
  "Autoimmune disease" = "#FDBF6F"
)

# Update Disease_Level_1 to use new names
data$Disease_Level_1 <- factor(data$Disease_Level_1, levels = disease_name_mapping$original, labels = disease_name_mapping$new)

# Order project_id based on Disease_Level_1 and place NAs at the end within each disease group
data <- data %>%
  arrange(Disease_Level_1, desc(is.na(Mantel_R)), project_id) %>%  # Sort by Disease, then NA last, then project_id
  mutate(project_id = factor(project_id, levels = unique(project_id)))

# Manually set the range and breaks for x-axis
mantel_x_limits <- c(0.95, 1.00)
procrustes_x_limits <- c(0, 0.2)
mantel_unit_spacing <- 0.01
procrustes_unit_spacing <- 0.04

custom_theme <- theme(
  panel.background = element_rect(fill = "gray95", color = NA),  # Light gray background
  panel.grid.major = element_line(color = "white"),  # White major grid lines
  panel.grid.minor = element_line(color = "white", linetype = "dotted"),  # White minor grid lines
  plot.background = element_rect(fill = "white", color = NA),  # White plot background
  axis.text = element_text(size = 8, color = "black"),
  legend.position = "none",
  plot.title = element_text(hjust = 0.5, size = 10),  # Centered plot title
)

# Panel 1: Lollipop plot for Mantel R
p1 <- ggplot(data, aes(x = Mantel_R, y = project_id, color = Disease_Level_1)) +
  geom_segment(aes(x = 1, xend = Mantel_R, y = project_id, yend = project_id, color = Disease_Level_1), linewidth = 0.5) +  
  geom_point(size = 1.8) + 
  geom_vline(xintercept = 1, linetype = "dashed", color = "black") +
  scale_color_manual(values = disease_colors_new, labels = disease_name_mapping$new, na.translate = FALSE) +
  labs(x = "Mantel R", y = "", color = "Disease Level 1") +
  scale_x_continuous(limits = mantel_x_limits, breaks = seq(mantel_x_limits[1], mantel_x_limits[2], by = mantel_unit_spacing)) +
  theme_minimal() +
  theme(
    legend.position = "none",
    axis.text.y = element_text(size = 8, color = "black"),
    #axis.text.x = element_blank(),  # Hide x-axis text
    axis.title.x = element_blank(),  # Hide x-axis title
    #axis.title.x = element_text(size = rel(0.8)),
    panel.border = element_rect(color = "black", fill = NA),
    panel.spacing = unit(0.01, "cm"), # Minimize panel spacing
    plot.margin = unit(c(1.5, 0.1, 1.5, 0.1), "lines"),
    plot.title = element_text(hjust = 0.5, size = 10)
  ) +
  ggtitle("Mantel Spearman R") +
  custom_theme

# Panel 2: Lollipop plot for Procrustes M²
p2 <- ggplot(data, aes(x = Procrustes_M2, y = project_id, color = Disease_Level_1)) +
  geom_segment(aes(x = 0, xend = Procrustes_M2, y = project_id, yend = project_id, color = Disease_Level_1), linewidth = 0.5) +  
  geom_point(size = 1.8) +  
  geom_vline(xintercept = 0, linetype = "dashed", color = "grey") +
  geom_vline(xintercept = 0.05, linetype = "dashed", color = "black") +
  scale_color_manual(values = disease_colors_new, labels = disease_name_mapping$new, na.translate = FALSE) +
  labs(x = "Procrustes M²", y = "", color = "Disease Level 1") +
  scale_x_continuous(limits = procrustes_x_limits, breaks = seq(procrustes_x_limits[1], procrustes_x_limits[2], by = procrustes_unit_spacing)) +
  theme_minimal() +
  theme(
    legend.position = "none",
    axis.text.y = element_blank(),  # Hide y-axis text for this panel
    axis.title.y = element_blank(),
    #axis.title.x = element_text(size = rel(0.8)),
    axis.title.x = element_blank(),  # Hide x-axis title
    panel.border = element_rect(color = "black", fill = NA),
    panel.spacing = unit(0.01, "cm"), # Minimize panel spacing
    plot.margin = unit(c(1.5, 1.5, 1.5, 0.1), "lines"),
    plot.title = element_text(hjust = 0.5, size = 10)
  ) + 
  ggtitle("Procrustes M²") +
  custom_theme

# Display both plots side by side
library(gridExtra)
Jaccard_mantel_procrutes_plot <- grid.arrange(p1, p2, ncol = 2)
print(Jaccard_mantel_procrutes_plot)

# Save plot
ggsave("Jaccard_mantel_procrutes_with_bg.png", Jaccard_mantel_procrutes_plot, dpi = 600, width = 8, height = 8)
