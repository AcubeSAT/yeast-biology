# A function for growth analysis that takes as inputs:

# (i) a `data_path` of a .csv file with the experimental measurements
# (ii) a `new_colnames` vector that defines the desired column names in your experimental measurements' .csv
# (iii) a `design_path` of a .csv file that includes the experimental specifications of each sample and acts as a LUT
# (iv) an `experimental_specs` vector that has the different experimental parameters/conditions, found in the LUT (e.g. Replicate, Strain, Induction)

# Note: Make sure to set your working directory upstream accordingly.

# The output is a data frame with samples annonated with the respective experimental specifications, timepoints and measurements (mean/sd of any replicates).

growth_analysis_LUT <- function(data_path, new_colnames, design_path, experimental_specs){
  
  # Load packages
  
  require(ggplot2)
  require(tidyverse)
  require(viridis)
  require(dplyr)
  require(tidyr)
  require(data.table)
  
  # Load data & preprocessing
  
  growth_data <- read.csv(data_path, header = TRUE)
  
  setDT(growth_data)
  setnames(growth_data, old = colnames(growth_data), new = new_colnames)
  
  # Append replicate indexes from a LUT (experimental design/specifications)
  
  # Use the very helpful addNewData.R from https://gist.github.com/dfalster/5589956
  
  source("addNewData.R")
  growth_data <- addNewData(design_path, growth_data, experimental_specs)
  
  # Behold some R magic
  
  growth_data %>%
    gather(key, value, "0":last(new_colnames)) %>%
    spread(Sample, value) ->  growth_data
  
  growth_data %>%
    mutate(OD = fcoalesce(growth_data[,c((length(experimental_specs) + 2):length(growth_data))])) %>%
    select(Replicate, Strain, Cycles, key, OD) -> growth_data
  
  colnames(growth_data)[(length(experimental_specs) + 1)] <- "Timepoint"
  
  # Calculate mean & sd of replicates
  
  # Function to calculate mean, sd
  data_summary <- function(data, varname, groupnames){
    require(plyr)
    summary_func <- function(x, col){
      c(mean = mean(x[[col]], na.rm=TRUE),
        sd = sd(x[[col]], na.rm=TRUE))
    }
    data_sum<-ddply(data, groupnames, .fun=summary_func,
                    varname)
    data_sum <- rename(data_sum, c("mean" = varname))
    return(data_sum)
  }
  
  # Save the summarized data
  
  growth_data_summary <- data_summary(growth_data, c("OD"),
                                      groupnames=c(experimental_specs[experimental_specs != "Replicate"], "Timepoint"))
  
  return(growth_data_summary)
  
}