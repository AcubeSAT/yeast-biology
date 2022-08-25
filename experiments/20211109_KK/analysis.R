# Load libraries
library(dplyr)
library(tidyverse)
library(ggplot2)
library(RColorBrewer)
library(wesanderson)

# Set paths
data_path <-
data_filename <- "20211109_KK_Data_annotated"

# Set wd
setwd(data_path)

# Load data
data <- read.csv(file.path(data_path, file.path(data_filename, "csv", fsep = ".")), header = TRUE, stringsAsFactors = FALSE)

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

data_stats <- data_summary(data, varname = c("Colonies_OpenCFU"),
                                          groupnames = c("State", "Ether", "Lyticase"))

# Choose color palettes
gp1 <- wes_palettes$Darjeeling1
gp2 <- wes_palettes$Darjeeling2

# Plotting
ggplot(data_stats, aes(x = as.factor(Lyticase), y = as.numeric(Colonies_OpenCFU), fill = State)) +
    geom_bar(stat="identity", position = position_dodge()) +
    geom_errorbar(aes(ymin = Colonies_OpenCFU - sd, ymax = Colonies_OpenCFU + sd), width = .2,
                 position = position_dodge(.9)) +
    theme_bw(base_size = 17) +
    facet_wrap(~Ether) +
    scale_fill_manual(values = wes_palette(n = 3, name = "Darjeeling1")) +
    labs(x = "Time (min)", y = "Colony count") +
    theme(strip.text = element_text(face = "bold", color = gp2[2],
                                  hjust = 0, size = 20),
        strip.background = element_rect(fill = "#FFFFFF"))

ggsave("20211109_OpenCFU.pdf")

