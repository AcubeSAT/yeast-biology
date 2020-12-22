- [Description](#description)
- [Growth Analysis](#growth-analysis)
  - [Introduction](#introduction)
  - [ACubeSAT example](#acubesat-example)
  - [Code](#code)
  - [Example](#example)
- [Resources](#resources)
- [Bibliography](#bibliography)

## Description

A repository to host code and data regarding molecular biology-related analysis with a focus on yeast strains, including growth analysis and bioinformatic pipelines. Here you will currently find some R code to analyze the growth of yeast strains, as well as various figures and `.drawio` files regarding yeast biology-centered parts of the AcubeSAT mission

🎐🧬 Benchling: https://benchling.com/organizations/acubesat/

## Growth Analysis

### Introduction

The conventional microbial population growth in bulk liquid medium is a very well-studied subject `[1]`. The generic four-phase pattern of a standard bacterial population growth is known as the **growth curve**. The **lag phase** is when microorganisms initially adjust to a new environment; for example when introduced into a test tube with new conditions regarding temperature, pH, sugar concentration, etc. The log or **exponential phase** is when cells start dividing regularly and the population rises rapidly, reaching maximum growth rate. As the time passes and cell density increases (in a closed system), nutrients diminish. Other changes, for example pH changes, occur due to the microbial high metabolic rates. Moreover, death rate starts increasing until it *matches* the growth rate. This phase, called **stationary phase**, is characterized by a constant living cell population. The following phase is denoted as **death phase**, which can be described as the situation whereon death rate surpasses growthrate and population declination initiates `[2]`.
### ACubeSAT example

The ACubeSAT mission will host a scientific payload, wherein a custom-made lab-on-a-chip will be situated, to allow for multiplexed cell culturing and analysis. This PDMS chip will host *Saccharomyces cerevisiae* yeast cells in spore formation. Before the first in-orbit experiment commences, the cells might remain stored inside the spacecraft for up to more than two years. To ensure the cells will still grow in a consistent and timely manner when the time comes, we probed the growth behaviour of the `TAF10-GFP MATa` strains by conducting a growth analysis on both cells and spores after 1 year of storage in RT.

### Code

To perform the growth analysis, we can use the `src/growth_analysis/growth_analysis.R` file. From there, the `growth_analysis()` function takes as **inputs**:

1. a path with a `.csv` file that has the respective **timepoints** (in the *first* column) and the **OD measurements** of the desired strains 
2. a number of **replicates** for each strain
3. user-defined values/timepoints of OD **measurements with cells in the exponential phase** (straight line in the linear model) that will be used in the linear regression model (and to calculate the maximal growth rate)

Note: Input (3) should be decided after the plotting step, *but* for convencience in our case, it can be defined here *retrospectively*.

The **outputs** are:
1. **individual** and **cumulative growth curves** (OD versus time),
2. the **linear model fit summary** and
3. **maximal growth rate/doubling time** for *each* strain.

### Example

As an example, consider conducting a growth analysis of 4 yeast strains from the Yeast GFP library (GFP-tagged TAF10, TEF2, ALG9, UBC6) with 2 replicates each:

```r
# path: /yeast-biology/src/growth_analysis/
source("growth_analysis.R") 
growth_analysis("example.csv", 2, 4:9)
```

An example `.csv` file containing the data to be parsed is `example.csv`, with contents:
|Time_hr|TAF10_replicate_1_OD|TAF10_replicate_2_OD|TEF2_replicate_1_OD|TEF2_replicate_2_OD|ALG9_replicate_1_OD|ALG9_replicate_2_OD|UBC6_replicate_1_OD|UBC6_replicate_2_OD|
|-------|--------------------|--------------------|-------------------|-------------------|-------------------|-------------------|-------------------|-------------------|
|0      |0.05                |0.05                |0.05               |0.05               |0.05               |0.05               |0.05               |0.05               |
|1      |0.271               |0.181               |0.295              |0.125              |0.278              |0.176              |0.242              |0.141              |
|2      |0.299               |0.208               |0.285              |0.156              |0.287              |0.21               |0.268              |0.173              |
|3      |0.3                 |0.29                |0.23               |0.231              |0.307              |0.3                |0.23               |0.257              |
|4      |0.418               |0.41                |0.325              |0.333              |0.421              |0.413              |0.307              |0.365              |
|5.5    |0.66                |0.66                |0.546              |0.562              |0.675              |0.678              |0.501              |0.618              |
|6.6    |1.155               |1.135               |0.75               |0.776              |1.125              |1.25               |0.651              |1.015              |
|7.5    |1.51                |2                   |1.31               |1.435              |1.55               |1.75               |1.1                |1.47               |
|8.5    |1.89                |2.1                 |1.795              |1.81               |2.085              |2.34               |1.49               |1.965              |

Example **output figure**:
![growth curve][growth-curve-example]

[growth-curve-example]: assets/growth_curves_example.png "Example Saccharomyces cerevisiae Growth Curve"

## Resources

* **Protocols** and **workflows** for the wet lab experiments can be found on our [Benchling](https://benchling.com/organizations/acubesat/).

## Bibliography

1: Buchanan, R. L., Whiting, R. C., & Damert, W. C. (1997). When is simple good enough: a comparison of the Gompertz, Baranyi, and three-phase linear models for fitting bacterial growth curves. Food microbiology, 14(4), 313-326.

2: Wang, L., Fan, D., Chen, W., & Terentjev, E. M. (2015). Bacterial growth, detachment and cell size control on polyethylene terephthalate surfaces. Scientific reports, 5(1), 1-11.