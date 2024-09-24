setwd("/Users/cheesemania/PycharmProjects/mscthesis_wrkdir/src-plots")

# Load necessary libraries
library(ggplot2)
library(dplyr)
library(cowplot)
library(patchwork)

# Load data
non_filtered_data <- read.delim("Non-filtered.tsv", header = TRUE, stringsAsFactors = TRUE, sep = "\t")
filt_nonresident_data <- read.delim("Filtered-nonresident.tsv", header = TRUE, stringsAsFactors = TRUE, sep = "\t")

# Convert p-values to significance stars for both data sets
non_filtered_data <- non_filtered_data %>%
  mutate(alpha_significance = case_when(
    alpha_p_value < 0.0001 ~ "****",
    alpha_p_value < 0.001 ~ "***",
    alpha_p_value < 0.01 ~ "**",
    alpha_p_value < 0.05 ~ "*",
    TRUE ~ ""
  ),
  beta_significance = case_when(
    adonis_p_value < 0.0001 ~ "****",
    adonis_p_value < 0.001 ~ "***",
    adonis_p_value < 0.01 ~ "**",
    adonis_p_value < 0.05 ~ "*",
    TRUE ~ ""
  ))

filt_nonresident_data <- filt_nonresident_data %>%
  mutate(alpha_significance = case_when(
    alpha_p_value < 0.0001 ~ "****",
    alpha_p_value < 0.001 ~ "***",
    alpha_p_value < 0.01 ~ "**",
    alpha_p_value < 0.05 ~ "*",
    TRUE ~ ""
  ),
  beta_significance = case_when(
    adonis_p_value < 0.0001 ~ "****",
    adonis_p_value < 0.001 ~ "***",
    adonis_p_value < 0.01 ~ "**",
    adonis_p_value < 0.05 ~ "*",
    TRUE ~ ""
  ))

# Define levels for Disease_Level_1
levels_disease <- c("Infectious", "Cancer", "Other", "Gastrointestinal", "Liver", "Metabolic", "Autoimmune")

# Ensure all levels are consistent with the defined levels
non_filtered_data$Disease_Level_1 <- factor(trimws(non_filtered_data$Disease_Level_1), levels = levels_disease)
filt_nonresident_data$Disease_Level_1 <- factor(trimws(filt_nonresident_data$Disease_Level_1), levels = levels_disease)

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

#disease_colors_new <- c(
  #"Infectious disease" = "#FDBF6F",  
  #"Cancer" = "#A6CEE3",  
  #"Other" = "#CAB2D6",  
  #"Gastrointestinal disease" = "#B2DF8A",  
  #"Liver disease" = "#FF7F00",  
  #"Metabolic disease" = "#1F78B4",  
  #"Autoimmune disease" = "#E31A1C"
#)

custom_theme <- theme(
  panel.background = element_rect(fill = "gray95", color = NA),  # Light gray background
  panel.grid.major = element_line(color = "white"),  # White major grid lines
  panel.grid.minor = element_line(color = "white", linetype = "dotted"),  # White minor grid lines
  plot.background = element_rect(fill = "white", color = NA)  # White plot background
)

