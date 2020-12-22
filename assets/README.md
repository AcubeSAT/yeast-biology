- [Description](#description)
- [Images](#images)
  - [Growth curve](#growth-curve)
  - [Light pathways](#light-pathways)
  - [Biomolecular system modules](#biomolecular-system-modules)
  - [Data analysis and interpretation](#data-analysis-and-interpretation)
  - [Sporulation workflow](#sporulation-workflow)
  - [Preparation of the biomolecular modules](#preparation-of-the-biomolecular-modules)
  - [Yeast GFP library construction strategy](#yeast-gfp-library-construction-strategy)
- [Bibliography](#bibliography)

## Description

In the `assets` folder you can, for now, find some images that are essentially the renders of the `.drawio` files in the `drawio` folder

## Images

### Growth curve

This is an example **growth curve** of *Saccharomyces cerevisiae* yeast strains, as explained in the [repository README](https://gitlab.com/acubesat/su/yeast-biology/-/blob/master/README.md#growth-analysis), generated by running the [`growth_analysis()` function](https://gitlab.com/acubesat/su/yeast-biology/-/blob/master/src/growth_analysis/growth_analysis.R#L11) from [`src/growth-analysis/growth-analysis.R`](https://gitlab.com/acubesat/su/yeast-biology/-/blob/master/src/growth_analysis/growth_analysis.R) on the [`src/growth-analysis/example.csv`](https://gitlab.com/acubesat/su/yeast-biology/-/blob/master/src/growth_analysis/example.csv) file

![growth curve][growth-curve-example]

### Light pathways

To collect experimental readout, the cells are first shed with **blue excitation light**. GFP fluoresces with **green light** which is in turn captured by the **CMOS camera sensor**. Two **narrow bandpass filters** are employed, one for the *excitation* (blue) and one for the *emission* (green) light, respectively:

![optics pathway][optics-pathway]

### Biomolecular system modules

The **biomolecular system** of the payload consists of two *modules*:
1. The **primary** module, a predetermined collection of `100 ≤ N ≤ 190` distinct *S. cerevisiae* strains from the [Yeast GFP Library](https://yeastgfp.yeastgenome.org/). The Yeast GFP Library includes approximately 75% of the *S. cerevisiae* full-length Open Reading Frames (ORFs), tagged at the C-terminus with the coding region of *Aequorea victoria* GFP mutant (S65T), under the control of their native, endogenous promoter [1]. Details about the library construction can be found [below](https://gitlab.com/acubesat/su/yeast-biology/assets/-/blob/master/README.md#yeast-gfp-library-construction-strategy)
2. The **secondary** module is based on a reengineered version of a previously described **synthetic gene circuit** [2], which is integrated in two *S. cerevisiae* strains. This module acts as an indicator of a **cell's damage response** to harmful stimuli. It essentially "hijacks" the cell's *DNA* damage signaling cascades to actuate a *positive feedback loop* leading to the production of a *fluorescent protein*. The positive feedback loop sustains fluorescent protein production in the absence of DNA damage signal, as well as during cell division, as the molecules actuating the feedback loop are *inherited* by the daughter cells. Therefore, *every* progeny cell will continue to express the fluorescent protein, allowing identification of cells in which mutations have occurred along with their progenies, thus enabling comparisons of protein levels between healthy and damaged cells. A more detailed view of this synthetic circuit can be found in our [Benchling](https://benchling.com/acubesat/f/lib_oZmBebmQ-science-unit/seq_nbJ9S7Ae-memory-circuit/edit). The DNA sequences of this circuit have been designed in a modular fashion, according to theMoClo YTK assembly standard [3], with optimized genetic parts as components [2]

![primary secondary payload][primary-secondary-payload]

### Data analysis and interpretation

For the images generated as mentioned [above](https://gitlab.com/acubesat/su/yeast-biology/assets/-/blob/master/README.md#light-pathways), a commonly used [4] analysis pipeline is going to be employed, including the following steps:
- background extraction, 
- enhancement and
- feature extraction. 
 
This analysis can be complemented with *auto-fluorescence* measurement and deconvolution, to measure and account for the distribution of the Yeast GFP Library cells auto-fluorescence [5]. These results are to be combined with the on-board radiation sensor measurements and the measurements from the DNA-damage sensing circuit to construct phenotypic profiles of cells strains and infer the global proteome's response to orbit conditions

![radiation analysis science][radiation-analysis-science]

### Sporulation workflow

The AcubeSAT payload has been designed to accommodate the **long-term storage**, both on Earth *and* in-orbit, and subsequent growth and imaging of the yeast cells to be studied. To ensure **cell survivability** during launch and their **efficient storage** for the duration of the mission, strains (ΜΑΤa type) of the Yeast GFP Library [2], tagged with the pre-determined genes of interest, are *mated* with cells of a different mating type (MATα type) to undergo **sporulation**. Yeast spores have been documented to survive in extreme environmental conditions and are promising candidates for the preservation of yeast viability over the course of long-duration space missions

The *haploid* yeast cells with different mating typesform *diploid* yeast cells, which after **nitrogen** and **carbon starvation**, undergo *gametogenesis*, commonly defined as sporulation. During sporulation, haploid nuclei are *packed* into resistant spores. Square boxes denote chromosome/gene copies; specifically green is used for the presenceand white for the absence of the ORF-GFP::His3 locus

![sporulation library][sporulation-library]

### Preparation of the biomolecular modules

The cells in each biomolecular system module have to be prepared before growth and observation via imaging; this preparation is split into distinct stages on Earth and in-orbit

![sporulation library orbit][sporulation-library-orbit]

### Yeast GFP library construction strategy

To construct the yeast GFP library [1], a GFP tag together with the HIS3MX6 selection marker gene were generated via PCR and inserted through homologous recombination at the C-terminus end of each ORF. Approximately 75% of the *S. cerevisiae* proteome was tagged as thus, resulting in respective C-terminally GFP-tagged proteins. Figure acquired and modified from [1]

![yeast gfp library][yeast-gfp-library]

[growth-curve-example]: growth_curves_example.png "Example Saccharomyces cerevisiae Growth Curve"
[optics-pathway]: optics_pathway.png "Pathways of Blue and Green light inside the payload assembly"
[primary-secondary-payload]: primary_secondary_payload.png "Biomolecular System modules and their respective genetic constructs"
[radiation-analysis-science]: radiation_analysis_science.png "High-level data analysis workflow to infer radiation effects on the cells of interest"
[sporulation-library-orbit]: sporulation_library_orbit.png "Pre-launch and in-orbit preparation of the Biomolecular Modules"
[sporulation-library]: sporulation_library.png "Typical sporulation workflow"
[yeast-gfp-library]: yeast_gfp_library.png "Strategy for Yeast GFP library construction "

## Bibliography

1: Huh, W. K., Falvo, J. V., Gerke, L. C., Carroll, A. S., Howson, R. W., Weissman, J. S., & O'Shea, E. K. (2003). Global analysis of protein localization in budding yeast. Nature, 425(6959), 686-691.

2: Burrill, D. R., & Silver, P. A. (2011). Synthetic circuit identifies subpopulations with sustained memory of DNA damage. Genes & development, 25(5), 434-439.

3: Lee, M. E., DeLoache, W. C., Cervantes, B., & Dueber, J. E. (2015). A highly characterized yeast toolkit for modular, multipart assembly. ACS synthetic biology, 4(9), 975-986.

4: Bankhead, P. (2014). Analyzing fluorescence microscopy images with ImageJ. ImageJ, 1(195), 10-1109.

5: Dénervaud, N., Becker, J., Delgado-Gonzalo, R., Damay, P., Rajkumar, A. S., Unser, M., ... & Maerkl, S. J. (2013). A chemostat array enables the spatio-temporal analysis of the yeast proteome. Proceedings of the National Academy of Sciences, 110(39), 15842-15847.