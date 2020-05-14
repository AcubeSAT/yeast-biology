# A function for growth analysis that takes as inputs:

# (i) a path with a .csv file that has the respective timepoints (in the first column) and the OD measurements of the desired strains 
# (ii) a number of replicates for each strain
# (iii) user-defined values/timepoints of OD measurements with cells in the exponential phase (straight line in the linear model) that will be used in the linear regression model (and to calculate the maximal growth rate)

# Note: Input (iii) should be decided after the plotting step, but for convencience in our case, it can be defined here retroscectively.

# The outputs are individual and cumulative growth curves (OD versus time), the linear model fit summary and maximal growth rate/doubling time for each strain.

growth_analysis <- function(growth_data_path, number_of_replicates, index_timepoints_exp){
  
  # Load packages
  
  library(ggplot2)
  library(tidyverse)
  library(cowplot)
  
  # Read & inspect data
  
  growth_data <- read.csv(growth_data_path, header = TRUE)
  print(head(growth_data))
  
  # Change column name for time
  
  colnames(growth_data)[1] <- "Time"
  
  # Extract strain names from headers
  
  strain_names <- gsub("_.*", '', colnames(growth_data)[-1])
  print(strain_names)
  
  # Prepare the title for the OD-plots
  
  Title_Part_1 <- "Growth curve of GFP-tagged"
  
  # Prepare relevant objects
  
  strains_list <- list()
  g_list <- list()
  lm_fit_strains <- list()
  doubling_time <- list()
  
  for(i in unique(strain_names)){
    
    # Calculate means (and log-means) of the replicate OD measurements for every strain
    
    growth_data %>% select(contains(i)) -> strains_list[[i]]
    strains_list[[i]] %>% mutate(OD_mean = rowMeans(select(., 1:number_of_replicates))) %>% mutate(log_OD_mean = log(OD_mean)) -> strains_list[[i]]
    
    # Plot the OD versus time for every strain
    
    g_list[[i]] <- ggplot(strains_list[[i]], aes(x=growth_data[,1], y=OD_mean)) + 
      geom_point(color="darkorange") + 
      
      # Color the graph area with the values that do not belong in the exponential phase
      
      geom_rect(aes(xmin = index_timepoints_exp[1], xmax = Inf, ymin = -Inf, ymax = Inf), fill = "dodgerblue2", alpha = 0.03) +
      theme_bw()+
      # geom_smooth(method="lm", se=F, color="springgreen3") + 
      labs(y="OD", 
           x="Time (h)", 
           title=paste(Title_Part_1, i))
    
    # Print each plot to quickly inspect it
    
    print(g_list[[i]])
    
    # Fit the OD values for each strain
    
    lm_fit_strains[[i]] <- lm(log_OD_mean ~ growth_data[index_timepoints_exp,1], strains_list[[i]][index_timepoints_exp,])
    
    # Print the summary of the model fit for each strain
    
    print(summary(lm_fit_strains[[i]])$coefficients)
    
    # Calculate maximal growth rate for each strain
    
    mu_max <- summary(lm_fit_strains[[i]])$coefficients[2,1]
    
    # Calculate and print doubling time (in minutes) for each strain
    
    doubling_time[[i]] <- (log(2)/mu_max)*60
    print(doubling_time[[i]])
    
  }
  
  # Combine the plots for each respective strain together
  
  plot_grid(g_list[[1]]+guides(fill=FALSE), g_list[[2]], g_list[[3]], g_list[[4]])
  
}
