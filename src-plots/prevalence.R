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
df.readcounts <- read.delim("metadata/sample-readcount-per-3000.tsv", 
                                                  header = TRUE, stringsAsFactors = TRUE, sep = "\t")
## Plot 1
# Convert the percentage from decimal to percentage points
df.readcounts$percentage_nonresident_reads_new <- df.readcounts$percentage_nonresident_reads * 100

# Calculate the sample size for each Case/Control group within each Project_ID
df.counts <- df.readcounts %>%
  group_by(Project_ID, Disease_Level_2, Case_Control) %>%
  summarise(n = n())

# Create a data frame to use for annotation (one row per project with counts)
df.annotation <- df.counts %>%
  pivot_wider(names_from = Case_Control, values_from = n, names_prefix = "n_") %>%
  mutate(n_Case = ifelse(is.na(n_Case), 0, n_Case),
         n_Control = ifelse(is.na(n_Control), 0, n_Control))


p1 <- ggboxplot(df.readcounts, 
               x = "Case_Control", 
               y = "percentage_nonresident_reads_new",
               color = "Case_Control") +
  geom_jitter(aes(color=Case_Control), 
              width = 0.2,
              height = 0,  # Prevent vertical jitter
              size = 1,
              alpha = 0.5) +
  facet_wrap(Project_ID ~ Disease_Level_2, 
             #scales = "free_y",  # Allows different y-axis scales for each facet
             nrow = 7,           # Number of rows
             ncol = 3) +         # Number of columns 
  scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, by = 20),
                     labels = function(x) paste0(x, "%")) + 
  #scale_color_manual(values = c("Control" = "#A2C2E0", "Case" = "#F5A3A0")) +
  #scale_color_manual(values = c("Control" = "#1f77b4", "Case" = "#ff7f0e")) +
  scale_color_manual(values = c("Control" = "#6caabf", "Case" = "#ff8c42")) +
  theme_bw() +
  theme(
    plot.title = element_blank(),
    axis.title.x = element_blank(),
    legend.position = "right",
    legend.text = element_text(size = 9),
    legend.title = element_text(size = 10),
    ) +
  ylab("% of non-resident fungi per 3000 reads") +
  
  # Add sample size annotations in the middle of each panel
  geom_text(data = df.annotation, 
            aes(x = 1.5, y = 85, label = paste0("Case: ", n_Case, "\n Control: ", n_Control)),
            size = 2.5, color = "black", inherit.aes = FALSE)

print(p1)

ggsave("src-plots/prevalence-abundance.png", 
       plot = p1, width = 12, height = 18, dpi = 600)


## Plot 2
# Calculate the average percentage of non-resident reads for "Case" and "Control" groups
df.averages <- df.readcounts %>%
  group_by(Project_ID) %>%
  summarise(
    avg_case = mean(percentage_nonresident_reads_new[Case_Control == "Case"]),
    avg_control = mean(percentage_nonresident_reads_new[Case_Control == "Control"]),
    sd_case = sd(percentage_nonresident_reads_new[Case_Control == "Case"]),
    sd_control = sd(percentage_nonresident_reads_new[Case_Control == "Control"])
    #Disease_Level_1 = first(Disease_Level_1)
  )

custom_theme <- theme(
  panel.background = element_rect(fill = "gray95", color = NA),  # Light gray background
  panel.grid.major = element_line(color = "white"),  # White major grid lines
  panel.grid.minor = element_line(color = "white", linetype = "dotted"),  # White minor grid lines
  plot.background = element_rect(fill = "white", color = NA)  # White plot background
)

# Create the scatter plot
p2 <- ggplot(df.averages, aes(x = avg_control, y = avg_case)) +
  geom_errorbar(aes(ymin = avg_case - sd_case, ymax = avg_case + sd_case), 
               color = "red", width = 0.01, linetype = "longdash", size = 0.2) +
  geom_errorbarh(aes(xmin = avg_control - sd_control, xmax = avg_control + sd_control), 
                 color = "red", height = 0.01, linetype = "longdash", size = 0.2) + 
  geom_point(size = 1.2, color = "black") +
  geom_abline(slope = 1, intercept = 0, linetype = "solid", linewidth = 0.5, color = "darkgray") +  # Diagonal reference line
  scale_x_continuous(limits = c(-25, 100), breaks = seq(0, 100, by = 25)) +
  scale_y_continuous(limits = c(-25, 100), breaks = seq(0, 100, by = 25)) +
  theme_minimal() +
  labs(x = "Avg. % of non-resident fungal reads in controls", 
       y = "Avg. % of non-resident fungal reads in cases") +
  custom_theme

print(p2)

ggsave("src-plots/meta-analysis.png", 
       plot = p2, width = 8, height = 8, dpi = 600)
