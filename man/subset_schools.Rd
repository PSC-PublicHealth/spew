% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/schools.R
\name{subset_schools}
\alias{subset_schools}
\title{Subset the schools to that of the county}
\usage{
subset_schools(df, schools)
}
\arguments{
\item{df}{subset of people split so all age, grade, 
SCH, and county should be the same in the df}

\item{schools}{list of schools, one data frame of private 
and one of public}
}
\value{
dataframe of subsetted schools to the county and public 
or private
}
\description{
Subset the schools to that of the county
}