# Define the function to create combined plots
create_combined_plot <- function(data, alpha_filter, beta_filter, title_suffix, x_label_alpha, x_label_beta, panel1_title = NULL, panel2_title = NULL, panel3_title = NULL) {
  # Filter data based on alpha and beta comparison
  filtered_subset <- data %>%
    filter(alpha_comparison == alpha_filter & beta_comparison == beta_filter)
  
  # Update Disease_Level_1 to use new names
  filtered_subset$Disease_Level_1 <- factor(filtered_subset$Disease_Level_1,
                                            levels = disease_name_mapping$original,
                                            labels = disease_name_mapping$new)
  
  # Order project_id based on Disease_Level_1 and place NAs at the end within each disease group
  filtered_subset <- filtered_subset %>%
    arrange(Disease_Level_1, desc(is.na(AUC)), project_id) %>%  # Sort by Disease, then NA last, then project_id
    mutate(project_id = factor(project_id, levels = unique(project_id)))
  
  # Manually set the range and breaks for x-axis
  alpha_x_limits <- c(-80, 140)
  beta_x_limits <- c(0, 0.16)
  alpha_unit_spacing <- 40
  beta_unit_spacing <- 0.04
  
  # Panel 1: Lollipop plot for alpha percentage change
  p1 <- ggplot(filtered_subset, aes(x = alpha_percentage_change, y = project_id, color = Disease_Level_1)) +
    geom_segment(aes(x = 0, xend = alpha_percentage_change, y = project_id, yend = project_id, color = Disease_Level_1), linewidth = 0.5) +  
    geom_point(size = 2) + 
    geom_text(aes(label = alpha_significance), 
              nudge_y = 0.28, 
              size = 3, 
              color = "black", 
              show.legend = FALSE) +
    geom_vline(xintercept = 0, linetype = "dashed", color = "black") + 
    scale_color_manual(values = disease_colors_new, labels = disease_name_mapping$new, na.translate = FALSE) +
    labs(x = x_label_alpha, y = "", color = "Disease Level 1") +
    scale_x_continuous(limits = alpha_x_limits, breaks = seq(alpha_x_limits[1], alpha_x_limits[2], by = alpha_unit_spacing)) +
    theme_minimal() +
    theme(
      legend.position = "none",
      axis.text.y = element_text(size = 8, color = "black"),
      axis.title.y = element_blank(),
      panel.border = element_rect(color = "black", fill = NA),  # Add black border around each panel
      axis.title.x = element_text(size = rel(0.8), margin = margin(t=5)),
      panel.spacing = unit(0, "cm"),  # Minimize panel spacing
      plot.margin = unit(c(1.5, -0.5, 0.1, 0), "lines"),
      plot.title = element_text(hjust = 0.5, size = 10)
    ) +
    ggtitle(panel1_title) +
    custom_theme
  
  # Panel 2: Lollipop plot for beta adonis R² (effect size)
  p2 <- ggplot(filtered_subset, aes(x = adonis_R2, y = project_id, color = Disease_Level_1)) +
    geom_segment(aes(x = 0, xend = adonis_R2, y = project_id, yend = project_id, color = Disease_Level_1), linewidth = 0.5) +  
    geom_point(size = 2) +  
    geom_text(aes(label = beta_significance), nudge_x = 0.01, size = 3, color = "black", show.legend = FALSE) +  
    geom_vline(xintercept = 0, linetype = "dashed", color = "grey") +
    scale_color_manual(values = disease_colors_new, labels = disease_name_mapping$new, na.translate = FALSE) +
    labs(x = x_label_beta, y = "", color = "Disease Level 1") +
    scale_x_continuous(limits = beta_x_limits, breaks = seq(beta_x_limits[1], beta_x_limits[2], by = beta_unit_spacing)) +
    theme_minimal() +
    theme(
      legend.position = "none",
      axis.text.y = element_blank(),  # Hide y-axis text for this panel
      panel.border = element_rect(color = "black", fill = NA),  # Add black border around each panel
      axis.title.x = element_text(size = rel(0.8), margin = margin(t=5)),
      panel.spacing = unit(0.01, "cm"), # Minimize panel spacing
      plot.margin = unit(c(1.5, -0.5, 0.1, -0.5), "lines"),
      plot.title = element_text(hjust = 0.5, size = 10)
    ) + 
    ggtitle(panel2_title) +
    custom_theme
  
  # Panel 3: Bar plot for AUC with NA annotations
  p3 <- ggplot(filtered_subset, aes(x = AUC, y = project_id, fill = Disease_Level_1)) +
    geom_bar(stat = "identity", width = 0.6) +
    geom_vline(xintercept = 0.5, linetype = "dashed", color = "black") +
    scale_fill_manual(values = disease_colors_new, labels = disease_name_mapping$new, na.translate = FALSE) +
    labs(x = "AUC", y = "", fill = "Disease Level 1") +
    theme_minimal() +
    theme(
      legend.position = "none",
      axis.text.y = element_blank(),  # Hide y-axis text for this panel
      panel.border = element_rect(color = "black", fill = NA),  # Add black border around each panel
      axis.title.x = element_text(size = rel(0.7), margin = margin(t=5)),
      panel.spacing = unit(0.01, "cm"),  # Minimize panel spacing
      plot.margin = unit(c(1.5, 0.5, 0.1, -0.5), "lines"), 
      plot.title = element_text(hjust = 0.5, size = 10)
    ) +
    ggtitle(panel3_title) +
    geom_text(data = filtered_subset %>% filter(is.na(AUC)), 
              aes(x = 0.5, label = "NA"), 
              nudge_x = -0.15, size = 2.5, color = "darkgrey") +
    
    # Adding accuracy ratio as labels next to the intercept line
    geom_text(data = filtered_subset %>% filter(!is.na(AR)), 
              aes(x = 0.58,  # Slightly offset from the intercept line
                  label = paste0("AR: ", sprintf("%.2f", AR)),  # Format to two decimal places
                  #label = paste0("AR: ", round(AR, 2)), 
                  fontface = ifelse(!is.na(AR) & AR >= 1.20, "bold", "plain")),  # Bold font if AR >= 1.2
                  size = 2.5, color = "black", hjust = 0) +
    custom_theme
  
  # Combine the three panels into a single plot with patchwork
  combined_plot <- p1 + p2 + p3 + plot_layout(ncol = 3, widths = c(1, 0.9, 0.9))
  return(combined_plot)
}

