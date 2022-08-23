# A function for preprocessing timecourse data from a plate reader. Currently this script works for 96-well plates and the Tecan Spark multimode microplate reader.

# The inputs are:

# (i) a path that includes 3 .csv files (data, experimental design, plate template of choice)
# (ii) the filename of the data
# (iii) the filename of the experimental design
# (iv) the number of timepoints

data_preprocessing <- function(data_path, data_filename, design_filename, timepoints){

  # Load libraries
  library(tidyverse)

  # Load & save data
  data <- read.csv(file.path(data_path, file.path(data_filename, "csv", fsep = ".")), header = FALSE, stringsAsFactors = FALSE)

  # Remove columns with only NAs
  data %>% select_if(~sum(!is.na(.)) > 0) -> data

  # Data wrangling
  data <- data.frame(stack(data[2:ncol(data)]))
  data$ind <- NULL

  # Delete every 9rd row starting from the 1st
  data %>% filter(row_number() %% 9 != 1) -> data

  # Load plate template
  plate_template <- read.csv(file.path(data_path, "96_Plate_Template.csv"), header = TRUE, stringsAsFactors = FALSE)

  # Create plate mask
  plate_mask <- as.data.frame(sapply(plate_template, rep.int, times = timepoints))

  plate_mask <- data.frame(stack(plate_mask[2:ncol(plate_mask)]))
  plate_mask$ind <- NULL

  # Add timepoints
  time <- rep(seq(from = 0, to = timepoints*2-2, by = 2), each = nrow(plate_template))
  time <- data.frame(time)

  # Bind data with plate mask
  data_plate <- cbind(plate_mask,data,time)

  # Name columns
  colnames(data_plate) <- c('Well','OD','Time')

  # Load design file
  design <- read.csv(file.path(data_path, file.path(design_filename, "csv", fsep = ".")), header=TRUE, stringsAsFactors=FALSE)
 
  # Append design info to plate data
  data_annotated <- left_join(data_plate, design, by = "Well")

  # Remove NAs
  data_annotated <- na.omit(data_annotated)

  # Save dataframe as .csv
  write.csv(data_annotated, paste0(data_filename, "_annotated.csv"))

  return(data_annotated)

}