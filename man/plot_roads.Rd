% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summarize_spew.R
\name{plot_roads}
\alias{plot_roads}
\title{Plot the roads of the synthetic ecosystem}
\usage{
plot_roads(roads, g = NULL, color_list = list(bds = "white", interior =
  "gray60", roads = "gray10", agents = "darkorchid3", envs = c("#E69F00",
  "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")))
}
\arguments{
\item{roads}{a fortified shapefile object of the roads, ready for plotting in ggplot.}

\item{g}{a ggplot.  Default is NULL.}

\item{color_list}{optional list of colors to provide to the synthetic ecosystem. This must be a list with the following components,  "bds", "interior", "roads", "agents", "envs" where each entry in the list is a color or vector of colors}
}
\value{
a ggplot of the region
}
\description{
Plot the roads of the synthetic ecosystem
}
