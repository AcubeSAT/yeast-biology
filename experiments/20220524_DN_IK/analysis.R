# Load libraries
library(dplyr)
library(tidyverse)
library(ggplot2)
library(RColorBrewer)
library(wesanderson)

# Set paths
data_path <- 
data_filename <- 
design_filename <-

# Set timepoints
timepoints <- 36

# Set wd
setwd(data_path)

# Data preprocessing
source("data_preprocessing.R")
data_annotated <- data_preprocessing(data_path, data_filename, design_filename, timepoints)

# Select data for downstream analysis-plotting
data_analysis_no_spo <- filter(data_annotated, 
(Medium %in% c("SD-HIS-LEU") & Trehalose %in% c("No", "Sporulation Medium")))
data_analysis_growth <- filter(data_annotated, 
(Medium %in% c("SD-HIS-LEU") & Trehalose %in% c("Growth Medium")))

# Create df with OD of the blank media
data_blank_no <- filter(data_analysis_no_spo,
(Strain %in% c("Blank") & Replicate %in% c("1")))
data_blank_growth <- filter(data_analysis_growth,
(Strain %in% c("Blank") & Replicate %in% c("1")))

# Subtract OD of blank media from samples (to correct for medium absorbance)
data_analysis_no_spo %>% group_by(Well, Replicate, Strain, Trehalose, Condition, Medium) %>%
summarize(Time = Time, OD_corrected = 
as.numeric(OD) - as.numeric(data_blank_no$OD)) -> data_analysis_no_spo_corrected

data_analysis_growth %>% group_by(Well, Replicate, Strain, Trehalose, Condition, Medium) %>% 
summarize(Time = Time, 
OD_corrected = as.numeric(OD) - as.numeric(data_blank_growth$OD)) -> data_analysis_growth_corrected

data_analysis_corrected <- rbind(data_analysis_no_spo_corrected, data_analysis_growth_corrected)

# Calculate statistics
data_summary <- function(data, varname, groupnames){
  require(plyr)
  summary_func <- function(x, col){
    c(mean = mean(x[[col]], na.rm = TRUE),
      sd = sd(x[[col]], na.rm = TRUE))
  }
  data_sum<-ddply(data, groupnames, .fun = summary_func,
                  varname)
  data_sum <- rename(data_sum, c("mean" = varname))
  return(data_sum)
}

data_stats <- data_summary(data_analysis_corrected, varname = c("OD_corrected"),
                                          groupnames = c("Time", "Strain", "Trehalose", "Condition"))

data_plot <- filter(data_stats, 
(Strain %in% c("Y7039 x YHL033C")))

# Choose color palettes
gp1 <- wes_palettes$Darjeeling1
gp2 <- wes_palettes$Darjeeling2

# Plotting
ggplot(data_plot, aes(x = as.numeric(Time), y = as.numeric(OD_corrected)))+
    geom_point(aes(shape = Trehalose, color = Condition)) +
    geom_smooth(aes(color = Condition), se = FALSE) +
    theme_bw(base_size = 17) +
    scale_color_manual(values = wes_palette(n = 3, name = "Darjeeling1")) +
    #scale_color_brewer(palette = "Dark2") +
    labs(x = "Time (hours)", y = "OD") +
    theme(strip.text = element_text(face = "bold", color = gp2[2],
                                  hjust = 0, size = 20),
        strip.background = element_rect(fill = "#FFFFFF"))


ggsave("20220524_DN_IK_SD_HIS_LEU.pdf")