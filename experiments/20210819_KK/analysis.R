# Load libraries
library(dplyr)
library(tidyverse)
library(ggplot2)
library(RColorBrewer)
library(wesanderson)

# Set paths
data_path <- 
data_OD_filename <- "20210819_KK_Data_OD_annotated"
data_colonies_filename <- "20210819_KK_Data_Colonies_annotated"

# Set wd
setwd(data_path)

# Load data
data_OD <- read.csv(file.path(data_path, file.path(data_OD_filename, "csv", fsep = ".")), header = TRUE, stringsAsFactors = FALSE)

data_colonies <- read.csv(file.path(data_path, file.path(data_colonies_filename, "csv", fsep = ".")), header = TRUE, stringsAsFactors = FALSE)


# Calculate statistics
data_summary <- function(data, varname, groupnames){
  require(plyr)
  summary_func <- function(x, col){
    c(mean = mean(x[[col]], na.rm = TRUE),
      sd = sd(x[[col]], na.rm = TRUE))
  }
  data_sum <- ddply(data, groupnames, .fun = summary_func,
                  varname)
  data_sum <- rename(data_sum, c("mean" = varname))
  return(data_sum)
}

data_OD_stats <- data_summary(data_OD, varname = c("OD"),
                                          groupnames = c("Time", "Strain", "Cycles", "Temperature"))

                                          
data_colonies_stats <- data_summary(data_colonies, varname = c("Colonies"),
                                          groupnames = c("Strain", "Cycles", "Temperature"))

data_OD_stats$Cycles <- as.factor(data_OD_stats$Cycles)
data_colonies_stats$Cycles <- as.factor(data_colonies_stats$Cycles)

data_OD_plot <- filter(data_OD_stats, Temperature %in% "-20")
data_colonies_plot <- filter(data_colonies_stats, Temperature %in% "-20")

# Choose color palettes
gp1 <- wes_palettes$IsleofDogs1

# Plotting (OD)
ggplot(data_OD_plot, aes(x = Time, y = OD))+
    geom_point(aes(color = Cycles)) +
    geom_smooth(aes(color = Cycles), se = FALSE) +
    geom_errorbar(aes(ymin = OD - sd, ymax = OD + sd), width=.2,
                 position = position_dodge(.9)) +
    theme_bw(base_size = 17) +
    facet_wrap(~Strain) +
    scale_color_manual(values = wes_palette(n = 6, name = "IsleofDogs1")) +
    #scale_color_brewer(palette = "Dark2") +
    labs(x = "Time (hours)", y = "OD") +
    theme(strip.text = element_text(face = "bold", color = gp1[1],
                                  hjust = 0, size = 20),
        strip.background = element_rect(fill = "#FFFFFF")) +
    scale_x_continuous(breaks = seq(0, 12, 2))

ggsave("20220819_KK_20_Growth_Curve.pdf")


# Plotting (Colonies)
ggplot(data_colonies_plot, aes(x = Cycles, y = Colonies)) +
    geom_bar(stat = "summary",
            fun.y = "mean", fill = gp1[1], color = "black") +
    geom_errorbar(aes(ymin = Colonies - sd, ymax = Colonies + sd), width=.2,
                 position = position_dodge(.9)) +
    theme_bw(base_size = 17) +
    facet_wrap(~Strain) +
    labs(x = "Cycles", y = "Colony count") +
    theme(strip.text = element_text(face = "bold", color = gp1[1],
                                  hjust = 0, size = 20),
        strip.background = element_rect(fill = "#FFFFFF"))

ggsave("20220819_KK_20_Colonies.pdf")

# 