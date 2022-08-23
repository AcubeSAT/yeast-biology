# Load libraries
library(dplyr)
library(tidyverse)
library(ggplot2)
library(RColorBrewer)
library(wesanderson)

# Set paths
data_path <- 
data_filename <- 

# Set wd
setwd(data_path)

# Load & save data
data <- read.csv(file.path(data_path, data_filename), header=TRUE, stringsAsFactors=FALSE)

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

data_stats <- data_summary(data, varname = "OD",
                                          groupnames = c("Time", "Strain", "State", "Medium"))

data_plot <- filter(data_stats, 
(Strain %in% c("Y-33C")))

# Choose color palettes
gp1 <- wes_palettes$Darjeeling1
gp2 <- wes_palettes$Darjeeling2

# Plotting
ggplot(data_plot, aes(x = as.numeric(Time), y = as.numeric(OD)))+
    geom_point(aes(color = Medium)) +
    #geom_smooth(aes(color = Medium), se = FALSE) +
    theme_bw(base_size = 17) +
    facet_wrap(~State) +
    scale_color_manual(values = wes_palette(n = 3, name = "Darjeeling1")) +
    #scale_color_brewer(palette = "Dark2") +
    labs(x = "Time (hours)", y = "OD") +
    theme(strip.text = element_text(face = "bold", color = gp2[2],
                                  hjust = 0, size = 20),
        strip.background = element_rect(fill = "#FFFFFF"))


ggsave("20220505_DN_IK_Y33C.pdf")