# Create individual plots
plot1 <- create_combined_plot(non_filtered_data, "observed_features_non_filtered", "jaccard_non_filtered", "(Non-Filtered)", 
                              "% increase/decrease", "Effect size (adonis R²)", panel1_title = "Observed Features", panel2_title = "Jaccard Index", panel3_title = "Predictive Accuracy")
plot2 <- create_combined_plot(filt_nonresident_data, "observed_features_filt_nonresident", "jaccard_filt_nonresident", "(Filt-Nonresident)", 
                              "% increase/decrease", "Effect size (adonis R²)", panel1_title = NULL, panel2_title = NULL, panel3_title = NULL)
plot3 <- create_combined_plot(non_filtered_data, "shannon_entropy_non_filtered", "bray_curtis_non_filtered", "(Non-Filtered)", 
                              "% increase/decrease", "Effect size (adonis R²)",  panel1_title = "Shannon Diversity", panel2_title = "Bray-Curtis", panel3_title = "Predictive Accuracy")
plot4 <- create_combined_plot(filt_nonresident_data, "shannon_entropy_filt_nonresident", "bray_curtis_filt_nonresident", "(Filt-Nonresident)", 
                              "% increase/decrease", "Effect size (adonis R²)", panel1_title = NULL, panel2_title = NULL, panel3_title = NULL)


# Combine plots for "Observed features + Jaccard index"
final_plot1 <- (plot1 / plot2) +
  plot_layout(guides = "collect", tag_level = "new")  # Collect guides and start a new tag level
  #plot_annotation(tag_levels = 'A', title = "Observed features + Jaccard index") & 
  #theme(plot.title = element_text(hjust = 0.5))

# Combine plots for "Shannon entropy + Bray-Curtis"
final_plot2 <- (plot3 / plot4) +
  plot_layout(guides = "collect", tag_level = "new")
  #plot_annotation(tag_levels = 'C', title = "Shannon entropy + Bray-Curtis") & 
  #theme(plot.title = element_text(hjust = 0.5))

# Arrange the two sets of plots together side by side
final_combined_plot <- final_plot1 | final_plot2
print(final_combined_plot)

### Save the plot1 as a PNG file
ggsave("final_combined_plot_prefer_with_bg.png", 
       plot = final_combined_plot, width = 18, height = 12, dpi = 600)

# Save the first combined plot ("Observed features + Jaccard index")
ggsave("final_plot1_prefer_with_bg.png", final_plot1, dpi = 600, width = 10, height = 12)

# Save the second combined plot ("Shannon entropy + Bray-Curtis")
ggsave("final_plot2_prefer_with_bg.png", final_plot2, dpi = 600, width = 10, height = 12)


# Print the final combined plot
#print(final_plot1)
#print(final_plot2)
