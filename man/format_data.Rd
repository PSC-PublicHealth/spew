% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/format.R
\name{format_data}
\alias{format_data}
\title{Format data before entering make}
\usage{
format_data(data_list, data_group, verbose = TRUE)
}
\arguments{
\item{data_list}{list which contains all of the data from 
the read_data function}

\item{data_group}{character vector indiciating which group 
the data is located in}

\item{verbose}{whether to print out the timings}
}
\value{
data_list list with an updated pop_table element which 
indicates the places in which we will generate synthetic ecosystems.
The table should include three columns: the place_id, number of households 
to sample, and the puma id.  Note the the place_id should correspond to 
the place_id from the shapefile
}
\description{
Format data before entering make
}
