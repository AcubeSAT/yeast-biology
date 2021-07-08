# Make sure to launch the R process from the
# project top-level directory for here() to work.
# If you can't do that, feel free to play with rprojroot:
# https://github.com/jennybc/here_here#tldr

suppressWarnings(suppressPackageStartupMessages(library(docopt)))

"R script to produce interactive YGL localization plots.

Usage:
  dea.R (-h | --help)
  dea.R (-v | --version)

Options:
  -h --help     Show this screen.
  -v --version     Show version.

" -> doc
arguments <- docopt(doc, version = "YGL-Loc 0.1")

suppressWarnings(suppressPackageStartupMessages({
    library(biomaRt)
    library(dplyr)
    library(htmlwidgets)
    library(ggplot2)
    library(glue)
    library(here)
    library(logger)
    library(plotly)
    library(R.matlab)
}))


datafiles_pathname <- "singlecell_datafiles"

extract_loc_means <- function(sgd_systematic) {
    scfilename <- paste(sgd_systematic, "_MMS_high.mat", sep = "")
    scfilepath <- here::here(
        datafiles_pathname,
        scfilename
    )

    data <- R.matlab::readMat(scfilepath)
    locmean <- data$scData[3][[1]]

    return(locmean)
}

extract_scfilenames <- function() {
    names = list()
    i <- 1
    for (filename in list.files(here::here(datafiles_pathname))) {
       names[i] <- (unlist(strsplit(filename, split='_', fixed=TRUE))[1])
       i <- i + 1
    }
    return(unlist(names))
}

convert_to_genename <- function(sgd_systematic) {
    SGD_path <- here::here("SGD_features.tab")
    SGD <- readLines(SGD_path)
    return(strsplit(grep(sgd_systematic, SGD, value = TRUE), "\t")[[1]][5])
}

loc_means_to_df <- function(loc_means, shapes, n_tpoints = 40) {
    names <- rep(shapes, n_tpoints)
    timepoints <- rep(1:n_tpoints, each = length(shapes))
    vals <- unlist(lapply(loc_means, function(i) unlist(i, recursive = TRUE)))

    df <- data.frame(names, timepoints)
    df$values <- vals

    return(df)
}

plot_df <- function(df) {
    p <- df %>%
        ggplot( aes(x=timepoints, y=values, group=names, color=names)) +
            geom_line()
    l <- ggplotly(p)
    return(l)
}

save_plot <- function(plot, path) {
    htmlwidgets::saveWidget(plot, path)
}

main <- function() {
    plot_dir <- here::here("plots")
    for (sgd_systematic in extract_scfilenames()) {
        genename <- convert_to_genename(sgd_systematic)
        loc_means <- extract_loc_means(sgd_systematic)
        
        shapes <- c("Periphery",
            "Structure",
            "Punctate",
            "Disk",
            "Corona",
            "Homogeneous")
        loc_means <- loc_means_to_df(loc_means, shapes)

        plot_path <- paste(genename, ".html", sep="")
        save_plot(plot_df(loc_means), here::here(plot_dir, plot_path))
    }
}

main()
