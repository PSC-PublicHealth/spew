% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summarize_spew.R
\name{plot_syneco}
\alias{plot_syneco}
\title{Plot Synthetic Ecosystem}
\usage{
plot_syneco(input_data, syneco, region_name = NULL, color_list = list(bds =
  "white", interior = "gray60", roads = "gray10", agents = "darkorchid3", envs =
  c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00",
  "#CC79A7")))
}
\arguments{
\item{input_data}{a list of the essential data and possibly supplementary data, shapefile must be one of the names}

\item{syneco}{the outputted synthetic ecosystem data from spew}

\item{region_name}{string, will become the title of the plot}

\item{color_list}{optional list of colors to provide to the synthetic ecosystem.  This must be a list with the following components, "bds", "interior", "roads", "agents", "envs" where each entry in the list is a color or vector of colors}
}
\value{
plot of the synthetic ecosystem
}
\description{
Plot Synthetic Ecosystem
}
\examples{
data(tartanville)

tartanville_syneco <- spew(tartanville$pop_table, tartanville$shapefile, 
                           tartanville$pums_h, tartanville$pums_p)
                           
plot_syneco(tartanville, tartanville_syneco, region_name = "Tartanville")

}
