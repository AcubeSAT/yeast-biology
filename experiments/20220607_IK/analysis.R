# Load libraries
library(dplyr)
library(tidyverse)
library(ggplot2)
library(RColorBrewer)
library(wesanderson)

# Set paths
data_path <-
data_filename <- "20220607_IK_Data_annotated"

# Set wd
setwd(data_path)

# Load data
data <- read.csv(file.path(data_path, file.path(data_filename, "csv", fsep = ".")), header = TRUE, stringsAsFactors = FALSE)

# Remove NAs
data <- na.omit(data) 

# Choose color palettes
gp1 <- wes_palettes$Darjeeling1
gp2 <- wes_palettes$Darjeeling2

data <- filter(data, Type == "Spores")

# Plotting
ggplot(data, aes(x = as.factor(Condition), y = as.numeric(Colonies), fill = Condition)) +
    geom_bar(stat="identity", position = position_dodge()) +
    theme_bw(base_size = 17) +
    facet_wrap(~State+Medium) +
    scale_fill_manual(values = wes_palette(n = 3, name = "Darjeeling1")) +
    labs(x = "Treatment", y = "Colony count") +
    theme(strip.text = element_text(face = "bold", color = gp2[2],
                                  hjust = 0, size = 20),
        strip.background = element_rect(fill = "#FFFFFF"))

ggsave("20220607.pdf")

