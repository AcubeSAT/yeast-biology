# Example growth analysis of 4 yeast strains from the Yeast GFP library (GFP-tagged TAF10, TEF2, ALG9, UBC6) with 2 replicates each

source("yeast-biology/growth_analysis.R") 

growth_analysis("yeast-biology/sc_growth_data_example.csv", 2, 4:9)

